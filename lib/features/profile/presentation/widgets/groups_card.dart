import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GroupsCard extends StatelessWidget {
  static const Color background = Color(0xFF1B3A6E);
  final List<String> groups;
  const GroupsCard({super.key, this.groups = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: background,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -16,
            child: Icon(
              Icons.school_rounded,
              size: 130,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: groups.isEmpty
                ? Text(
                    'noGroups'.tr(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'groups'.tr().toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (final g in groups)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            g,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
