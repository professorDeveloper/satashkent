import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool white;
  const AppLogo({super.key, this.size = 72, this.white = false});

  @override
  Widget build(BuildContext context) {
    final asset = white ? AppAssets.whiteLogo : AppAssets.redLogo;
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
