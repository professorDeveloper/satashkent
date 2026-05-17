import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InputAnswerField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const InputAnswerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<InputAnswerField> createState() => _InputAnswerFieldState();
}

class _InputAnswerFieldState extends State<InputAnswerField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant InputAnswerField old) {
    super.didUpdateWidget(old);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'answerWritePlaceholder'.tr(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'answerPreview'.tr(),
              style: TextStyle(
                fontSize: 13,
                color: muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.value.trim(),
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
