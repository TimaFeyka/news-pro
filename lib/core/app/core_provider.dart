import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../firebase_options.dart';
import '../controllers/applinks/app_links_controller.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/config/config_controllers.dart';
import '../controllers/internet/internet_state_provider.dart';
import '../controllers/notifications/notification_handler.dart';
import '../controllers/notifications/notification_local.dart';
import '../localization/app_locales.dart';
import '../logger/app_logger.dart';
import '../models/notification_model.dart';
import '../repositories/auth/auth_repository.dart';
import '../repositories/others/onboarding_local.dart';
import '../repositories/others/search_local.dart';

/// App Initial State
enum AppState {
  introNotDone,
  consentNotDone,
  loggedIn,
  loggedOut,
}

final coreAppStateProvider =
    FutureProvider.family<AppState, BuildContext>((ref, context) async {
  Log.info('Initializing dependencies');

  /// Load All Repository and Other Necassary Services Here
  try {
    ref.read(internetStateProvider);
    await ref.read(configProvider.notifier).init();
    await NotificationHandler.init(context);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
    final onboarding = await OnboardingRepository().init();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await ref.read(authRepositoryProvider).init();
    await SearchLocalRepo().init();
    Hive.registerAdapter(NotificationModelAdapter());
    await Hive.openBox<NotificationModel>('notifications');
    await Hive.openBox('settingsBox');

    final config = ref.read(configProvider).value;
    ref.read(authController);

    ref.read(localNotificationProvider);
    // Google реклама удалена - используется только Yandex реклама
    AppLocales.setLocaleMessages();
    ref.read(applinkNotifierProvider(context));
    final onboardinEnabled = config?.onboardingEnabled ?? false;
    final isOnboardingDone = onboarding.isIntroDone();
    final isConsentDone = onboarding.isConsentDone();

    // Is user has been introduced to our app
    if (onboardinEnabled) {
      if (isOnboardingDone) {
        if (isConsentDone) {
          return AppState.loggedIn;
        } else {
          return AppState.loggedOut;
        }
      } else {
        return AppState.introNotDone;
      }
    } else {
      if (isConsentDone) {
        return AppState.loggedIn;
      } else {
        return AppState.loggedOut;
      }
    }
  } on Exception catch (e) {
    Log.info(e.toString());
    return AppState.loggedOut;
  }
});
