import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question_detail.dart';

class CommentTile extends StatelessWidget {
  final QuestionComment item;
  const CommentTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.5);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(image: item.author.image, name: item.author.name),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  item.author.name.isEmpty
                      ? 'anonymous'.tr()
                      : item.author.name,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: muted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.comment,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.35,
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (item.createdAt != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _format(item.createdAt!),
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _format(DateTime t) {
    final local = t.toLocal();
    final day = DateFormat('MMM d').format(local);
    final time = DateFormat('HH:mm').format(local);
    return '$day ${'atTime'.tr()} $time';
  }
}

class _Avatar extends StatelessWidget {
  final String image;
  final String name;
  const _Avatar({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    final initial =
        (name.isNotEmpty ? name.characters.first : '?').toUpperCase();
    final placeholder = Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.brand.withValues(alpha: 0.12),
      ),
      child: Text(
        initial,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.brand,
          fontSize: 13,
        ),
      ),
    );
    if (image.isEmpty) return placeholder;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: image,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => placeholder,
        placeholder: (_, _) => placeholder,
      ),
    );
  }
}
