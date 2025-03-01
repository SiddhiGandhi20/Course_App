import 'package:flutter/material.dart';
import '../styles/add_batches_styles.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final Function(String) onSaved;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function()? onTap;
  final bool readOnly; // Added for date field

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.keyboardType,
    required this.onSaved,
    required this.controller,
    this.validator,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AddBatchesStyles.padding,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AddBatchesStyles.labelTextStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        onSaved: (value) => onSaved(value!),
        validator: validator,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: style ?? AddBatchesStyles.buttonStyle,
        onPressed: onPressed,
        child: Text(label, style: AddBatchesStyles.buttonTextStyle),
      ),
    );
  }
}
