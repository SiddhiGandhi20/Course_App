import 'package:flutter/material.dart';

class BoardSelectionScreen extends StatefulWidget {
  const BoardSelectionScreen({super.key});

  @override
  _BoardSelectionScreenState createState() => _BoardSelectionScreenState();
}

class _BoardSelectionScreenState extends State<BoardSelectionScreen> {
  final List<String> _boards = ['11', '12-PCB', '12-PCM', 'NEET', 'Others'];
  String _selectedBoard = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Board', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your board:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// ✅ List of Radio Buttons for Board Selection
            Column(
              children: _boards.map((board) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: ListTile(
                    title: Text(board, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    leading: Radio<String>(
                      value: board,
                      groupValue: _selectedBoard,
                      onChanged: (value) {
                        setState(() {
                          _selectedBoard = value!;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// ✅ Confirm Button
            Center(
              child: ElevatedButton(
                onPressed: _selectedBoard.isEmpty
                    ? null
                    : () {
                        Navigator.pop(context, _selectedBoard);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirm Selection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
