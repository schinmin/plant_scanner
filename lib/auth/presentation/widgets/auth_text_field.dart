import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom text field for authentication screens with agriculture theme
class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Color? fillColor;
  final String? helperText;
  final String? errorText;

  const AuthTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.initialValue,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.fillColor,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 6),

        // Text Field
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          autofocus: autofocus,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.green.shade700, size: 22)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor ?? Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            counterText: maxLength != null ? null : '',
            helperText: helperText,
            helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade700, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  // ============ Factory Constructors ============

  /// Phone number field with Myanmar format
  factory AuthTextField.phone({
    required TextEditingController controller,
    required String label,
    String? hint,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return AuthTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'ဖုန်းနံပါတ် ထည့်ပါ (ဥပမာ- 09123456789)',
      prefixIcon: Icons.phone_android_outlined,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ ဖုန်းနံပါတ်ထည့်ပါ';
            }
            if (value.length < 10 || value.length > 11) {
              return 'ဖုန်းနံပါတ်သည် ၁၀ လုံး သို့မဟုတ် ၁၁ လုံးရှိရပါမည်';
            }
            return null;
          },
    );
  }

  /// Password field with visibility toggle
  factory AuthTextField.password({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? hint,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return AuthTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'စကားဝှက် ထည့်ပါ',
      prefixIcon: Icons.lock_outline,
      obscureText: !isVisible,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
          size: 20,
        ),
      ),
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ စကားဝှက်ထည့်ပါ';
            }
            if (value.length < 6) {
              return 'စကားဝှက် အနည်းဆုံး ၆ လုံးရှိရပါမည်';
            }
            if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
              return 'စကားဝှက်တွင် စာလုံးနှင့် ဂဏန်း ပါရပါမည်';
            }
            return null;
          },
    );
  }

  /// Email field
  factory AuthTextField.email({
    required TextEditingController controller,
    required String label,
    String? hint,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return AuthTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'အီးမေးလ် ထည့်ပါ',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ အီးမေးလ်ထည့်ပါ';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'အီးမေးလ် ပုံစံမှန်ကန်ပါစေ (example@gmail.com)';
            }
            return null;
          },
    );
  }

  /// Name field
  factory AuthTextField.name({
    required TextEditingController controller,
    required String label,
    String? hint,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return AuthTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'သင့်အမည်ကို ထည့်ပါ',
      prefixIcon: Icons.person_outline,
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ အမည်ထည့်ပါ';
            }
            if (value.length < 2) {
              return 'အမည်သည် အနည်းဆုံး ၂ လုံးရှိရပါမည်';
            }
            if (value.length > 50) {
              return 'အမည်သည် ၅၀ လုံးထက် မပိုရပါ';
            }
            return null;
          },
    );
  }

  /// Confirm password field
  factory AuthTextField.confirmPassword({
    required TextEditingController controller,
    required TextEditingController passwordController,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? hint,
  }) {
    return AuthTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'စကားဝှက်ကို ထပ်ထည့်ပါ',
      prefixIcon: Icons.lock_outline,
      obscureText: !isVisible,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ကျေးဇူးပြု၍ စကားဝှက်အတည်ပြုပါ';
        }
        if (value != passwordController.text) {
          return 'စကားဝှက် နှစ်ခုမတူပါ';
        }
        return null;
      },
    );
  }

  /// Search field
  factory AuthTextField.search({
    required TextEditingController controller,
    String? hint,
    Function(String)? onChanged,
    VoidCallback? onClear,
  }) {
    return AuthTextField(
      controller: controller,
      label: '',
      hint: hint ?? 'ရှာဖွေရန်...',
      prefixIcon: Icons.search,
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                controller.clear();
                if (onClear != null) onClear();
                if (onChanged != null) onChanged('');
              },
              icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
            )
          : null,
      onChanged: onChanged,
      fillColor: Colors.grey.shade50,
      maxLines: 1,
    );
  }
}
