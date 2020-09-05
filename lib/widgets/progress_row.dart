import 'package:flutter/material.dart';
import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';
import 'package:story_viewer/widgets/progress_widget.dart';

class StoryProgressRow extends StatelessWidget {
  final StoryViewer viewer;
  final StoryViewerController viewerController;

  const StoryProgressRow({Key key, this.viewer, this.viewerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < viewer.stories.length; i++)
          if (i == viewerController.currentIndex)
            StoryProgressWidget(
              key: GlobalKey(),
              viewer: viewer,
              viewerController: viewerController,
            )
          else
            Flexible(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.5),
                    height: 4,
                    color: i < viewerController.currentIndex
                        ? Colors.white
                        : Colors.white54)),
      ],
    );
  }
}
