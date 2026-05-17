import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';

class GoalUniversityResult {
  final Uint8List bytes;
  final String filename;
  final String contentType;
  GoalUniversityResult({
    required this.bytes,
    required this.filename,
    required this.contentType,
  });
}

Future<GoalUniversityResult?> showGoalUniversityDialog(BuildContext context) {
  return showDialog<GoalUniversityResult>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _GoalUniversityDialog(),
  );
}

class _GoalUniversityDialog extends StatefulWidget {
  const _GoalUniversityDialog();

  @override
  State<_GoalUniversityDialog> createState() => _GoalUniversityDialogState();
}

class _GoalUniversityDialogState extends State<_GoalUniversityDialog> {
  XFile? picked;
  Uint8List? bytes;

  Future<void> pickFromGallery() async {
    final p = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 92,
      maxWidth: 1600,
    );
    if (p == null || !mounted) return;
    final data = await p.readAsBytes();
    if (!mounted) return;
    setState(() {
      picked = p;
      bytes = data;
    });
  }

  String _contentType() {
    final name = picked?.name.toLowerCase() ?? '';
    if (name.endsWith('.jpg') || name.endsWith('.jpeg')) return 'image/jpeg';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/png';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return AppDialog(
      title: 'myGoalUniversity'.tr(),
      submitLabel: 'submit'.tr(),
      submitBackground: scheme.onSurface,
      submitForeground: scheme.surface,
      onSubmit: picked == null || bytes == null
          ? null
          : () => Navigator.of(context).pop(
                GoalUniversityResult(
                  bytes: bytes!,
                  filename: picked!.name,
                  contentType: _contentType(),
                ),
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              AppAssets.university,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: pickFromGallery,
            child: DottedBorder(
              color: AppColors.brand.withValues(alpha: 0.6),
              radius: 14,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.brand,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        picked == null
                            ? 'clickToUploadFile'.tr()
                            : picked!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.brand,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'goalUniversityHint'.tr(),
            style: TextStyle(
              fontSize: 11.5,
              fontStyle: FontStyle.italic,
              color: muted.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
          if (bytes != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: muted.withValues(alpha: 0.05),
                height: 140,
                alignment: Alignment.center,
                child: Image.memory(bytes!, fit: BoxFit.contain),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DottedBorder extends StatelessWidget {
  final Color color;
  final double radius;
  final Widget child;
  const DottedBorder({
    super.key,
    required this.color,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: color, radius: radius),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
