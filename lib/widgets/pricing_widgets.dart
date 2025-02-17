import 'package:flutter/material.dart';
import '../styles/pricing_styles.dart';

Widget buildPricingTabs() {
return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 6,
        spreadRadius: 2,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Row(
    children: [
      /// ✅ Regular Plan
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 1.5),
            color: Colors.white,
          ),
          child: const Text(
            'Regular',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8), // Space between tabs

      /// ✅ Premium Plan
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Premium Plan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  ),
);

}

Widget buildFeatureSection(String title, List<Widget> features) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(title, style: PricingStyles.sectionTitleStyle),
      ),
      ...features,
    ],
  );
}

Widget buildFeatureRow(String feature, bool regularIncluded, bool premiumIncluded) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text(feature)),
        Expanded(
          child: Icon(
            regularIncluded ? Icons.check : Icons.remove,
            color: regularIncluded ? Colors.green : Colors.grey,
          ),
        ),
        Expanded(
          child: Icon(
            premiumIncluded ? Icons.check : Icons.remove,
            color: premiumIncluded ? Colors.green : Colors.grey,
          ),
        ),
      ],
    ),
  );
}


