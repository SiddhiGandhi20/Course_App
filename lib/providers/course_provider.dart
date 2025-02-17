import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseProvider with ChangeNotifier {
  final List<Course> _courses = []; // All available courses
  final List<Course> _myCourses = []; // Purchased courses

  List<Course> get courses => _courses;
  List<Course> get myCourses => _myCourses;

  // ✅ Add a new course
  void addCourse(Course course) {
    if (!_courses.contains(course)) { // Prevent duplicates
      _courses.add(course);
      debugPrint("Course Added: ${course.title}, Category: ${course.category}");
      notifyListeners();
    }
  }

  // ✅ Get courses by class name
  List<Course> getCoursesByClass(String className) {
    List<Course> filteredCourses =
        _courses.where((course) => course.category.trim().toLowerCase() == className.trim().toLowerCase()).toList();
    
    debugPrint("Courses for $className: ${filteredCourses.map((c) => c.title).toList()}");
    
    return filteredCourses;
  }
  void removeCourse(String title) {
    _courses.removeWhere((course) => course.title == title);
    notifyListeners();
  }

  // Update an existing course based on title
  void updateCourse(Course updatedCourse) {
    final index = _courses.indexWhere((course) => course.title == updatedCourse.title);
    if (index != -1) {
      _courses[index] = updatedCourse;
      notifyListeners();
    }
  }
}
