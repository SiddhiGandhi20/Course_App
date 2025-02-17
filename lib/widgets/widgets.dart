import 'package:course_app/screens/mcq_selection_screen.dart';
import 'package:flutter/material.dart';
import '../styles/test_styles.dart';

/// ✅ App Header
Widget buildHeader({required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TestStyles.headerTextStyle),
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {},
      ),
    ],
  );
}

/// ✅ Featured Tests Section
Widget buildFeaturedTests() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Featured Tests', style: TestStyles.sectionTitleStyle),
      const SizedBox(height: 12),
      Container(
        height: 160,
        decoration: TestStyles.cardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TestStyles.borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-90i399D8lqyZtNeCztzwBXNmrEsgPe.png',
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBadge(text: 'Premium', color: const Color.fromARGB(255, 87, 166, 235)),
                    const SizedBox(height: 4),
                    Text(
                      'IELTS Practice Test',
                      style: TestStyles.boldTextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// ✅ Continuing Learning Section
Widget buildContinuingLearning() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Continuing Learning', style: TestStyles.sectionTitleStyle),
      const SizedBox(height: 12),
      _buildTestCard('English Grammar Test', '20/30 Questions', '45 min left', 0.7, Colors.blue),
      const SizedBox(height: 12),
      _buildTestCard('Mathematics Practice', '15/25 Questions', '1 hour left', 0.6, const Color.fromARGB(255, 255, 255, 255)),
    ],
  );
}

/// ✅ Free Tests Section
Widget buildFreeTests() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Free Tests', style: TestStyles.sectionTitleStyle),
      const SizedBox(height: 12),
      _buildFreeTestItem('Basic English Grammar', '45 mins', '25 Questions'),
      _buildFreeTestItem('General Knowledge', '30 mins', '20 Questions'),
    ],
  );
}

/// ✅ Premium Tests Section
Widget buildPremiumTests() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Premium Tests', style: TestStyles.sectionTitleStyle),
      const SizedBox(height: 12),
      _buildPremiumTestItem('Advanced IELTS Practice', '3 hours', '180 Questions'),
      _buildPremiumTestItem('Complete GRE Mock', '4 hours', '240 Questions'),
    ],
  );
}

/// ✅ Reusable Test Card
Widget _buildTestCard(String title, String progress, String timeLeft, double progressValue, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: TestStyles.cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TestStyles.boldTextStyle()),
            Text(timeLeft, style: TestStyles.smallTextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 8),
        Text(progress, style: TestStyles.smallTextStyle(color: Colors.grey.shade600)),
      ],
    ),
  );
}

/// ✅ Free Test Item
Widget _buildFreeTestItem(String title, String duration, String questions) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: TestStyles.cardDecoration,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TestStyles.boldTextStyle()),
            Text('$duration • $questions', style: TestStyles.smallTextStyle(color: Colors.grey.shade600)),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 78, 145, 197),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
           child: const Text(
          'Start Test',
          style: TextStyle(color: Colors.white), // ✅ Set text color to white
        ),
        ),
      ],
    ),
  );
}

/// ✅ Premium Test Item
Widget _buildPremiumTestItem(String title, String duration, String questions) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: TestStyles.cardDecoration,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TestStyles.boldTextStyle()),
            Text('$duration • $questions', style: TestStyles.smallTextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 96, 177, 234),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Unlock',
          style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

/// ✅ Badge Widget
Widget _buildBadge({required String text, required Color color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
}

/// ✅ Popular Categories
Widget buildPopularCategories(BuildContext context) { // 👈 Add BuildContext
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Popular Categories', style: TestStyles.sectionTitleStyle),
      const SizedBox(height: 12),
      Row(
        children: [
          _buildCategoryCard(
            title: 'MCQ Tests',
            icon: Icons.question_answer,
            count: '100+ Tests',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MCQSelectionScreen()),
              );
            },
          ),
          const SizedBox(width: 12),
          _buildCategoryCard(
            title: 'Full Tests',
            icon: Icons.assignment,
            count: '45+ Tests',
            color: const Color.fromARGB(255, 96, 133, 182),
            onTap: () {
              // Add navigation for Full Tests if needed
            },
          ),
        ],
      ),
    ],
  );
}


/// ✅ Category Card
Widget _buildCategoryCard({
  required String title,
  required IconData icon,
  required String count,
  required Color color,
  required VoidCallback onTap, // 👈 Add onTap parameter
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap, // 👈 Handle tap event
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: TestStyles.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: (color is MaterialColor) ? color.shade900 : color),
            const SizedBox(height: 8),
            Text(title, style: TestStyles.boldTextStyle()),
            Text(count, style: TestStyles.smallTextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    ),
  );
}


/// ✅ Bottom Navigation Bar
Widget buildBottomNavBar() {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
      BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analysis'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
    currentIndex: 0,
    selectedItemColor: Colors.purple,
  );
}
