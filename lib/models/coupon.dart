class Coupon {
  final String code;
  final double discountPercentage;
  final bool isValid;

  Coupon({
    required this.code,
    required this.discountPercentage,
    this.isValid = true, // Default to valid
  });

  double applyDiscount(double price) {
    return isValid ? price - (price * (discountPercentage / 100)) : price;
  }
}
