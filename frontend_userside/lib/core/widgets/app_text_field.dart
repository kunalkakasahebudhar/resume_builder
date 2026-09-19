import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? helperText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          autofocus: autofocus,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 12 : 12,
            ),
          ),
        ),
      ],
    );
  }
}
