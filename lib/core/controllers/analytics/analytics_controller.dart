import 'package:firebase_analytics/firebase_analytics.dart';

import '../../models/article.dart';
import '../../models/category.dart';

class AnalyticsController {
  /// Logs User Post View
  static Future<void> logPostView(ArticleModel article) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'post_view',
      parameters: {
        'post_name': article.title,
        'post_author_id': article.authorID,
        'post_link': article.link,
      },
    );
  }

  /// Logs User Category View
  static Future<void> logCategoryView(CategoryModel categoryModel) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'category_view',
      parameters: {
        'category_name': categoryModel.name,
        'category_id': categoryModel.id,
        'category_link': categoryModel.link,
      },
    );
  }

  /// Logs User Login
  static Future<void> logUserLogin() async {
    await FirebaseAnalytics.instance.logLogin();
  }

  /// Logs User Sign Up
  static Future<void> logSignUp(String? method) async {
    await FirebaseAnalytics.instance.logSignUp(signUpMethod: method ?? 'Email');
  }

  /// Logs User Saved Favourite
  static Future<void> logUserFavourite(ArticleModel article) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'post_saved',
      parameters: {
        'post_name': article.title,
        'post_author_id': article.authorID,
        'post_feature_image': article.featuredImage ?? '',
        'post_link': article.link,
      },
    );
  }

  /// Logs user save removes from favourites
  static Future<void> logUserFavouriteRemoved(ArticleModel article) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'post_saved',
      parameters: {
        'post_name': article.title,
        'post_author_id': article.authorID,
        'post_feature_image': article.featuredImage ?? '',
        'post_link': article.link,
      },
    );
  }

  /// Log User Search
  static Future<void> logUserSearch(String searchedQuery) async {
    await FirebaseAnalytics.instance.logSearch(searchTerm: searchedQuery);
  }

  /// Log User Share Content
  static Future<void> logUserContentShare(ArticleModel article) async {
    await FirebaseAnalytics.instance.logShare(
      contentType: 'Article',
      itemId: article.id.toString(),
      method: 'Share',
    );
  }
}
