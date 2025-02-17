import 'package:flutter/material.dart';
import '../styles/test_details_styles.dart';
import '../widgets/test_details_widgets.dart';

class TestDetailsScreen extends StatelessWidget {
  const TestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              buildHeroImage(),
              Padding(
                padding: defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(),
                    const SizedBox(height: 24),
                    buildInfoGrid(),
                    const SizedBox(height: 24),
                    buildDescription(),
                    const SizedBox(height: 24),
                    buildTopicsCovered(),
                    const SizedBox(height: 24),
                    buildRequirements(),
                    const SizedBox(height: 24),
                    buildInstructions(),
                    const SizedBox(height: 24),
                    buildProfessorInfo(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }
}
