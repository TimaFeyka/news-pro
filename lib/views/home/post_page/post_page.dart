import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/controllers/analytics/analytics_controller.dart';
import '../../../core/models/article.dart';
import '../../../core/repositories/posts/post_repository.dart';
import 'components/normal_post.dart';
import 'components/video_post.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({
    super.key,
    required this.article,
  });
  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Google реклама удалена - используется только Yandex реклама
    final isVideoPost = ArticleModel.isVideoArticle(article);
    AnalyticsController.logPostView(article);
    PostRepository.addViewsToPost(postID: article.id);
    if (isVideoPost) {
      return VideoPost(article: article);
    } else {
      return NormalPost(article: article);
    }
  }
}
