import 'package:flutter/material.dart';
import '../styles/order_summary_styles.dart';

Widget buildOrderDetails() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Digital Marketing Masterclass',
        style: OrderSummaryStyles.titleStyle,
      ),
      const SizedBox(height: 8),
      Row(
        children: const [
          Icon(Icons.access_time, size: 16, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            '6 months access',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}

Widget buildCouponSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.local_offer_outlined),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter Coupon Code',
              border: InputBorder.none,
              hintStyle: OrderSummaryStyles.hintStyle,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Apply'),
        ),
      ],
    ),
  );
}

Widget buildPriceBreakdown() {
  return Column(
    children: [
      buildPriceRow('Course Price', '₹7,500'),
      buildPriceRow('Coupon Discount', '-₹2,000', isDiscount: true),
      const Divider(height: 32),
      buildPriceRow('Total', '₹5,500', isTotal: true),
    ],
  );
}

Widget buildPriceRow(String label, String amount, {bool isDiscount = false, bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : null,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : null,
          ),
        ),
      ],
    ),
  );
}

Widget buildPaymentButton() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [OrderSummaryStyles.paymentBoxShadow],
    ),
    child: ElevatedButton(
      onPressed: () {},
      style: OrderSummaryStyles.payButtonStyle,
      child: const Text(
        'Pay Now',
        style: OrderSummaryStyles.totalTextStyle,
      ),
    ),
  );
}
