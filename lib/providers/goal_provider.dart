import 'package:flutter/material.dart';

class GoalProvider extends ChangeNotifier {
  String _selectedGoal = '';
  String _selectedBoard = '';

  String get selectedGoal => _selectedGoal;
  String get selectedBoard => _selectedBoard;

  void setGoal(String goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  void setBoard(String board) {
    _selectedBoard = board;
    notifyListeners();
  }
}
