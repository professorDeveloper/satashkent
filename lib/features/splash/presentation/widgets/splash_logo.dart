import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../../../core/theme/app_colors.dart';

class SplashLogo extends StatefulWidget {
  final double size;
  const SplashLogo({super.key, this.size = 160});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  late final Animation<double> _draw = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
  );

  late final Animation<double> _fill = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.62, 0.88, curve: Curves.easeOut),
  );

  late final List<Path> _paths = _logoSvgPaths
      .map((d) => parseSvgPathData(d))
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          return CustomPaint(
            painter: _LogoPainter(
              paths: _paths,
              drawProgress: _draw.value,
              fillProgress: _fill.value,
            ),
          );
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final List<Path> paths;
  final double drawProgress;
  final double fillProgress;

  _LogoPainter({
    required this.paths,
    required this.drawProgress,
    required this.fillProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const vbW = 28.0;
    const vbH = 32.0;
    final scale = size.height / vbH;
    final drawW = vbW * scale;
    final dx = (size.width - drawW) / 2;

    canvas.save();
    canvas.translate(dx, 0);
    canvas.scale(scale);

    if (fillProgress < 1.0) {
      final strokeAlpha = (1.0 - fillProgress).clamp(0.0, 1.0);
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.55
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.brand.withValues(alpha: strokeAlpha);

      for (final path in paths) {
        for (final metric in path.computeMetrics()) {
          final mid = metric.length / 2;
          final reach = mid * drawProgress;
          final start = (mid - reach).clamp(0.0, metric.length);
          final end = (mid + reach).clamp(0.0, metric.length);
          if (end > start) {
            canvas.drawPath(metric.extractPath(start, end), stroke);
          }
        }
      }
    }

    if (fillProgress > 0) {
      final fill = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.brand.withValues(alpha: fillProgress);
      for (final path in paths) {
        canvas.drawPath(path, fill);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LogoPainter old) =>
      old.drawProgress != drawProgress || old.fillProgress != fillProgress;
}

const _logoSvgPaths = <String>[
  'M0 0V18.1562L0.00798403 18.3338C0.263473 25.9955 6.41118 32 13.9987 32C21.5862 32 27.7339 25.9982 27.9894 18.3338L28 18.0594V0H0ZM25.8283 18.0325L25.8204 18.2584C25.7166 21.3656 24.4418 24.2683 22.2275 26.4367C20.0106 28.6077 17.0885 29.8048 13.9987 29.8048C11.9601 29.8048 9.99335 29.2829 8.25283 28.3037V22.1189H14.8583V15.4418H19.3666V15.4499H21.4637V8.77276H25.8283V18.0325ZM21.4664 6.65288H19.3693V13.3219H12.7638V19.999H6.15835V26.7998C6.02794 26.6815 5.89754 26.5631 5.77246 26.4393C3.55822 24.271 2.28343 21.3683 2.17964 18.2611L2.17166 18.0163V2.19252H25.831V6.65288H21.4664Z',
  'M10.664 8.12712C10.664 7.31468 10.012 6.65558 9.20829 6.65558H4.05859V8.77546H17.2695V6.65558H12.1198C11.3161 6.65558 10.664 7.31468 10.664 8.12712Z',
  'M4.05859 11.202V13.3219H8.56691V17.8791H10.664V13.3219V11.202H8.56691H4.05859Z',
  'M21.6766 17.7769L20.6068 16.6954L18.8716 18.4494L18.6081 17.4379L17.147 17.828L17.7751 20.2331L16.7718 19.9587L16.3752 21.4329L18.7571 22.0866L18.02 22.8264L19.0872 23.9106L20.833 22.1566L21.0991 23.1654L22.5602 22.7726L21.9268 20.3703L22.9301 20.642L23.324 19.165L20.9474 18.5194L21.682 17.7769H21.6766ZM20.4285 19.964L21.6846 20.3057L20.4285 20.6447L20.7638 21.9144L19.8483 20.9836L18.9248 21.9117L19.2655 20.642L18.0146 20.2976L19.2655 19.964L18.9355 18.7023L19.8456 19.6224L20.7638 18.6943L20.4285 19.9587V19.964Z',
];
