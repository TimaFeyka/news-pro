import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({
    super.key,
    this.isLarge = false,
  });

  final bool isLarge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Google реклама удалена - используется только Yandex реклама
    return const SizedBox();
  }
}

class NativeAdWidget extends ConsumerWidget {
  final bool isSmallSize;

  const NativeAdWidget({super.key, this.isSmallSize = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Google реклама удалена - используется только Yandex реклама
    return const SizedBox();
  }

}
