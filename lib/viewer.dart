import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:story_viewer/layer_additional.dart';
import 'blur_slider.dart';
import 'layer_media.dart';
import 'layer_ui.dart';
import 'models/story_item.dart';
import 'models/user.dart';
import 'models/text_repo.dart';
import 'viewer_controller.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

class StoryViewer extends StatefulWidget {
  final String displayerUserID;
  final UserModel userModel;
  final List<StoryItemModel> stories;
  final List<Widget> Function({
    StoryViewer viewer,
    StoryViewerController viewerController,
  }) getAdditionalLayersBeforeMedia;
  final List<Widget> Function({
    StoryViewer viewer,
    StoryViewerController viewerController,
  }) getAdditionalLayersAfterMedia;
  final String heroKey;
  final String heroTag;
  final int initIndex;
  final bool fromAnonymous;
  final bool trusted;
  final bool hasReply;
  final bool inline;
  final bool showSource;
  final Function({String storyID}) onEachStoryLoadComplated;
  final Function({String storyID}) onScreenShotDetected;
  final Function({String storyID, String message}) onStoryReplied;
  final Function({
    StoryViewer viewer,
    StoryViewerController viewerController,
  }) onEditStory;
  final Function onUserTap;
  final Function onCameraTap;
  final Function onDispose;
  final Widget profilePicture;
  final TextRepo customTexts;
  final Alignment mediaAlignment;
  final BoxFit mediaFit;
  final Color backgroundColor;
  final Color placeholderBackground;
  final List<Color> placeholderBackgrounds;
  final Duration serverTimeGap;
  final bool Function() willPop;
  final EdgeInsets progressRowPadding;
  final BorderRadius progressBorderRadius;
  final double progressHeight;
  final Color progressColor;
  final TextStyle titleStyle;

  TextRepo get textRepo => customTexts ?? TextRepo();

  bool pop(BuildContext context) {
    if (inline) {
      return false;
    }
    if (willPop == null) {
      Navigator.of(context).pop();
      return true;
    }
    if (willPop()) {
      Navigator.of(context).pop();
      return true;
    }
    return false;
  }

  const StoryViewer(
      {Key key,
      this.userModel,
      this.stories,
      this.fromAnonymous = false,
      this.trusted = true,
      this.heroKey,
      this.initIndex = 0,
      this.onEachStoryLoadComplated,
      this.onScreenShotDetected,
      this.onEditStory,
      this.onDispose,
      this.heroTag,
      this.onStoryReplied,
      this.onUserTap,
      this.onCameraTap,
      this.profilePicture,
      this.customTexts,
      this.getAdditionalLayersBeforeMedia,
      this.getAdditionalLayersAfterMedia,
      this.displayerUserID,
      this.mediaAlignment,
      this.mediaFit,
      this.backgroundColor,
      this.placeholderBackground,
      this.placeholderBackgrounds,
      this.serverTimeGap,
      this.willPop,
      this.hasReply = false,
      this.inline = false,
      this.showSource = false,
      this.progressRowPadding,
      this.progressBorderRadius = BorderRadius.zero,
      this.progressColor = Colors.white,
      this.progressHeight = 4,
      this.titleStyle})
      : super(key: key);
  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with TickerProviderStateMixin {
  StoryViewerController viewController;
  ScreenshotCallback screenshotCallback;

  bool get trusted => viewController.trusted;

  @override
  void initState() {
    viewController = StoryViewerController(
        ownerUserID: widget.displayerUserID,
        heroKey: widget.heroKey,
        heroTag: widget.heroTag,
        stories: widget.stories,
        trusted: widget.trusted,
        currentIndex: widget.initIndex);
    viewController.animationController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
      duration: viewController.currentStory.duration,
    );
    viewController.animationController.addStatusListener((status) {
      //print("$status ${viewController.animationController.isAnimating}");
      if (status == AnimationStatus.forward) {
      } else if (status == AnimationStatus.completed) {
        viewController.next();
      } else if (status == AnimationStatus.dismissed) {
        viewController.pause();
      }
    });
    viewController.addCallBacks(onComplated: onComplated, onPlayed: onPlayed);
    initScreenShot(trusted);
    super.initState();
  }

  void onComplated() {
    widget.pop(context);
  }

  List<String> loadedStories = List<String>();
  void onPlayed() {
    String currentStoryID = viewController.currentStory.id;
    if (loadedStories.contains(currentStoryID)) {
      return null;
    }
    loadedStories.add(currentStoryID);
    widget.onEachStoryLoadComplated?.call(storyID: currentStoryID);
    initScreenShot(trusted);
  }

  void initScreenShot(bool trusted) {
    if (!trusted) {
      return null;
    }
    if (screenshotCallback != null) {
      return null;
    }
    screenshotCallback = ScreenshotCallback(requestPermissions: false);
    screenshotCallback.initialize().then((value) {
      screenshotCallback.addListener(() {
        print('screenshot detected');
        widget.onScreenShotDetected
            ?.call(storyID: viewController.currentStory.id);
      });
    });
  }

  void endblur() {
    initScreenShot(true);
    viewController.trusted = true;
    refreshState();
    viewController.play();
  }

  @override
  void dispose() {
    viewController.animationController.dispose();
    screenshotCallback?.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: 1080,
      height: 1920,
      allowFontScaling: true,
    );
    List<Widget> layers = [
      Container(
        color: widget.backgroundColor ?? Colors.black,
      ),
    ];
    if (widget.getAdditionalLayersBeforeMedia != null) {
      layers.add(StoryAdditionalLayer(
        viewerController: viewController,
        viewer: widget,
        additions: widget.getAdditionalLayersBeforeMedia,
      ));
    }
    layers.addAll([
      StoryLayerMedia(
        viewerController: viewController,
        viewer: widget,
      ),
    ]);
    if (widget.getAdditionalLayersAfterMedia != null) {
      layers.add(StoryAdditionalLayer(
        viewerController: viewController,
        viewer: widget,
        additions: widget.getAdditionalLayersAfterMedia,
      ));
    }
    layers.addAll([
      BlurSlider(
        onSliderEnd: endblur,
        showBlurSlier: !trusted,
      ),
      StoryLayerUI(
        viewerController: viewController,
        viewer: widget,
      ),
    ]);
    Widget body = Stack(
      alignment: widget.mediaAlignment ?? Alignment.center,
      children: layers,
    );
    if (viewController.isLong) {
      body = SafeArea(
        bottom: false,
        child: body,
      );
    }
    if (!trusted) {
      return body;
    }
    body = GestureDetector(
        onTapUp: (d) {
          bool prewStory = d.globalPosition.dx < ScreenUtil.screenWidth * 0.2;
          viewController.handPlay(prewStory: prewStory);
        },
        onTapDown: (d) {
          bool prewShadowShow =
              d.globalPosition.dx < ScreenUtil.screenWidth * 0.2;
          viewController.handPause(prewShadowShow: prewShadowShow);
        },
        onTapCancel: () {
          viewController.cancelHider();
        },
        onVerticalDragEnd: (c) {
          viewController.handPlay(prewStory: false);
        },
        onHorizontalDragEnd: (c) {
          viewController.handPlay(prewStory: false);
        },
        child: body);
    if (widget.inline) {
      return body;
    }
    return ExtendedImageSlidePage(
      slidePageBackgroundHandler: (Offset offset, Size pageSize) {
        double opacity = 1 - offset.dy.abs() / ScreenUtil.screenHeight;
        opacity = opacity > 0 ? opacity : 0;
        opacity = opacity < 1 ? opacity : 1;
        return Colors.black.withOpacity(opacity);
      },
      slideScaleHandler: (Offset offset, {ExtendedImageSlidePageState state}) {
        double scale = (offset.dy / (ScreenUtil.screenHeight * 0.4)) / 10;
        return 1 - scale;
      },
      slideOffsetHandler: (Offset offset, {ExtendedImageSlidePageState state}) {
        if (viewController.uiHiding && state.isSliding) {
          return Offset(0, 0);
        }
        if (offset.dy < 0) {
          if (!viewController.owner && !widget.inline) {
            viewController.replyPause();
          } else if (viewController.owner) {
            viewController.infoPause();
            widget.onEditStory?.call(
              viewerController: viewController,
              viewer: widget,
            );
          }
        }
        double limit = ScreenUtil.screenHeight * 0.3;
        double dy = offset.dy < limit ? offset.dy : limit;
        dy = dy < 0 ? 0 : dy;
        return Offset(0, dy);
      },
      slideEndHandler: (Offset offset,
          {ScaleEndDetails details, ExtendedImageSlidePageState state}) {
        const int parameter = 6;
        viewController.play();
        return doubleCompare(
                offset.dy.abs(), state.pageSize.height / parameter) >
            0;
      },
      slideAxis: SlideAxis.vertical,
      slideType: SlideType.wholePage,
      resetPageDuration: Duration(milliseconds: 100),
      onSlidingPage: (state) {
        if (state.isSliding) {
          viewController.pause();
          viewController.cancelHider();
        } else {
          viewController.play();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Material(color: Colors.transparent, child: body)),
    );
  }

  void refreshState() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
