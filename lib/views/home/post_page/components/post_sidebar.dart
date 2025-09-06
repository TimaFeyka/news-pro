import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/html/font_size_controller.dart';
import '../../../../core/themes/theme_manager.dart';

class PostSidebar extends ConsumerWidget {
  const PostSidebar({
    super.key,
    required this.link,
    required this.title,
  });

  final String link;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsize = ref.watch(fontSizeProvider.notifier);
    final isdark = ref.watch(isDarkMode(context));
    final themeController = ref.read(themeModeProvider.notifier);

    return Positioned.directional(
      textDirection: Directionality.of(context),
      top: MediaQuery.sizeOf(context).height / 2.5,
      end: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
          border: Border.all(color: AppColors.placeholder, width: 0.3),
          boxShadow: AppDefaults.boxShadow,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(AppDefaults.radius),
            bottomStart: Radius.circular(AppDefaults.radius),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(AppDefaults.radius),
            bottomStart: Radius.circular(AppDefaults.radius),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    fontsize.increaseSize();
                  },
                  icon: const Icon(
                    Icons.text_increase_outlined,
                  ),
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  iconSize: 16,
                ),
                IconButton(
                  onPressed: () {
                    fontsize.decreaseSize();
                  },
                  icon: const Icon(
                    Icons.text_decrease_outlined,
                  ),
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  iconSize: 16,
                ),
                IconButton(
                  onPressed: () {
                    themeController.changeThemeMode(
                        isdark
                            ? AdaptiveThemeMode.light
                            : AdaptiveThemeMode.dark,
                        context);
                  },
                  icon: Icon(
                    isdark ? Icons.light_mode : Icons.dark_mode,
                  ),
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  iconSize: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
