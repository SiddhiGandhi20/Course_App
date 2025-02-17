import 'package:flutter/material.dart';

class BoardSelector extends StatefulWidget {
  final List<String> boards;
  final String selectedBoard;
  final Function(String) onBoardSelected;

  const BoardSelector({
    super.key,
    required this.boards,
    required this.selectedBoard,
    required this.onBoardSelected,
  });

  @override
  _BoardSelectorState createState() => _BoardSelectorState();
}

class _BoardSelectorState extends State<BoardSelector> {
  late String selectedBoard;

  @override
  void initState() {
    super.initState();
    selectedBoard = widget.selectedBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Board"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.boards.map((board) {
              final bool isSelected = board == selectedBoard;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBoard = board;
                  });
                  widget.onBoardSelected(selectedBoard);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    board,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
