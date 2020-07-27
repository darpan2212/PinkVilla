import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinkvilla/base/app_video_player.dart';
import 'package:pinkvilla/base/spinner_animation.dart';
import 'package:pinkvilla/bloc/bloc.dart';
import 'package:pinkvilla/config/assets.dart';
import 'package:pinkvilla/config/dimen.dart';
import 'package:pinkvilla/repos/models/video.dart';
import 'package:pinkvilla/utils/logger.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      keepPage: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
                controller: pageController,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  Video videoDetail = state.videos[position];
                  return Container(
                    color: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        AppVideoPlayer(
                          url: videoDetail.url,
                          onVideoFinish: () {
                            Logger.printObj(pageController.page);
                            if ((pageController.page.toInt() + 1) <
                                state.videos.length) {
                              pageController.nextPage(
                                duration: Duration(
                                  milliseconds: 100,
                                ),
                                curve: Curves.linear,
                              );
                            }
                          },
                        ),
                        onScreenControls(videoDetail),
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

  Widget onScreenControls(Video videoDetail) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: videoDesc(videoDetail),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 60, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  userProfile(videoDetail),
                  videoControlAction(
                    icon: AppIcons.heart,
                    label: '${videoDetail.likeCount}',
                  ),
                  videoControlAction(
                    icon: AppIcons.chat_bubble,
                    label: '${videoDetail.commentCount}',
                  ),
                  videoControlAction(
                    icon: AppIcons.reply,
                    label: '${videoDetail.shareCount}',
                    size: 27,
                  ),
                  SpinnerAnimation(
                    body: audioSpinner(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget videoDesc(Video videoDetail) {
    return Container(
      padding: EdgeInsets.only(left: 16, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 7),
            child: Text(
              '@${videoDetail.user.name}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 7),
            child: Text(
              '${videoDetail.title}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.music_note,
                size: 19,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  '${videoDetail.user.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget userProfile(Video videoDetail) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(videoDetail.user.headshot),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 18,
                width: 18,
                child: Icon(
                  Icons.add,
                  size: 10,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 42, 84, 1),
                  shape: BoxShape.circle,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget videoControlAction({IconData icon, String label, double size = 35}) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: size,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Dimen.defaultTextSpacing,
                bottom: Dimen.defaultTextSpacing),
            child: Text(
              label ?? "",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget audioSpinner() {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[800],
            Colors.grey[900],
            Colors.grey[900],
            Colors.grey[800]
          ],
          stops: [0.0, 0.4, 0.6, 1.0],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage("assets/images/avatar.png"),
        ),
      ),
    );
  }
}
