import 'package:flutter/material.dart';

// Define the fixed professional blue color palette
const Color primaryBlue = Color(0xFF007AFF);
const Color defaultBorderColor = primaryBlue;
const double kBorderRadius = 10.0;
const double kSpacing = 16.0;

// --- Helper Functions and Definitions ---

enum ButtonType { primary, secondary, textOnly, withIcon }

/// Creates a standardized, modern InputDecoration for all text-based fields.
InputDecoration _inputDecoration(
    String labelText, {
      Widget? suffixIcon,
      String? hintText,
      Widget? prefixIcon,
    }) {
  // Calculate faded color for enabled state (50% transparency)
  final Color fadedBlue = primaryBlue.withAlpha(127);
  // NOTE: Font family is intentionally omitted here to inherit the global Poppins theme
  const TextStyle labelStyle = TextStyle(color: primaryBlue, fontWeight: FontWeight.w600);

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    labelStyle: labelStyle,
    floatingLabelStyle: labelStyle,

    // Modern Border Styling
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(color: defaultBorderColor, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: BorderSide(color: fadedBlue, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(color: primaryBlue, width: 2.0),
    ),

    contentPadding: const EdgeInsets.symmetric(horizontal: kSpacing, vertical: 12),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
  );
}

// --- CustomButton Component ---

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine style based on ButtonType
    Color backgroundColor = Colors.transparent;
    Color foregroundColor = primaryBlue;
    double elevation = 0;
    TextStyle textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    BorderSide borderSide = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = primaryBlue;
        foregroundColor = Colors.white;
        elevation = 5;
        break;
      case ButtonType.secondary:
        backgroundColor = Colors.white;
        foregroundColor = primaryBlue;
        borderSide = const BorderSide(color: primaryBlue, width: 1.5);
        elevation = 2;
        break;
      case ButtonType.withIcon:
      case ButtonType.textOnly:
        backgroundColor = Colors.transparent;
        foregroundColor = primaryBlue;
        textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
        break;
    }

    Widget childWidget;
    if (isLoading) {
      childWidget = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(type == ButtonType.primary ? Colors.white : primaryBlue),
          strokeWidth: 3,
        ),
      );
    } else {
      // Logic for icon placement
      if (icon != null && type != ButtonType.textOnly) {
        childWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text),
          ],
        );
      } else {
        childWidget = Text(text);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable while loading
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shadowColor: primaryBlue.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            side: borderSide,
          ),
          elevation: elevation,
          textStyle: textStyle,
          overlayColor: (backgroundColor == Colors.transparent)
              ? primaryBlue.withOpacity(0.1)
              : null,
        ),
        child: childWidget,
      ),
    );
  }
}

// --- CustomTextInput Component ---

class CustomTextInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final double? width;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextInput({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.width,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          cursorColor: primaryBlue,
          decoration: _inputDecoration(
            labelText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ),
    );
  }
}

// --- CustomDropdown Component ---

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: _inputDecoration(labelText),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: primaryBlue, size: 28),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        dropdownColor: Colors.white,

        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// --- CustomDatePicker (Single Date) Component ---

class CustomDatePicker extends StatefulWidget {
  final String labelText;
  final ValueChanged<DateTime?> onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        onTap: () => _selectDate(context),
        cursorColor: primaryBlue,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: _inputDecoration(
          widget.labelText,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: primaryBlue),
            onPressed: () => _selectDate(context),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}

// --- CustomDateRangePicker (Start/End Date) Component ---

class CustomDateRangePicker extends StatefulWidget {
  final String labelText;
  final ValueChanged<DateTimeRange?> onDateRangeSelected;

  const CustomDateRangePicker({
    super.key,
    required this.labelText,
    required this.onDateRangeSelected,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTimeRange? _selectedRange;
  final TextEditingController _rangeController = TextEditingController();

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedRange) {
      setState(() {
        _selectedRange = picked;
        String start = "${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}";
        String end = "${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";
        _rangeController.text = '$start to $end';
      });
      widget.onDateRangeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _rangeController,
        readOnly: true,
        onTap: () => _selectDateRange(context),
        cursorColor: primaryBlue,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: _inputDecoration(
          widget.labelText,
          suffixIcon: IconButton(
            icon: const Icon(Icons.date_range, color: primaryBlue),
            onPressed: () => _selectDateRange(context),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rangeController.dispose();
    super.dispose();
  }
}

// --- CustomOptionPicker (Search + Bottom Popup) Component ---

class CustomOptionPicker extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final ValueChanged<String?> onOptionSelected;

  const CustomOptionPicker({
    super.key,
    required this.labelText,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  State<CustomOptionPicker> createState() => _CustomOptionPickerState();
}

class _CustomOptionPickerState extends State<CustomOptionPicker> {
  String? _selectedValue;
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayController.text = _selectedValue ?? '';
  }

  Future<void> _showOptionPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadius * 2)),
      ),
      builder: (BuildContext context) {
        return OptionPickerModal(
          options: widget.options,
          currentValue: _selectedValue,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedValue = result;
        _displayController.text = result;
      });
      widget.onOptionSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _displayController,
        readOnly: true,
        onTap: () => _showOptionPicker(context),
        cursorColor: primaryBlue,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: _inputDecoration(
          widget.labelText,
          suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryBlue),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}

// --- Option Picker Bottom Sheet Modal ---

class OptionPickerModal extends StatefulWidget {
  final List<String> options;
  final String? currentValue;

  const OptionPickerModal({
    super.key,
    required this.options,
    this.currentValue,
  });

  @override
  State<OptionPickerModal> createState() => _OptionPickerModalState();
}

class _OptionPickerModalState extends State<OptionPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _searchController.addListener(_filterOptions);
  }

  void _filterOptions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) => option.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        top: kSpacing,
        left: kSpacing,
        right: kSpacing,
        bottom: MediaQuery.of(context).viewInsets.bottom + kSpacing / 2,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Option',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: kSpacing / 2),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search options...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: primaryBlue),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: kSpacing),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: const BorderSide(color: primaryBlue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: const BorderSide(color: primaryBlue, width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: kSpacing / 2),
          Expanded(
            child: _filteredOptions.isEmpty
                ? const Center(child: Text("No options found."))
                : ListView.builder(
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                final isSelected = option == widget.currentValue;
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? primaryBlue : Colors.black,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: primaryBlue)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(option);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterOptions);
    _searchController.dispose();
    super.dispose();
  }
}

// --- CustomCheckbox Component ---

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 30,
            height: 30,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () => onChanged(!value),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CustomImageUploader Component (Mocked functionality) ---

class CustomImageUploader extends StatefulWidget {
  final String labelText;
  final ValueChanged<String?> onImageUploaded;

  const CustomImageUploader({
    super.key,
    required this.labelText,
    required this.onImageUploaded,
  });

  @override
  State<CustomImageUploader> createState() => _CustomImageUploaderState();
}

class _CustomImageUploaderState extends State<CustomImageUploader> {
  // Mock State variables
  String? _uploadedImagePath;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  void _startMockUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    for (int i = 0; i <= 10; i++) {
      if (!_isUploading) break;
      await Future.delayed(const Duration(milliseconds: 200));
      if (!_isUploading) break;
      setState(() {
        _uploadProgress = i / 10.0;
      });
    }

    if (_isUploading) {
      setState(() {
        _isUploading = false;
        _uploadedImagePath = "Placeholder Image";
      });
      widget.onImageUploaded(_uploadedImagePath);
    }
  }

  void _cancelUpload() {
    setState(() {
      _isUploading = false;
      _uploadProgress = 0.0;
    });
  }

  void _removeImage() {
    setState(() {
      _uploadedImagePath = null;
      _uploadProgress = 0.0;
      _isUploading = false;
    });
    widget.onImageUploaded(null);
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(kBorderRadius + 5),
      ),
      child: Icon(
        Icons.cloud_upload_outlined,
        color: primaryBlue.withOpacity(0.7),
        size: 35,
      ),
    );
  }

  Widget _buildUploader() {
    return InkWell(
      onTap: _isUploading ? null : _startMockUpload,
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: primaryBlue.withOpacity(0.05),
          border: Border.all(
            color: primaryBlue.withOpacity(0.5),
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Column(
          children: [
            _buildPlaceholderIcon(),
            const SizedBox(height: 15),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                children: <TextSpan>[
                  const TextSpan(text: 'Drag and drop or '),
                  TextSpan(
                    text: 'browse files',
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Supports: JPG, PNG, WEBP (Max 5MB)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = (_uploadProgress * 100).toStringAsFixed(0);
    final isComplete = _uploadProgress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: primaryBlue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isComplete ? 'Upload Complete' : 'Uploading...',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: isComplete
                    ? const Icon(Icons.check_circle, color: primaryBlue)
                    : const Icon(Icons.close, color: Colors.red),
                onPressed: isComplete ? null : _cancelUpload,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _uploadProgress,
            backgroundColor: primaryBlue.withOpacity(0.2),
            color: primaryBlue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            isComplete ? '100%' : '$progress%...',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: primaryBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 60,
              height: 60,
              color: primaryBlue.withOpacity(0.2),
              child: const Icon(Icons.photo_library, color: primaryBlue, size: 30),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('uploaded_image_filename.png', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('File Size: 2.1 MB', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _removeImage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryBlue),
          ),
          const SizedBox(height: 10),

          if (_uploadedImagePath != null)
            _buildPreview()
          else if (_isUploading || _uploadProgress > 0.0)
            _buildProgressIndicator()
          else
            _buildUploader(),
        ],
      ),
    );
  }
}

// --- CustomAlertDialog (Replacement for alert() and confirm()) ---
void showCustomAlertDialog(BuildContext context, String title, String content, {VoidCallback? onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue)),
        content: Text(content),
        actions: <Widget>[
          if (onConfirm != null)
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          TextButton(
            child: Text(onConfirm != null ? 'Confirm' : 'OK', style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
          ),
        ],
      );
    },
  );
}
