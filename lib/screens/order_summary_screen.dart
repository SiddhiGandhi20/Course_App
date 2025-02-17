import 'package:flutter/material.dart';
import 'package:course_app/models/course.dart';
import 'package:course_app/models/coupon.dart';
import '../screens/payment_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String selectedPlan;
  final double selectedPrice;
  final Course course;

  const OrderSummaryScreen({
    super.key,
    required this.selectedPlan,
    required this.selectedPrice,
    required this.course,
    required double finalPrice,
  });

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final TextEditingController _couponController = TextEditingController();
  double discount = 0.0;
  double finalPrice = 0.0;
  Coupon? appliedCoupon;

  final List<Coupon> allCoupons = [
    Coupon(code: "DISCOUNT10", discountPercentage: 10),
    Coupon(code: "SAVE20", discountPercentage: 20),
    Coupon(code: "OFFER30", discountPercentage: 30),
    Coupon(code: "EXPIRED50", discountPercentage: 50, isValid: false),
    Coupon(code: "INVALID25", discountPercentage: 25, isValid: false),
  ];

  @override
  void initState() {
    super.initState();
    finalPrice = widget.selectedPrice;
  }

  void _applyCoupon() {
    String couponCode = _couponController.text.trim();
    Coupon? foundCoupon = allCoupons.firstWhere(
      (coupon) => coupon.code == couponCode,
      orElse: () => Coupon(code: "", discountPercentage: 0),
    );

    setState(() {
      if (foundCoupon.code.isNotEmpty && foundCoupon.isValid) {
        appliedCoupon = foundCoupon;
        discount = widget.selectedPrice * (foundCoupon.discountPercentage / 100);
        finalPrice = widget.selectedPrice - discount;
        _showCouponDialog('Coupon Applied', '${foundCoupon.discountPercentage}% Off');
      } else {
        appliedCoupon = null;
        discount = 0;
        finalPrice = widget.selectedPrice;
        _showSnackBar('Invalid or Expired Coupon');
      }
    });
  }

  void _showCouponDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "🎉 You've just saved some extra cash! Enjoy your learning journey. 🚀",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Awesome! 🎯',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  void _fillCouponField(String couponCode) {
    setState(() {
      _couponController.text = couponCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourseTitle(),
            const SizedBox(height: 20),
            _buildOrderDetails(),
            const SizedBox(height: 20),
            _buildCouponSection(),
            const SizedBox(height: 20),
            _buildCouponList(),
            const SizedBox(height: 20),
            _buildPriceBreakdown(),
            const SizedBox(height: 30),
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseTitle() {
    return Center(
      child: Text(
        widget.course.title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return _decorativeCard([
      _infoRow('Plan Selected:', widget.selectedPlan, highlight: true),
      _infoRow('Base Price:', '₹${widget.selectedPrice.toStringAsFixed(2)}'),
    ]);
  }

  Widget _buildCouponSection() {
    return _decorativeCard([
      const Text('Apply Coupon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: 'Enter Coupon Code',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _applyCoupon,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ]);
  }

  Widget _buildPriceBreakdown() {
    double taxPercentage = 18.0;
    double taxAmount = (widget.selectedPrice - discount) * (taxPercentage / 100);
    double totalAmount = (widget.selectedPrice - discount) + taxAmount;

    return _decorativeCard([
      _infoRow('Base Price:', '₹${widget.selectedPrice.toStringAsFixed(2)}', bold: true),
      if (discount > 0)
        _infoRow('Discount (${appliedCoupon?.code ?? ''}):', '- ₹${discount.toStringAsFixed(2)}', bold: true, color: Colors.green),
      _infoRow('Tax (${taxPercentage.toInt()}% GST):', '+ ₹${taxAmount.toStringAsFixed(2)}', bold: true, color: Colors.red),
      const Divider(color: Colors.grey),
      _infoRow('Total Payable:', '₹${totalAmount.toStringAsFixed(2)}', bold: true, color: Colors.blue),
    ]);
  }

  Widget _buildPaymentButton() {
    return Center(
      child: SizedBox(
        width: double.infinity, // Makes the button take full width
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(amount: finalPrice, course: widget.course),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Proceed to Payment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false, bool highlight = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: (bold || highlight) ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
            color: highlight ? Colors.blue : (color ?? Colors.black),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: (bold || highlight) ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
            color: highlight ? Colors.blue : (color ?? Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponList() {
    return _decorativeCard([
      const Text('Available Coupons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Column(
        children: allCoupons
            .where((coupon) => coupon.isValid) // Show only valid coupons
            .map(
              (coupon) => ListTile(
                title: Text(
                  coupon.code,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${coupon.discountPercentage}% OFF'),
                trailing: ElevatedButton(
                  onPressed: () => _fillCouponField(coupon.code),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Apply Coupon', style: TextStyle(color: Colors.white)),
                ),
              ),
            )
            .toList(),
      ),
    ]);
  }

  Widget _decorativeCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
