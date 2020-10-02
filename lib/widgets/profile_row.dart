import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
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

  UserModel get userModel => viewer.userModel ?? UserModel();

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
                    onTap: () {
                      if (viewerController.owner) {
                        viewer.onCameraTap?.call();
                        return null;
                      } else {
                        viewer.onUserTap?.call(
                          viewerController: viewerController,
                        );
                      }
                      if (viewer.onCameraTap != null ||
                          viewer.onUserTap != null) {
                        viewerController.pause();
                      }
                    },
                    onTapUp: (d) {
                      bool prewStory =
                          d.localPosition.dx < ScreenUtil.screenWidth * 0.2;
                      viewerController.handPlay(prewStory: prewStory);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            viewer.profilePicture ??
                                (viewer.profileHeroTag != null
                                    ? Hero(
                                        tag: viewer.profileHeroTag,
                                        child: profilePicture(),
                                      )
                                    : profilePicture()),
                            if (viewerController.owner &&
                                viewer.onCameraTap != null)
                              Positioned(
                                bottom: ScreenUtil().setSp(-8),
                                right: ScreenUtil().setSp(-8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  radius: ScreenUtil().setSp(24),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: ScreenUtil().setSp(40),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Container(
                          width: ScreenUtil().setWidth(24),
                        ),
                        Flexible(
                          child: Text(
                            "${userModel.username}  ${getDurationText(_storyDurationSincePosted())}",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: viewer.titleStyle ??
                                TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(40),
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Row(
            children: [
              viewer.onEditStory == null
                  ? Container()
                  : CupertinoButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                      ),
                      child: Icon(
                        viewer.customizer.infoIcon,
                        color: Colors.white,
                        size: ScreenUtil().setWidth(86),
                      ),
                      minSize: ScreenUtil().setWidth(86),
                      onPressed: onEditPressed,
                    ),
              viewer.inline
                  ? Container()
                  : CupertinoButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                      ),
                      child: Icon(
                        viewer.customizer.closeIcon,
                        color: Colors.white,
                        size: ScreenUtil().setWidth(86),
                      ),
                      minSize: ScreenUtil().setWidth(86),
                      onPressed: () {
                        viewerController.complated();
                      },
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget profilePicture() {
    return ClipOval(
        child: userModel.profilePictureUrl.isNotEmpty
            ? Image.network(
                viewer.userModel.profilePictureUrl,
                width: ScreenUtil().setWidth(viewer.inline ? 64 : 86),
                height: ScreenUtil().setWidth(viewer.inline ? 64 : 86),
                fit: BoxFit.fitHeight,
              )
            : Container());
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
        milliseconds: _currentTime().millisecondsSinceEpoch -
            viewerController.currentStory.timestamp.millisecondsSinceEpoch);
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
    if (duration.isNegative) return "";
    if (duration.inMinutes < 1) {
      return "•  ${duration.inSeconds}${viewer.customizer.seconds}";
    } else if (duration.inMinutes < 60) {
      return "•  ${duration.inMinutes}${viewer.customizer.minutes}";
    } else if (duration.inHours < 24) {
      return "•  ${duration.inHours}${viewer.customizer.hours}";
    } else {
      return "•  ${duration.inDays}${viewer.customizer.days}";
    }
  }
}
