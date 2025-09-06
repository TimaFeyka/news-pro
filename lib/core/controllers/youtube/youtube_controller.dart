import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeUrlFetcher {
  // Create clients that follow MediaConnect's simple pattern
  static final _simpleClients = [
    YoutubeApiClient.mediaConnect,
    YoutubeApiClient({
      'context': {
        'client': {
          'clientName': 'SIMPLE_FRONTEND',
          'clientVersion': '0.1',
          'hl': 'en',
          'timeZone': 'UTC',
          'utcOffsetMinutes': 0,
        },
      },
    }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false'),
    YoutubeApiClient({
      'context': {
        'client': {
          'clientName': 'BASIC_PLAYER',
          'clientVersion': '1.0',
          'hl': 'en',
          'timeZone': 'UTC',
          'utcOffsetMinutes': 0,
        },
      },
    }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false'),
  ];

  static Future<String> getBestVideoUrl({
    required String videoId,
    bool live = false,
  }) async {
    final yt = YoutubeExplode();

    try {
      if (live) {
        return await yt.videos.streamsClient
            .getHttpLiveStreamUrl(VideoId(videoId))
            .timeout(const Duration(seconds: 5));
      }

      // Try each simple client
      Exception? lastError;
      for (final client in _simpleClients) {
        try {
          final manifest = await yt.videos.streamsClient.getManifest(videoId,
              ytClients: [client]).timeout(const Duration(seconds: 5));

          if (manifest.muxed.isEmpty) continue;

          // Get highest quality muxed stream
          final stream = manifest.muxed.reduce((a, b) =>
              int.parse(a.qualityLabel.split('p')[0]) >
                      int.parse(b.qualityLabel.split('p')[0])
                  ? a
                  : b);

          return stream.url.toString();
        } catch (e) {
          lastError = e as Exception;
          continue;
        }
      }

      throw lastError ?? Exception('No streams available');
    } finally {
      yt.close();
    }
  }
}

class YoutubeException implements Exception {
  final String message;
  YoutubeException(this.message);
  @override
  String toString() => 'YoutubeException: $message';
}
