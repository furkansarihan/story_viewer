import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_viewer/layer_additional.dart';
import 'package:story_viewer/story_viewer.dart';
import 'layer_media.dart';
import 'layer_ui.dart';

enum StoryRatio { r9_16, r16_9, r3_4, r4_3 }

class StoryViewer extends StatefulWidget {
  final StoryViewerController? viewerController;
  final String? displayerUserID;
  final UserModel? userModel;
  final List<StoryItemModel>? stories;
  final void Function(
    StoryViewer viewer,
    StoryViewerController viewerController,
  )? setupCustomWidgets;
  final List<Widget> Function(
    StoryViewer viewer,
    StoryViewerController viewerController,
  )? getAdditionalLayersBeforeMedia;
  final List<Widget> Function(
    StoryViewer viewer,
    StoryViewerController viewerController,
  )? getAdditionalLayersAfterMedia;
  final String? heroTag;
  final String? profileHeroTag;
  final int initIndex;
  final Widget? profileRowItem;
  final bool trusted;
  final bool hasReply;
  final StoryRatio ratio;
  final bool showSource;
  final Function({String storyID})? onEachStoryLoadComplated;
  final Function(
    StoryViewerController viewerController,
    String? storyID,
    String? message,
  )? onStoryReplied;
  final Function(
    StoryViewer viewer,
    StoryViewerController viewerController,
  )? onEditStory;
  final Function(
    StoryViewerController viewerController,
  )? onUserTap;
  final Function? onDispose;
  final Widget? profilePicture;
  final Customizer? customValues;
  final Alignment? mediaAlignment;
  final BoxFit? mediaFit;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? placeholderBackground;
  final List<Color>? placeholderBackgrounds;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Duration? serverTimeGap;
  final bool Function()? willPop;
  final EdgeInsets? progressRowPadding;
  final BorderRadius progressBorderRadius;
  final double progressHeight;
  final Color progressColor;
  final TextStyle? titleStyle;
  final EdgeInsets padding;
  final bool loop;

  Customizer get customizer => customValues ?? Customizer();
  bool get inline => ratio != StoryRatio.r9_16;

  Future<bool> pop(BuildContext context) async {
    if (inline) {
      return false;
    }
    if (willPop == null) {
      return await Navigator.of(context).maybePop();
    }
    if (willPop!()) {
      return await Navigator.of(context).maybePop();
    }
    return false;
  }

  const StoryViewer(
      {Key? key,
      this.viewerController,
      this.userModel,
      this.stories,
      this.trusted = true,
      this.initIndex = 0,
      this.profileRowItem,
      this.onEachStoryLoadComplated,
      this.onEditStory,
      this.onDispose,
      this.heroTag,
      this.onStoryReplied,
      this.onUserTap,
      this.profilePicture,
      this.customValues,
      this.getAdditionalLayersBeforeMedia,
      this.getAdditionalLayersAfterMedia,
      this.displayerUserID,
      this.mediaAlignment,
      this.mediaFit,
      this.backgroundColor,
      this.placeholderBackground,
      this.placeholderBackgrounds,
      this.systemOverlayStyle,
      this.serverTimeGap,
      this.willPop,
      this.hasReply = false,
      this.showSource = false,
      this.progressRowPadding,
      this.progressBorderRadius = BorderRadius.zero,
      this.progressColor = Colors.white,
      this.borderRadius,
      this.progressHeight = 4,
      this.titleStyle,
      this.setupCustomWidgets,
      this.padding = EdgeInsets.zero,
      this.ratio = StoryRatio.r9_16,
      this.loop = false,
      this.profileHeroTag})
      : super(key: key);
  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with TickerProviderStateMixin {
  late StoryViewerController viewController;
  double lastY = 0.0;
  bool? get trusted => viewController.trusted;

  @override
  void initState() {
    if (widget.viewerController == null) {
      viewController = StoryViewerController(
        currentIndex: widget.initIndex,
      );
    } else {
      viewController = widget.viewerController!;
    }
    viewController.trusted = widget.trusted;
    viewController.viewer = widget;
    viewController.animationController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
      duration: viewController.currentStory.duration,
    );
    viewController.animationController.addStatusListener(
      viewController.statusListener,
    );
    viewController.addListener(onComplated: onComplated, onPlayed: onPlayed);
    widget.setupCustomWidgets?.call(
      widget,
      viewController,
    );
    super.initState();
  }

  void onComplated() {
    widget.pop(context);
  }

  List<String> loadedStories = <String>[];
  void onPlayed() {
    String currentStoryID = viewController.currentStory.id;
    if (loadedStories.contains(currentStoryID)) {
      return null;
    }
    loadedStories.add(currentStoryID);
    widget.onEachStoryLoadComplated?.call(storyID: currentStoryID);
  }

  void endblur() {
    viewController.trusted = true;
    refreshState();
    viewController.play();
  }

  @override
  void dispose() {
    viewController.animationController.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLong = MediaQuery.of(context).size.aspectRatio < (9 / 17);
    List<Widget> layers = [
      Container(
        color: widget.backgroundColor ?? Colors.transparent,
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
        key: ValueKey(viewController.currentStory.imageProvider),
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
      if (!widget.inline && !widget.trusted)
        BlurSlider(
          onSliderEnd: endblur,
          showBlurSlier: !trusted!,
          slideToSee: widget.customizer.slideToSee,
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
    if (widget.borderRadius != null) {
      body = ClipRRect(
        borderRadius: widget.borderRadius as BorderRadius?,
        child: body,
      );
    }
    if (isLong) {
      body = SafeArea(
        bottom: false,
        child: body,
      );
    }
    if (!trusted!) {
      return body;
    }
    body = GestureDetector(
      onTapUp: (d) {
        bool prewStory =
            d.localPosition.dx < MediaQuery.of(context).size.width * 0.2;
        viewController.handPlay(prewStory: prewStory);
      },
      onTapDown: (d) {
        bool prewShadowShow =
            d.localPosition.dx < MediaQuery.of(context).size.width * 0.2;
        viewController.handPause(prewShadowShow: prewShadowShow);
      },
      onTapCancel: () {
        viewController.cancelHider();
      },
      onVerticalDragEnd: widget.inline
          ? (c) {
              viewController.handPlay(prewStory: false);
            }
          : null,
      onHorizontalDragEnd: widget.inline
          ? (c) {
              viewController.handPlay(prewStory: false);
            }
          : null,
      child: body,
    );
    if (widget.inline) {
      double _width =
          MediaQuery.of(context).size.width - (widget.padding.horizontal);
      double? _height;
      switch (widget.ratio) {
        case StoryRatio.r16_9:
          _height = (_width * 9) / 16;
          break;
        case StoryRatio.r3_4:
          _height = (_width * 4) / 3;
          break;
        case StoryRatio.r4_3:
          _height = (_width * 3) / 4;
          break;
        default:
      }
      return Padding(
        padding: widget.padding,
        child: SizedBox(width: _width, height: _height, child: body),
      );
    }
    return ExtendedImageSlidePage(
      slidePageBackgroundHandler: (Offset offset, Size pageSize) {
        double opacity =
            1 - offset.dy.abs() / MediaQuery.of(context).size.height;
        opacity = opacity > 0 ? opacity : 0;
        opacity = opacity < 1 ? opacity : 1;
        return Colors.black.withOpacity(opacity);
      },
      slideScaleHandler: (Offset offset, {ExtendedImageSlidePageState? state}) {
        double scale =
            (offset.dy / (MediaQuery.of(context).size.height * 0.4)) / 10;
        return 1 - scale;
      },
      slideOffsetHandler: (Offset offset,
          {ExtendedImageSlidePageState? state}) {
        if (viewController.uiHiding && state!.isSliding ||
            viewController.replying) {
          lastY = offset.dy;
          return Offset(0, 0);
        }
        if (offset.dy < 0) {
          if (!viewController.owner && !widget.inline && lastY == 0) {
            viewController.replyPause();
          } else if (viewController.owner) {
            viewController.infoPause();
            widget.onEditStory?.call(
              widget,
              viewController,
            );
          }
        }
        lastY = offset.dy;
        double limit = MediaQuery.of(context).size.height * 0.3;
        double dy = offset.dy < limit ? offset.dy : limit;
        dy = dy < 0 ? 0 : dy;
        return Offset(0, dy);
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
        value: widget.systemOverlayStyle ??
            SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Theme.of(context).canvasColor,
              systemNavigationBarIconBrightness:
                  Theme.of(context).brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
            ),
        child: Material(
          color: Colors.transparent,
          child: body,
        ),
      ),
    );
  }

  int doubleCompare(double value, double other, {double precision = 1e-10}) {
    if (value.isNaN || other.isNaN) {
      throw UnsupportedError('Compared with Infinity or NaN');
    }
    final double n = value - other;
    if (n.abs() < precision) {
      return 0;
    }
    return n < 0 ? -1 : 1;
  }

  void refreshState() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
