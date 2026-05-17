import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/referral_remote_data_source.dart';
import '../../data/models/referral_models.dart';
import '../widgets/referral_list_section.dart';
import '../widgets/referral_stats_section.dart';
import '../widgets/your_code_card.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  Future<String?>? codeFuture;
  Future<ReferralListResult>? listFuture;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  void loadAll() {
    final ds = getIt<ReferralRemoteDataSource>();
    codeFuture = ds.getCode();
    listFuture = ds.getMyReferrals();
  }

  Future<void> refresh() async {
    setState(loadAll);
    await Future.wait([codeFuture!, listFuture!]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('referralProgram'.tr())),
      body: RefreshIndicator(
        color: AppColors.brand,
        displacement: 28,
        edgeOffset: 0,
        onRefresh: refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            FutureBuilder<String?>(
              future: codeFuture,
              builder: (context, snap) => YourCodeCard(code: snap.data),
            ),
            const SizedBox(height: 12),
            FutureBuilder<ReferralListResult>(
              future: listFuture,
              builder: (context, snap) {
                final r = snap.data ?? const ReferralListResult();
                return Column(
                  children: [
                    ReferralStatsSection(stats: r.stats),
                    const SizedBox(height: 12),
                    ReferralListSection(items: r.data),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
