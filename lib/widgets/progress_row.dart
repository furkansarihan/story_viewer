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
    Color progressColor = viewer.progressColor ?? Colors.white;
    return Padding(
      padding: viewer.inline
          ? viewer.progressRowPadding ??
              const EdgeInsets.only(top: 6, right: 6, left: 6)
          : viewer.progressRowPadding ?? EdgeInsets.zero,
      child: Row(
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
                  decoration: BoxDecoration(
                    color: i < viewerController.currentIndex
                        ? progressColor
                        : progressColor.withAlpha(100),
                    borderRadius: viewer.progressBorderRadius,
                  ),
                  height: viewer.progressHeight,
                ),
              ),
        ],
      ),
    );
  }
}
