import 'package:flutter/material.dart';
import 'dart:io';
import '../styles/add_batches_styles.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final Function onTap;

  const ImagePickerWidget({
    super.key,
    required this.imageFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: imageFile == null
          ? Container(
              height: 150,
              width: double.infinity,
              decoration: AddBatchesStyles.imageBoxDecoration,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size: 50,
              ),
            )
          : Image.file(
              imageFile!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final Function(String) onSaved;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function()? onTap;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.keyboardType,
    required this.onSaved,
    required this.controller,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AddBatchesStyles.padding,
      child: GestureDetector(
        onTap: onTap,  // Trigger date picker when tapped
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
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
