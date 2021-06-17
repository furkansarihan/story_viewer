import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:story_viewer/story_viewer.dart';
import 'viewer.dart';
import 'viewer_controller.dart';
import 'widgets/placeholder_image.dart';

class StoryLayerMedia extends StatefulWidget {
  final StoryViewerController? viewerController;
  final StoryViewer? viewer;

  const StoryLayerMedia({Key? key, this.viewerController, this.viewer})
      : super(key: key);
  @override
  StoryLayerMediaState createState() => StoryLayerMediaState();
}

class StoryLayerMediaState extends State<StoryLayerMedia> {
  StoryViewerController? get controller => widget.viewerController;

  @override
  void initState() {
    super.initState();
    controller!.addListener(onIndexChanged: onIndexChanged);
  }

  void onIndexChanged() {
    refreshState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller!.currentStory.imageProvider == null) {
      return const SizedBox.shrink();
    }
    StoryItemModel currentItem = controller!.currentStory;
    Widget returnW = ExtendedImage(
      width: MediaQuery.of(context).size.width,
      height: widget.viewer!.inline ? null : MediaQuery.of(context).size.height,
      image: currentItem.imageProvider!,
      enableSlideOutPage: true,
      mode: ExtendedImageMode.gesture,
      enableMemoryCache: true,
      alignment: widget.viewer!.mediaAlignment ?? Alignment.center,
      fit: widget.viewer!.mediaFit ?? BoxFit.fitWidth,
      initGestureConfigHandler: (s) {
        return GestureConfig(
          maxScale: 1.0,
          minScale: 1.0,
          animationMinScale: 1.0,
          animationMaxScale: 1.0,
        );
      },
      heroBuilderForSlidingPage: (Widget result) {
        return Hero(
          tag: controller!.currentHeroTag,
          child: result,
          flightShuttleBuilder: (BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext) {
            final Hero hero = flightDirection == HeroFlightDirection.pop
                ? fromHeroContext.widget as Hero
                : toHeroContext.widget as Hero;
            return hero.child;
          },
        );
      },
      // ignore: missing_return
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return PlaceholderImage(
              loading: true,
              backgroundColor: widget.viewer!.placeholderBackground,
              backgroundColors: widget.viewer!.placeholderBackgrounds,
            );
          case LoadState.failed:
            return PlaceholderImage(
              backgroundColor: widget.viewer!.placeholderBackground,
              backgroundColors: widget.viewer!.placeholderBackgrounds,
              iconData: widget.viewer!.customizer.failedImageIcon,
            );
          case LoadState.completed:
            controller!.load(currentItem.imageProvider!);
            SchedulerBinding.instance!.addPostFrameCallback((p) {
              controller!.play();
            });
            break;
          default:
        }
      },
    );
    if (widget.viewer!.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.viewer!.borderRadius as BorderRadius?,
        child: returnW,
      );
    }
    return returnW;
  }

  void refreshState() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
