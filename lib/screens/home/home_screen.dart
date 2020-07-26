import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinkvilla/base/app_video_player.dart';
import 'package:pinkvilla/bloc/bloc.dart';
import 'package:pinkvilla/repos/models/video.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is VideoFailure) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is VideoSuccess) {
          if (state.videos.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          return SafeArea(
            child: Scaffold(
              body: PageView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  Video videoDetail = state.videos[position];
                  return Container(
                    color: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        AppVideoPlayer(
                          url: videoDetail.url,
                        ),
                        /*  onScreenControls(),*/
                      ],
                    ),
                  );
                },
                itemCount: state.videos.length,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
