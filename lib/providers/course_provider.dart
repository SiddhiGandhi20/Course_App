import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseProvider with ChangeNotifier {
  final List<Course> _courses = []; // All available courses
  final List<Course> _myCourses = []; // Purchased courses

  List<Course> get courses => _courses;
  List<Course> get myCourses => _myCourses;

  // Add a new course if it doesn't already exist
 void addCourse(Course course) {
  if (!_courses.contains(course)) { // Prevent duplicates
    _courses.add(course);
    notifyListeners();
  }
}


  // Update a course by index
  void updateCourse(int index, Course updatedCourse) {
    if (index >= 0 && index < _courses.length) {
      _courses[index] = updatedCourse;
      notifyListeners();
    }
  }

  // Remove a course by index
  void removeCourse(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      notifyListeners();
    }
  }

  // Add course to "My Courses" if not already added
  void addToMyCourses(Course course) {
    if (!_courses.contains(course)) { // Prevent duplicates
    _courses.add(course);
    notifyListeners();
  }
  }

  // Remove a course from "My Courses"
  void removeFromMyCourses(Course course) {
    _myCourses.remove(course);
    notifyListeners();
  }
}
