import 'package:flutter/material.dart';

import 'viewer.dart';
import 'viewer_controller.dart';
import 'widgets/fast_emojis.dart';
import 'widgets/gradient_shadow.dart';
import 'widgets/profile_row.dart';
import 'widgets/progress_row.dart';
import 'widgets/reply_row.dart';

class StoryLayerUI extends StatefulWidget {
  final StoryViewerController viewerController;
  final StoryViewer viewer;

  const StoryLayerUI({
    Key key,
    this.viewerController,
    this.viewer,
  }) : super(key: key);
  @override
  _StoryLayerUIState createState() => _StoryLayerUIState();
}

enum HideState { idle, fadeOut, fadeIn }

class _StoryLayerUIState extends State<StoryLayerUI> {
  StoryViewerController get controller => widget.viewerController;
  StoryViewer get viewer => widget.viewer;

  TextEditingController textController = TextEditingController();
  FocusNode textNode = FocusNode();

  HideState hideState = HideState.idle;
  HideState prewShadowHideState = HideState.idle;

  @override
  void initState() {
    super.initState();
    controller.addListener(
      onIndexChanged: onIndexChanged,
      onUIShow: onUIShow,
      onUIHide: onUIHide,
      onPlayed: onPlayed,
      onPaused: onPaused,
      onPrewShadowShow: onPrewShadowShow,
      onPrewShadowHide: onPrewShadowHide,
    );
  }

  void onUIHide() {
    hideState = HideState.fadeOut;
    refreshState();
  }

  void onUIShow() {
    hideState = HideState.fadeIn;
    refreshState();
  }

  void onIndexChanged() {
    refreshState();
  }

  void onPlayed() {
    hideState = HideState.idle;
    prewShadowHideState = HideState.idle;
  }

  void onPaused() {
    if (controller.replying) {
      if (context != null) {
        FocusScope.of(context).requestFocus(textNode);
      }
    }
  }

  void onPrewShadowShow() {
    prewShadowHideState = HideState.fadeIn;
    refreshState();
  }

  void onPrewShadowHide() {
    prewShadowHideState = HideState.fadeOut;
    refreshState();
  }

  bool get showEmojis => controller.replying;

  @override
  Widget build(BuildContext context) {
    bool isLong = MediaQuery.of(context).size.aspectRatio > 9 / 16;
    Widget returnW = Column(
      key: ObjectKey('layer_ui'),
      children: [
        Container(
          height:
              isLong && !viewer.inline ? 0 : MediaQuery.of(context).padding.top,
        ),
        StoryProgressRow(
          key: ObjectKey('progressrow'),
          viewer: viewer,
          viewerController: controller,
        ),
        StoryProfileRow(
          viewer: viewer,
          viewerController: controller,
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );

    Widget fastEmojis = Container();
    if (showEmojis) {
      fastEmojis = FastEmojis(
        onEmojiSelected: (String emoji) {
          FocusScope.of(context).requestFocus(FocusNode());
          viewer.onStoryReplied?.call(
            storyID: controller.currentStory.id,
            message: emoji,
          );
          controller.replyPlay();
        },
      );
    }

    if (!viewer.hasReply) {
      returnW = Stack(
        children: [
          GradientShadow(
            key: GlobalKey(),
            height: viewer.inline ? 48 : 64,
            stops: [0.0, 1.0],
            alphas: [0, 70],
            top: true,
          ),
          prevShadow(),
          returnW
        ],
      );
    } else {
      returnW = Stack(
        children: [
          GradientShadow(
            key: GlobalKey(),
            height: viewer.inline ? 48 : 72,
            stops: [0.0, 1.0],
            alphas: [0, 120],
            top: true,
          ),
          GradientShadow(
            key: GlobalKey(),
            height: 72,
            stops: [0.0, 1.0],
            alphas: [0, 150],
            top: false,
          ),
          prevShadow(),
          IgnorePointer(
            ignoring: !showEmojis,
            child: GestureDetector(
                onTapUp: (t) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  controller.replyPlay();
                },
                onVerticalDragUpdate: (down) {
                  if (down.delta.dy > 25) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.replyPlay();
                  }
                },
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOutCirc,
                      color: showEmojis ? Colors.black45 : Colors.transparent,
                      height: MediaQuery.of(context).size.height,
                    ),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutCirc,
                        height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).viewInsets.bottom),
                        child: fastEmojis),
                  ],
                )),
          ),
          Positioned(
            bottom: 0,
            child: StoryReplyRow(
              viewer: viewer,
              viewerController: controller,
              textController: textController,
              textNode: textNode,
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  controller.replyPause();
                }
              },
            ),
          ),
          returnW
        ],
      );
    }
    return AnimatedOpacity(
        opacity: hideState == HideState.fadeOut ? 0 : 1,
        duration: Duration(milliseconds: 90),
        child: returnW);
  }

  Widget prevShadow() {
    return AnimatedOpacity(
      opacity: prewShadowHideState == HideState.fadeIn ? 1 : 0,
      duration: Duration(milliseconds: 150),
      child: IgnorePointer(
        child: Container(
          width: 64,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.black.withAlpha(60),
                  Colors.black.withAlpha(20),
                  Colors.transparent,
                ],
                begin: FractionalOffset(0.0, 0.5),
                end: FractionalOffset(1.0, 0.5),
                stops: [0, 0.6, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
    );
  }

  void refreshState() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
