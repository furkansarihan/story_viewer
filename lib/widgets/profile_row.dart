import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
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
                        return;
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
                      bool prewStory = d.localPosition.dx <
                          MediaQuery.of(context).size.width * 0.2;
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
                                        child: profilePicture(context),
                                      )
                                    : profilePicture(context)),
                            if (viewerController.owner &&
                                viewer.onCameraTap != null)
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  radius: 8,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            "${userModel.username}  ${getDurationText(_storyDurationSincePosted())}",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: viewer.titleStyle ??
                                Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        viewer.customizer.infoIcon,
                        color: Colors.white,
                      ),
                      onPressed: onEditPressed,
                    ),
              viewer.inline
                  ? Container()
                  : CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        viewer.customizer.closeIcon,
                        color: Colors.white,
                      ),
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

  Widget profilePicture(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[500],
      backgroundImage: viewer.userModel.profilePicture,
      radius: viewer.inline ? 12 : 16,
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
        milliseconds: _currentTime().millisecondsSinceEpoch -
            viewerController.currentStory.timestamp.millisecondsSinceEpoch);
  }

  DateTime _currentTime() {
    if (viewer.serverTimeGap == null) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch +
          viewer.serverTimeGap.inMilliseconds,
    );
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
