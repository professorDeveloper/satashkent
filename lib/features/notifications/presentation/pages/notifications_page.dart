import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_item.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<NotificationsBloc>()..add(const NotificationsRequested());
    return BlocProvider<NotificationsBloc>.value(
      value: bloc,
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr()),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.brand,
            displacement: 36,
            onRefresh: () async {
              final bloc = context.read<NotificationsBloc>();
              bloc.add(const NotificationsRefreshed());
              try {
                await bloc.stream
                    .firstWhere((s) => !s.loading)
                    .timeout(const Duration(seconds: 15));
              } catch (_) {}
            },
            child: _NotificationsBody(state: state),
          );
        },
      ),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  final NotificationsState state;
  const _NotificationsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    if (state.loading && state.page.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator(color: AppColors.brand)),
        ],
      );
    }
    if (state.page.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 56,
            color: muted.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'noNotifications'.tr(),
              style: TextStyle(fontSize: 14, color: muted),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: state.page.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) =>
          _NotificationTile(item: state.page.items[i]),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return Material(
      color: item.isUnread
          ? AppColors.brand.withValues(alpha: 0.06)
          : scheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: item.isUnread
            ? () => context
                .read<NotificationsBloc>()
                .add(NotificationMarkedRead(item.id))
            : null,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isUnread
                  ? AppColors.brand.withValues(alpha: 0.3)
                  : Theme.of(context).dividerColor,
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_rounded,
                  color: AppColors.brand,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel(context, item.type),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.createdAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(item.createdAt!),
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brand,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(BuildContext context, String type) {
    switch (type) {
      case 'user_update':
        return 'userUpdateNotification'.tr();
      default:
        return type.isEmpty ? 'notifications'.tr() : type;
    }
  }

  String _formatDate(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
