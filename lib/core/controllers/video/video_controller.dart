import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/article.dart';
import '../youtube/youtube_controller.dart';
import 'now_playing_state.dart';

class PlayerState extends StateNotifier<NowPlayingState> {
  PlayerState() : super(NowPlayingState.initial());

  ChewieController? _chewieController;

  Future<void> initializePlayer(
      String url, ArticleModel articleModel, bool isYoutube, bool live) async {
    if (state.chewieController != null) {
      if (state.article == articleModel) {
        return;
      }
      changeVideo(url, articleModel, isYoutube, live);
    } else {
      _initializeNewPlayer(url, articleModel, isYoutube, live);
    }
  }

  Future<void> _initializeNewPlayer(
      String url, ArticleModel articleModel, bool isYoutube, bool live) async {
    state = NowPlayingState.loading();

    String videoUrl = '';

    if (isYoutube) {
      final response = await YoutubeUrlFetcher.getBestVideoUrl(videoId: url);
      videoUrl = response;
    }

    final videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: videoPlayerController.value.aspectRatio,
    );

    state = NowPlayingState.play(
      data: articleModel,
      controller: _chewieController!,
      initialUrl: url,
    );
  }

  Future<void> changeVideo(
      String url, ArticleModel articleModel, bool isYoutube, bool live) async {
    disposePlayer();
    await _initializeNewPlayer(url, articleModel, isYoutube, live);
  }

  void disposePlayer() {
    state.chewieController?.videoPlayerController.dispose();
    state.chewieController?.dispose();
    state = NowPlayingState.initial();
  }

  Future<void> play() async {
    if (!state.isPlayingNow) {
      state.chewieController?.play();
      state = state.copyWith(isPlayingNow: true);
    }
  }

  Future<void> pause() async {
    if (state.isPlayingNow) {
      state.chewieController?.pause();
      state = state.copyWith(isPlayingNow: false);
    }
  }

  void togglePlayPause() {
    if (state.isPlayingNow) {
      pause();
    } else {
      play();
    }
  }

  @override
  void dispose() {
    state.chewieController?.dispose();
    super.dispose();
  }
}

final playerProvider = StateNotifierProvider<PlayerState, NowPlayingState>(
  (ref) => PlayerState(),
);
