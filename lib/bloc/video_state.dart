import 'package:equatable/equatable.dart';
import 'package:pinkvilla/repos/models/video.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoFailure extends VideoState {}

class VideoSuccess extends VideoState {
  final List<Video> videos;

  VideoSuccess({this.videos});

  VideoSuccess copyWith({
    List<Video> videos,
  }) {
    return VideoSuccess(
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object> get props => [videos];
}
