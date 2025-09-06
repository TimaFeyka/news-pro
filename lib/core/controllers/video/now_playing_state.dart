import 'package:chewie/chewie.dart';
import '../../models/article.dart';

class NowPlayingState {
  final bool isLoading;
  final bool initialLoaded;
  final bool isPlayingNow;
  final ArticleModel? article;
  final ChewieController? chewieController;
  final String initialUrl;

  NowPlayingState({
    required this.isLoading,
    required this.initialLoaded,
    required this.isPlayingNow,
    this.article,
    this.chewieController,
    required this.initialUrl,
  });

  factory NowPlayingState.initial() {
    return NowPlayingState(
      isLoading: false,
      initialLoaded: false,
      isPlayingNow: false,
      article: null,
      chewieController: null,
      initialUrl: '',
    );
  }

  NowPlayingState copyWith({
    bool? isLoading,
    bool? initialLoaded,
    bool? isPlayingNow,
    ArticleModel? article,
    ChewieController? chewieController,
    String? initialUrl,
  }) {
    return NowPlayingState(
      isLoading: isLoading ?? this.isLoading,
      initialLoaded: initialLoaded ?? this.initialLoaded,
      isPlayingNow: isPlayingNow ?? this.isPlayingNow,
      article: article ?? this.article,
      chewieController: chewieController ?? this.chewieController,
      initialUrl: initialUrl ?? this.initialUrl,
    );
  }

  static NowPlayingState loading() {
    return NowPlayingState(
      isLoading: true,
      initialLoaded: false,
      isPlayingNow: false,
      article: null,
      chewieController: null,
      initialUrl: '',
    );
  }

  static NowPlayingState play({
    required ArticleModel data,
    required ChewieController controller,
    required String initialUrl,
  }) {
    return NowPlayingState(
      isLoading: false,
      initialLoaded: true,
      isPlayingNow: true,
      article: data,
      chewieController: controller,
      initialUrl: initialUrl,
    );
  }
}
