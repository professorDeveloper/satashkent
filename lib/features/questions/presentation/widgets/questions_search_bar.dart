import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class QuestionsSearchBar extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onChanged;
  final VoidCallback onFiltersTap;
  final int activeFilters;
  const QuestionsSearchBar({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.onFiltersTap,
    required this.activeFilters,
  });

  @override
  State<QuestionsSearchBar> createState() => _QuestionsSearchBarState();
}

class _QuestionsSearchBarState extends State<QuestionsSearchBar> {
  late final TextEditingController controller =
      TextEditingController(text: widget.initial);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      widget.onChanged(v.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 0.6,
                ),
              ),
              child: TextField(
                controller: controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'searchByTitleOrContent'.tr(),
                  hintStyle: TextStyle(color: muted, fontSize: 13.5),
                  prefixIcon: Icon(Icons.search_rounded, color: muted, size: 20),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _FiltersButton(
            onTap: widget.onFiltersTap,
            count: widget.activeFilters,
          ),
        ],
      ),
    );
  }
}

class _FiltersButton extends StatelessWidget {
  final VoidCallback onTap;
  final int count;
  const _FiltersButton({required this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 18, color: scheme.onSurface),
              const SizedBox(width: 6),
              Text(
                'filters'.tr(),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brand,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
