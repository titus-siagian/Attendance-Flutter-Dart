import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ess_iris/utils/constant.dart';

class AppInput extends StatelessWidget {
  final String? placeholder;
  final String? title;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization = TextCapitalization.none;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign = TextAlign.start;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus = false;
  final bool readOnly = false;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String obscuringCharacter = '•';
  final bool? obscureText;
  final bool autocorrect = true;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions = true;
  final int? maxLines;
  final int? minLines;
  final bool expands = false;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth = 2.0;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding = const EdgeInsets.all(20.0);
  final bool enableInteractiveSelection = true;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const AppInput({
    Key? key,
    this.placeholder,
    this.title,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlignVertical,
    this.toolbarOptions,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Text(
            title ?? '',
            style: kMediumMedium.copyWith(color: kDarkBlueColor),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
          style: TextStyle(
            color: !(enabled ?? true) ? Colors.grey[500] : null,
          ),
          enableSuggestions: false,
          initialValue: initialValue,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          minLines: minLines,
          maxLines: maxLines ?? 1,
        ),
      ],
    );
  }
}
