import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pinkvilla/bloc/bloc.dart';
import 'package:pinkvilla/repos/models/video.dart';
import 'package:pinkvilla/utils/logger.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final http.Client httpClient;

  VideoBloc({@required this.httpClient}) : super(VideoInitial());

  @override
  Stream<VideoState> mapEventToState(VideoEvent event) async* {
    final currentState = state;

    if (event is VideoFetched) {
      try {
        if (currentState is VideoInitial) {
          final videos = await _fetchVideos();
          yield VideoSuccess(videos: videos);
          return;
        }
      } catch (_) {
        yield VideoFailure();
      }
    }
    yield null;
  }

  Future<List<Video>> _fetchVideos() async {
    final response = await httpClient
        .get('https://www.pinkvilla.com/feed/video-test/video-feed.json');
    Logger.printObj('https://www.pinkvilla.com/feed/video-test/video-feed'
        '.json');
    if (response.statusCode == 200) {
      final videoData = json.decode(response.body) as List;
      return videoData.map((rawData) {
        return Video.fromJson(rawData);
      }).toList();
    } else {
      throw Exception('error fetching videos');
    }
  }
}
