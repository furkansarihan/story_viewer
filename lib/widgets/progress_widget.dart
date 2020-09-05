import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';

class StoryProgressWidget extends StatelessWidget {
  final StoryViewer viewer;
  final StoryViewerController viewerController;

  const StoryProgressWidget({
    Key key,
    this.viewer,
    this.viewerController,
  }) : super(key: key);

  StoryViewerController get controller => viewerController;

  void onPlayed() {
    controller.animationController.forward();
  }

  void onPaused() {
    controller.animationController.stop(canceled: true);
  }

  @override
  Widget build(BuildContext context) {
    double storyWidth = ScreenUtil.screenWidth / controller.stories.length - 1;
    controller.addCallBacks(
      onPlayed: onPlayed,
      onPaused: onPaused,
    );
    return Flexible(
      flex: 1,
      child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) => Container(
                height: 4,
                width: storyWidth,
                color: Colors.white54,
                margin: EdgeInsets.symmetric(horizontal: 0.5),
                child: Stack(
                  children: [
                    Container(
                      width: controller.animationController.value * storyWidth,
                      height: 4,
                      color: Colors.white,
                    ),
                  ],
                ),
              )),
    );
  }
}
