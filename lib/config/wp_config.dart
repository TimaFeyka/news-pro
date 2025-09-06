import 'package:flutter/material.dart';

class WPConfig {
  /// The Name of your app
  static const String appName = 'Блог военного';

  /// The url of your app, should not inclued any '/' slash or any 'https://' or 'http://'
  /// Otherwise it may break the compaitbility, And your website must be
  /// a wordpress website.
  static const String url = 'xn----9sbeccl2buaedadb.xn--p1ai';

  /// Your onesignal id
  static const String oneSignalId = 'ce2a200b-9912-4935-a987-e493a735c90c';

  /// Primary Color of the App, must be a valid hex code after '0xFF'
  static const Color primaryColor = Color(0xFFF89D0C);

  /// Deeplinks config
  /// If you are using something like this:
  /// https://newspro.uixxy.com/sample-post/
  /// make this true or else false
  static const bool usingPlainFormatLink = true;

  /// IF we should keep the caching of home categories tab caching or not
  /// if this is false, then we will fetch new data and refresh the
  /// list if user changes tab or click on one
  static bool enableHomeTabCache = true;
}
