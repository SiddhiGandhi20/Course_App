import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseProvider with ChangeNotifier {
  final Map<String, List<Course>> _categoryWiseCourses = {}; // Courses grouped by category
  List<Course> _myCourses = []; // Courses user has enrolled in
  List<Course> _allCourses = []; // All courses

  Map<String, List<Course>> get categoryWiseCourses => _categoryWiseCourses;
  List<Course> get myCourses => _myCourses;
  List<Course> get allCourses => _allCourses;

  final String apiUrl = "http://192.168.29.32:5000/api/courses"; // Updated API URL

  /// ✅ Fetch all courses from the API
  Future<void> fetchAllCourses() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/grouped"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _allCourses = data.map((c) => Course.fromJson(c)).toList();

        _categoryWiseCourses.clear();
        for (var course in _allCourses) {
          _categoryWiseCourses.putIfAbsent(course.category, () => []).add(course);
        }

        debugPrint("✅ Fetched ${_allCourses.length} courses successfully.");
        notifyListeners();
      } else {
        throw Exception("❌ Failed to load courses: ${response.body}");
      }
    } catch (error) {
      debugPrint("⚠️ Error fetching courses: $error");
    }
  }

  /// ✅ Fetch a course by its ID (Updated: Now calls API)
  Future<Course?> fetchCourseById(String courseId) async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/$courseId"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Course.fromJson(data);
      } else if (response.statusCode == 404) {
        debugPrint("⚠️ Course with ID $courseId not found.");
        return null;
      } else {
        throw Exception("❌ Failed to fetch course: ${response.body}");
      }
    } catch (error) {
      debugPrint("⚠️ Error fetching course by ID: $error");
      return null;
    }
  }

  /// ✅ Fetch courses the user has enrolled in
  Future<void> fetchMyCourses(String userId) async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/my-courses/$userId"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _myCourses = data.map((course) => Course.fromJson(course)).toList();

        debugPrint("✅ Enrolled courses fetched: ${_myCourses.length}");
        notifyListeners();
      } else {
        throw Exception("❌ Failed to load enrolled courses: ${response.body}");
      }
    } catch (error) {
      debugPrint("⚠️ Error fetching enrolled courses: $error");
    }
  }

  /// ✅ Get courses by category
  List<Course> getCoursesByClass(String className) {
    return _categoryWiseCourses[className] ?? [];
  }

  /// ✅ Add a new course
  Future<void> addCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(course.toJson()),
      );

      if (response.statusCode == 201) {
        final newCourse = Course.fromJson(json.decode(response.body));
        _allCourses.add(newCourse);
        _categoryWiseCourses.putIfAbsent(newCourse.category, () => []).add(newCourse);
        notifyListeners();
        debugPrint("✅ Course added: ${newCourse.title}");
      } else {
        throw Exception("❌ Failed to add course: ${response.body}");
      }
    } catch (error) {
      debugPrint("⚠️ Error adding course: $error");
    }
  }

  /// ✅ Remove a course by ID
  Future<void> removeCourse(String courseId) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$courseId"));

      if (response.statusCode == 200) {
        _allCourses.removeWhere((course) => course.id == courseId);
        _categoryWiseCourses.forEach((category, courses) {
          courses.removeWhere((course) => course.id == courseId);
        });
        notifyListeners();
        debugPrint("✅ Course removed: $courseId");
      } else {
        throw Exception("❌ Failed to remove course: ${response.body}");
      }
    } catch (error) {
      debugPrint("⚠️ Error removing course: $error");
    }
  }

  /// ✅ Update an existing course
  Future<void> updateCourse(Course updatedCourse) async {
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/${updatedCourse.id}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedCourse.toJson()),
      );

      if (response.statusCode == 200) {
        int index = _allCourses.indexWhere((course) => course.id == updatedCourse.id);
        if (index != -1) {
          _allCourses[index] = updatedCourse;
        }

        if (_categoryWiseCourses.containsKey(updatedCourse.category)) {
          int catIndex = _categoryWiseCourses[updatedCourse.category]!
              .indexWhere((course) => course.id == updatedCourse.id);
          if (catIndex != -1) {
            _categoryWiseCourses[updatedCourse.category]![catIndex] = updatedCourse;
          }
        }

        notifyListeners();
        debugPrint("✅ Course updated: ${updatedCourse.title}");
      } else {
        throw Exception("❌ Failed to update course: ${response.body}");
      }
    } catch (error) {
      debugPrint("⚠️ Error updating course: $error");
    }
  }
}
