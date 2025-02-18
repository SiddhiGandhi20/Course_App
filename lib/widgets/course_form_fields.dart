import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseFormFields extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController instructorController;
  final TextEditingController descriptionController;
  final String selectedLevel;
  final bool isPrivateCourse;
  final bool certificateAvailable;
  final bool isOnlineCourse;
  final List<String> tags;
  final String selectedCategory;
  final String selectedLanguage;
  final String courseDuration;
  final String coursePrice;
  final String selectedRating;
  final List<String> selectedVideoPaths;
  final List<String> selectedNotesPaths;
  final List<String> learningPoints;

  final Function(String) onTitleChanged;
  final Function(String) onInstructorChanged;
  final Function(String) onLevelSelected;
  final Function(bool) onPrivateToggle;
  final Function(bool) onCertificateToggle;
  final Function(bool) onOnlineToggle;
  final Function(String) onTagAdded;
  final Function(String) onTagRemoved;
  final Function(String) onCategorySelected;
  final Function(String) onLanguageSelected;
  final Function(String) onDurationChanged;
  final Function(String) onPriceChanged;
  final Function(String) onRatingSelected;
  final Function(String) onDescriptionChanged;
  final Function(String) onLearningPointAdded;
  final Function(String) onLearningPointRemoved;

  const CourseFormFields({
    super.key,
    required this.titleController,
    required this.instructorController,
    required this.descriptionController,
    required this.selectedLevel,
    required this.isPrivateCourse,
    required this.certificateAvailable,
    required this.isOnlineCourse,
    required this.tags,
    required this.selectedCategory,
    required this.selectedLanguage,
    required this.courseDuration,
    required this.coursePrice,
    required this.selectedRating,
    required this.selectedVideoPaths,
    required this.selectedNotesPaths,
    required this.learningPoints,
    required this.onTitleChanged,
    required this.onInstructorChanged,
    required this.onLevelSelected,
    required this.onPrivateToggle,
    required this.onCertificateToggle,
    required this.onOnlineToggle,
    required this.onTagAdded,
    required this.onTagRemoved,
    required this.onCategorySelected,
    required this.onLanguageSelected,
    required this.onDurationChanged,
    required this.onPriceChanged,
    required this.onRatingSelected,
    required this.onDescriptionChanged,
    required this.onLearningPointAdded,
    required this.onLearningPointRemoved,
  });

  @override
  _CourseFormFieldsState createState() => _CourseFormFieldsState();
}

class _CourseFormFieldsState extends State<CourseFormFields> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _learningPointController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addTag() {
    String tag = _tagController.text.trim();
    if (tag.isNotEmpty && !widget.tags.contains(tag)) {
      widget.onTagAdded(tag);
      _tagController.clear();
      setState(() {});
    }
  }

  void _removeTag(String tag) {
    widget.onTagRemoved(tag);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Course Title"),
            _buildDecorativeTextField(widget.titleController, TextInputType.text, widget.onTitleChanged),

            _buildLabel("Instructor Name"),
            _buildDecorativeTextField(widget.instructorController, TextInputType.text, widget.onInstructorChanged),

            _buildLabel("Description"),
            _buildDecorativeTextField(widget.descriptionController, TextInputType.multiline, widget.onDescriptionChanged),

            _buildLabel("What You Will Learn"),
            _buildLearningPointsSection(),

            _buildLabel("Course Tags"),
            _buildTagInputField(),

            _buildLabel("Course Mode"),
            _buildStyledSwitch(widget.isOnlineCourse, "Online Course", "Offline Course", widget.onOnlineToggle),

            _buildLabel("Class"),
            _buildDecorativeDropdown(widget.selectedCategory, ['Select Class', '5th Class', '6th Class', '7th Class'], widget.onCategorySelected),

            _buildLabel("Duration (hours)"),
            _buildDurationPriceField(
              controller: TextEditingController(text: widget.courseDuration),
              onChanged: widget.onDurationChanged,
            ),

            _buildLabel("Price (Optional)"),
            _buildDurationPriceField(
              controller: TextEditingController(text: widget.coursePrice),
              onChanged: widget.onPriceChanged,
            ),

            _buildLabel("Language"),
            _buildDecorativeDropdown(widget.selectedLanguage, ['English', 'Hindi'], widget.onLanguageSelected),

            _buildLabel("Course Level"),
            _buildDecorativeDropdown(widget.selectedLevel, ['Beginner', 'Intermediate', 'Advanced'], widget.onLevelSelected),

            _buildLabel("Ratings (1-5)"),
            _buildDecorativeDropdown(widget.selectedRating, ['1', '2', '3', '4', '5'], widget.onRatingSelected),

            _buildStyledSwitch(widget.isPrivateCourse, "Private Course", "Public Course", widget.onPrivateToggle),
            _buildStyledSwitch(widget.certificateAvailable, "Certificate Available", "No Certificate", widget.onCertificateToggle),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledSwitch(bool value, String activeText, String inactiveText, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value ? activeText : inactiveText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF283593),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A237E),
            inactiveThumbColor: const Color(0xFFBBDEFB),
            inactiveTrackColor: const Color(0xFF90CAF9),
          ),
        ],
      ),
    );
  }

  Widget _buildTagInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _tagController,
          decoration: InputDecoration(
            labelText: 'Enter a Tag',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTag,
            ),
          ),
          onSubmitted: (_) => _addTag(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: widget.tags.map((tag) => Chip(
            label: Text(tag),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () => _removeTag(tag),
            backgroundColor: Colors.blue[100],
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildLearningPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children: widget.learningPoints.map((point) => Chip(
            label: Text(point),
            deleteIcon: const Icon(Icons.close, size: 18, color: Colors.red),
            onDeleted: () => widget.onLearningPointRemoved(point),
          )).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _learningPointController,
                decoration: InputDecoration(hintText: "Add a learning point", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
              onPressed: () {
                if (_learningPointController.text.trim().isNotEmpty) {
                  widget.onLearningPointAdded(_learningPointController.text.trim());
                  _learningPointController.clear();
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: Color(0xFF283593),
        ),
      ),
    );
  }

  Widget _buildDecorativeTextField(TextEditingController controller, TextInputType keyboardType, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.blue.shade100, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
      ),
    );
  }

  Widget _buildDecorativeDropdown(String value, List<String> items, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.blue.shade100, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: DropdownButton<String>(
        value: items.contains(value) ? value : items.first,
        isExpanded: true,
        underline: Container(height: 0),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => val != null ? onChanged(val) : null,
      ),
    );
  }

 Widget _buildDurationPriceField({required TextEditingController controller, required Function(String) onChanged}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(color: Colors.blue.shade100, blurRadius: 5, spreadRadius: 2),
      ],
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Ensure only digits are entered
      ],
      onChanged: (value) {
        // This callback will be triggered when the value changes
        onChanged(value);
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
  );
}
}

