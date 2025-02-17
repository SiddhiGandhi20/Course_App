import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart'; // Import Drawer Widget

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drawer Example")),
      drawer: DrawerWidget(), // Use the extracted widget
      body: Center(child: Text("Main Content Here")),
    );
  }
}
