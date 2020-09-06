import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    controller.addCallBacks(
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
      FocusScope.of(context).requestFocus(textNode);
      refreshState();
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
    Widget returnW = Column(
      //mainAxisSize: MainAxisSize.min,
      key: ObjectKey("layer_ui"),
      children: [
        Container(
          height: controller.isLong && !viewer.inline
              ? 0
              : MediaQuery.of(context).padding.top,
        ),
        StoryProgressRow(
          key: ObjectKey("progressrow"),
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
            height: ScreenUtil().setWidth(viewer.inline ? 176 : 256),
            stops: [0.0, 0.5, 1.0],
            alphas: [0, 45, 40],
            top: true,
          ),
          previewShadow(),
          returnW
        ],
      );
    } else {
      returnW = Stack(
        children: [
          GradientShadow(
            key: GlobalKey(),
            height: ScreenUtil().setWidth(viewer.inline ? 176 : 256),
            stops: [0.0, 0.5, 1.0],
            alphas: [0, 45, 40],
            top: true,
          ),
          GradientShadow(
            key: GlobalKey(),
            height: ScreenUtil().setWidth(384),
            stops: [0.0, 1.0],
            alphas: [0, 150],
            top: false,
          ),
          previewShadow(),
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
                      height: ScreenUtil.screenHeight,
                    ),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutCirc,
                        height: (ScreenUtil.screenHeight -
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
                print("hasFocus $hasFocus");
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

  Widget previewShadow() {
    return AnimatedOpacity(
      opacity: prewShadowHideState == HideState.fadeIn ? 1 : 0,
      duration: Duration(milliseconds: 30),
      child: IgnorePointer(
        child: Container(
          width: ScreenUtil().setWidth(256),
          height: ScreenUtil.screenHeight,
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
