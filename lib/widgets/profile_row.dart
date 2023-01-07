import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:story_viewer/models/user.dart';
import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';

class StoryProfileRow extends StatelessWidget {
  final StoryViewer viewer;
  final StoryViewerController viewerController;

  const StoryProfileRow({
    Key? key,
    required this.viewer,
    required this.viewerController,
  }) : super(key: key);

  UserModel get userModel => viewer.userModel ?? UserModel();

  @override
  Widget build(BuildContext context) {
    TextStyle style = viewer.titleStyle ??
        Theme.of(context).textTheme.bodyText1!.merge(
              TextStyle(
                color: Colors.white,
              ),
            );
    Widget text = Row(
      children: [
        Text(
          userModel.username,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: style,
        ),
        Text(' • ', style: style),
        Text(
          getDurationText(_storyDurationSincePosted()),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: style,
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                viewer.onUserTap?.call(viewerController);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  viewer.profilePicture ??
                      (viewer.profileHeroTag != null
                          ? Hero(
                              tag: viewer.profileHeroTag!,
                              child: profilePicture(context),
                            )
                          : profilePicture(context)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: viewer.profileRowItem != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text,
                              const SizedBox(height: 2),
                              viewer.profileRowItem!,
                            ],
                          )
                        : text,
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
                      key: ValueKey('editStory'),
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
                      key: ValueKey('closeStory'),
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
      key: ValueKey('storyProfilePicture'),
      backgroundColor: Colors.grey[500],
      backgroundImage: viewer.userModel!.profilePicture,
      radius: viewer.inline ? 12 : 16,
    );
  }

  void onEditPressed() {
    viewerController.pause();
    viewer.onEditStory?.call(
      viewer,
      viewerController,
    );
  }

  Duration _storyDurationSincePosted() {
    return Duration(
      milliseconds: _currentTime().millisecondsSinceEpoch -
          viewerController.currentStory.timestamp.millisecondsSinceEpoch,
    );
  }

  DateTime _currentTime() {
    if (viewer.serverTimeGap == null) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch +
          viewer.serverTimeGap!.inMilliseconds,
    );
  }

  String getDurationText(Duration duration) {
    if (duration.inSeconds == 0) return '';
    if (duration.isNegative) return '';
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds}${viewer.customizer.seconds}';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}${viewer.customizer.minutes}';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}${viewer.customizer.hours}';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}${viewer.customizer.days}';
    } else {
      return '${duration.inDays ~/ 7}${viewer.customizer.weeks}';
    }
  }
}
