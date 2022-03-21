import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';
import '../colors.dart';

class TextInput extends StatelessWidget {
  final String labelText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final IconData? icon;
  final EdgeInsets padding;
  final bool autoFocus;
  final VoidCallback? onEditingComplete;
  final String? initialValue;
  final TextEditingController? controller;
  final bool? showCursor;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final bool numbersOnly;
  final String? prefix;
  final String? suffix;
  final double paddingRight;
  final FocusNode? focusNode;

  const TextInput({
    Key? key,
    required this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.icon,
    this.padding = const EdgeInsets.only(left: 18.0, right: 18),
    this.autoFocus = false,
    this.onEditingComplete,
    this.initialValue,
    this.controller,
    this.showCursor,
    this.readOnly = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.numbersOnly = false,
    this.prefix,
    this.suffix,
    this.paddingRight = 12,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        focusNode: focusNode,
        keyboardType: numbersOnly ? TextInputType.number : null,
        maxLines: maxLines,
        minLines: minLines,
        onTap: onTap,
        showCursor: showCursor,
        readOnly: readOnly,
        controller: controller,
        initialValue: initialValue,
        autofocus: autoFocus,
        onEditingComplete: onEditingComplete,
        style: TextStyle(
          fontSize: 18,
        ),
        cursorColor: Theme.of(context).colorScheme.accentColorHeavy,
        decoration: new InputDecoration(
          prefix: prefix != null ? TextFont(text: prefix ?? "") : null,
          suffix: suffix != null ? TextFont(text: suffix ?? "") : null,
          contentPadding: EdgeInsets.only(
              left: 12, right: paddingRight, top: 15, bottom: 10),
          hintText: labelText,
          filled: true,
          fillColor:
              Theme.of(context).colorScheme.lightDarkAccent.withOpacity(0.2),
          isDense: true,
          icon: icon != null
              ? Icon(
                  icon,
                  size: 30,
                  color: Theme.of(context).colorScheme.accentColorHeavy,
                )
              : null,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.lightDarkAccent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.accentColorHeavy),
          ),
        ),
        obscureText: obscureText,
        onChanged: (text) {
          if (onChanged != null) {
            onChanged!(text);
          }
        },
        onFieldSubmitted: (text) {
          if (onSubmitted != null) {
            onSubmitted!(text);
          }
        },
      ),
    );
  }
}