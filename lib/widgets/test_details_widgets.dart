import 'package:flutter/material.dart';
import '../styles/test_details_styles.dart';

Widget buildHeader(BuildContext context) {
  return Padding(
    padding: defaultPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const Text('Test Details', style: titleTextStyle),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget buildHeroImage() {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-ucyfZk7sjx0IAItlqlDTMfFsy8pt0m.png',
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildTitle() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Advanced Mathematics Concepts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
        children: [
          buildTag('Mathematics', Colors.blue),
          const SizedBox(width: 8),
          buildTag('Advanced', Colors.green),
        ],
      ),
    ],
  );
}

Widget buildTag(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(text, style: tagTextStyle.copyWith(color: color)),
  );
}

Widget buildInfoGrid() {
  return GridView.count(
    shrinkWrap: true,
    crossAxisCount: 2,
    childAspectRatio: 2.5,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    physics: const NeverScrollableScrollPhysics(),
    children: [
      buildInfoItem(Icons.timer, 'Duration', '120 mins'),
      buildInfoItem(Icons.quiz, 'Questions', '50 items'),
      buildInfoItem(Icons.grade, 'Passing Score', '75%'),
      buildInfoItem(Icons.stars, 'Points', '100 pts'),
    ],
  );
}

Widget buildInfoItem(IconData icon, String title, String value) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}

Widget buildDescription() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Description', style: titleTextStyle),
      const SizedBox(height: 8),
      Text(
        'This comprehensive test covers advanced mathematical concepts including calculus, linear algebra, and probability theory.',
        style: descriptionTextStyle,
      ),
    ],
  );
}

Widget buildTopicsCovered() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Topics Covered', style: titleTextStyle),
      const SizedBox(height: 12),
      buildTopicItem('Calculus', '15 questions'),
      buildTopicItem('Linear Algebra', '12 questions'),
      buildTopicItem('Probability', '13 questions'),
    ],
  );
}

Widget buildTopicItem(String title, String questions) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: [
            Text(questions, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade600),
          ],
        ),
      ],
    ),
  );
}

Widget buildBottomBar() {
  return Container(
    padding: defaultPadding,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, -2)),
      ],
    ),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Enroll Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
  
}
Widget buildRequirements() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Requirements', style: titleTextStyle),
      const SizedBox(height: 12),
      buildRequirementItem('Basic calculus knowledge required'),
      buildRequirementItem('Complete in one sitting'),
      buildRequirementItem('Minimum 75% to pass'),
      buildRequirementItem('Available in English'),
    ],
  );
}
Widget buildRequirementItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(Icons.check_circle, size: 20, color: Colors.blue.shade400),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}

Widget buildInstructions() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Instructions', style: titleTextStyle),
      const SizedBox(height: 12),
      buildInstructionItem('Read each question carefully before answering'),
      buildInstructionItem('No coming back to previous questions'),
      buildInstructionItem('Calculator is allowed for specific sections'),
      buildInstructionItem('Submit your answers before time runs out'),
    ],
  );
}

Widget buildInstructionItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_right, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade600))),
      ],
    ),
  );
}

Widget buildProfessorInfo() {
  return Row(
    children: [
      const CircleAvatar(
        backgroundImage: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-ucyfZk7sjx0IAItlqlDTMfFsy8pt0m.png'),
      ),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Professor Smith', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            'Updated Jan 2024 • English',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    ],
  );
}
