import 'package:flutter/material.dart';
import '../styles/test_styles.dart';
import '../widgets/widgets.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: TestStyles.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(title: 'Test Preparations'),
              const SizedBox(height: 20),
              buildFeaturedTests(),
              const SizedBox(height: 24),
              buildPopularCategories(context),
              const SizedBox(height: 24),
              buildContinuingLearning(),
              const SizedBox(height: 24),
              buildFreeTests(),
              const SizedBox(height: 24),
              buildPremiumTests(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
