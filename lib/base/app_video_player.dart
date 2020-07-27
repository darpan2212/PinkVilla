import 'package:flutter/material.dart';
import 'package:pinkvilla/utils/logger.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String url;
  final VoidCallback onVideoFinish;

  AppVideoPlayer({@required this.url, @required this.onVideoFinish});

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController _controller;
  VoidCallback onVideoFinish;

  @override
  void initState() {
    onVideoFinish = widget.onVideoFinish;
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
    _controller.addListener(checkIfVideoFinished);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkIfVideoFinished() {
    if (_controller == null ||
        _controller.value == null ||
        _controller.value.position == null ||
        _controller.value.duration == null) return;

    if (_controller.value.position.inSeconds ==
        _controller.value.duration.inSeconds) {
      Logger.printObj('Video finished');
      onVideoFinish.call();
    }
  }
}
