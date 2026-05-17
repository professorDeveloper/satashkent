import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionHtmlView extends StatelessWidget {
  final String html;
  final double fontSize;
  final FontWeight fontWeight;

  const QuestionHtmlView({
    super.key,
    required this.html,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Html(
      data: html,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize),
          fontWeight: fontWeight,
          color: scheme.onSurface,
          lineHeight: const LineHeight(1.5),
        ),
        'p': Style(
          margin: Margins.only(bottom: 8),
          padding: HtmlPaddings.zero,
        ),
        'h1': Style(
          fontSize: FontSize(fontSize + 4),
          fontWeight: FontWeight.w800,
          margin: Margins.only(top: 12, bottom: 6),
        ),
        'h2': Style(
          fontSize: FontSize(fontSize + 2),
          fontWeight: FontWeight.w700,
          margin: Margins.only(top: 10, bottom: 6),
        ),
        'sup': Style(
          fontSize: FontSize(fontSize * 0.7),
          verticalAlign: VerticalAlign.sup,
        ),
        'sub': Style(
          fontSize: FontSize(fontSize * 0.7),
          verticalAlign: VerticalAlign.sub,
        ),
        'strong': Style(fontWeight: FontWeight.w800),
        'em': Style(fontStyle: FontStyle.italic),
        'a': Style(
          color: scheme.primary,
          textDecoration: TextDecoration.underline,
        ),
      },
    );
  }
}
