import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:spring_button/spring_button.dart';
import 'package:story_viewer/models/user.dart';
import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';

class StoryProfileRow extends StatelessWidget {
  final StoryViewer viewer;
  final StoryViewerController viewerController;

  const StoryProfileRow({
    Key key,
    this.viewer,
    this.viewerController,
  }) : super(key: key);

  UserModel get userController => viewer.userModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(24),
        vertical: ScreenUtil().setWidth(24),
      ),
      width: ScreenUtil.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: viewer.fromAnonymous
                  ? Container()
                  : GestureDetector(
                      onTap: viewer.onUserTap == null
                          ? null
                          : () {
                              viewerController.pause();
                              if (viewerController.owner) {
                                viewer.onCameraTap?.call();
                                return null;
                              }
                              viewer.onUserTap?.call();
                            },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          viewer.profilePicture ??
                              ClipOval(
                                child: Image.network(
                                  viewer.userModel.profilePictureUrl,
                                  width: ScreenUtil().setWidth(86),
                                  height: ScreenUtil().setWidth(86),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                          Container(
                            width: ScreenUtil().setWidth(24),
                          ),
                          Flexible(
                            child: Text(
                              "${userController.username}  ${getDurationText(_storyDurationSincePosted())}",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    )),
          Row(children: [
            viewer.onEditStory == null
                ? Container()
                : SpringButton(
                    SpringButtonType.WithOpacity,
                    Icon(FlevaIcons.more_horizontal,
                        size: ScreenUtil().setWidth(86), color: Colors.white),
                    onTap: onEditPressed,
                    useCache: false,
                    scaleCoefficient: 1.0,
                  ),
            Container(
              width: ScreenUtil().setWidth(32),
            ),
            SpringButton(
              SpringButtonType.WithOpacity,
              Icon(
                FlevaIcons.close,
                color: Colors.white,
                size: ScreenUtil().setWidth(86),
              ),
              onTap: () {
                viewerController.complated();
              },
              useCache: false,
              scaleCoefficient: 1.0,
            ),
          ]),
        ],
      ),
    );
  }

  void onEditPressed() {
    viewerController.pause();
    viewer.onEditStory?.call(
      viewerController: viewerController,
      viewer: viewer,
    );
  }

  Duration _storyDurationSincePosted() {
    return Duration(
        milliseconds:
            viewerController.currentStory.timestamp.millisecondsSinceEpoch -
                _currentTime().millisecondsSinceEpoch);
  }

  DateTime _currentTime() {
    if (viewer.serverTimeGap == null) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch +
            viewer.serverTimeGap.inMilliseconds);
  }

  String getDurationText(Duration duration) {
    if (duration.inSeconds == 0) return "";
    if (duration.inMinutes < 1) {
      return "•  ${duration.inSeconds}${viewer.textRepo.seconds}";
    } else if (duration.inMinutes < 60) {
      return "•  ${duration.inMinutes}${viewer.textRepo.minutes}";
    } else if (duration.inHours < 24) {
      return "•  ${duration.inHours}${viewer.textRepo.hours}";
    } else {
      return "•  ${duration.inDays}${viewer.textRepo.days}";
    }
  }
}
