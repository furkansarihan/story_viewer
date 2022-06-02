import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';
import 'package:story_viewer/widgets/source_row.dart';

class StoryReplyRow extends StatelessWidget {
  final StoryViewer viewer;
  final TextEditingController? textController;
  final StoryViewerController viewerController;
  final Function(bool hasFocus)? onFocusChange;
  final FocusNode? textNode;

  const StoryReplyRow({
    Key? key,
    required this.viewer,
    required this.viewerController,
    this.textController,
    this.onFocusChange,
    this.textNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewerController.owner) {
      return Container(
        width: 0,
        height: 0,
      );
    }
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    Widget returnW = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: bottom),
      color: Colors.black26,
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Focus(
                  onFocusChange: onFocusChange,
                  child: textField(context),
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                viewer.customizer.sendIcon,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                viewer.onStoryReplied?.call(
                  viewerController,
                  viewerController.currentStory.id,
                  textController!.text,
                );
              },
            )
          ],
        ),
      ),
    );
    if (viewer.showSource) {
      returnW = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SourceRow(
            viewer: viewer,
            source: viewerController.currentStory.source,
          ),
          returnW,
        ],
      );
    }
    return returnW;
  }

  Widget textField(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoTextField(
        focusNode: textNode,
        controller: textController,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        padding: const EdgeInsets.all(12),
        placeholderStyle: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white54,
        ),
        placeholder: viewer.customizer.replyPlaceholder,
        decoration: BoxDecoration(),
        maxLines: 1,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
        onSubmitted: (String message) {
          viewer.onStoryReplied?.call(
            viewerController,
            viewerController.currentStory.id,
            message,
          );
        },
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: TextField(
          focusNode: textNode,
          controller: textController,
          keyboardAppearance: MediaQuery.of(context).platformBrightness,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(14),
            border: InputBorder.none,
            helperStyle: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white60,
            ),
            hintStyle: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white54,
            ),
            hintText: viewer.customizer.replyPlaceholder,
          ),
          maxLines: 1,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
          ),
          onSubmitted: (String message) {
            viewer.onStoryReplied?.call(
              viewerController,
              viewerController.currentStory.id,
              message,
            );
          },
        ),
      );
    }
  }
}
