import 'dart:developer';

import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';
import 'package:story_viewer/story_viewer.dart';

class ContentLayer extends StatelessWidget {
  const ContentLayer(this.viewer, {Key key}) : super(key: key);

  final StoryViewer viewer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      // TODO: fix called multiple times
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        bool result = state1.storyIndex != state2.storyIndex;
        log('buildWhen: $result');
        return result;
      },
      builder: (context, state) {
        log('BlocBuilder: ExtendedImage: ${state.storyIndex}');
        // TODO: switch case for story types
        //return ButtonBar();
        return ClipRRect(
          borderRadius: BorderRadius.circular(viewer.contentBorderRadius),
          child: ImageStory(
            context.watch<StoryViewerCubit>().currentStory.imageProvider,
          ),
        );
      },
    );
  }
}

class ImageStory extends StatelessWidget {
  const ImageStory(this.image, {Key key}) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage(
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
      image: image,
      //enableSlideOutPage: true,
      //mode: ExtendedImageMode.gesture,
      enableMemoryCache: true,
      //alignment: viewer.mediaAlignment ?? Alignment.center,
      //fit: viewer.mediaFit ?? BoxFit.fitWidth,
      // ignore: missing_return
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            /*return PlaceholderImage(
                  loading: true,
                  backgroundColor: widget.viewer.placeholderBackground,
                  backgroundColors: widget.viewer.placeholderBackgrounds,
                );*/
            break;
          case LoadState.failed:
            /*return PlaceholderImage(
                  backgroundColor: widget.viewer.placeholderBackground,
                  backgroundColors: widget.viewer.placeholderBackgrounds,
                  iconData: widget.viewer.customizer.failedImageIcon,
                );*/
            break;

          case LoadState.completed:
            log('LoadState.completed');
            int storyHashCode = context
                .read<StoryViewerCubit>()
                .currentStory
                .imageProvider
                .hashCode;
            if (context.read<StoryViewerCubit>().isLoaded(storyHashCode)) {
              return;
            }
            context.read<StoryViewerCubit>().load(storyHashCode);
            SchedulerBinding.instance.addPostFrameCallback((p) {
              context.read<StoryViewerCubit>().play();
            });
            break;
          default:
        }
      },
      /*initGestureConfigHandler: (s) {
            return GestureConfig(
              maxScale: 1.0,
              minScale: 1.0,
              animationMinScale: 1.0,
              animationMaxScale: 1.0,
            );
          },
          heroBuilderForSlidingPage: (Widget result) {
            return Hero(
              tag: controller.currentHeroTag,
              child: result,
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                final Hero hero = flightDirection == HeroFlightDirection.pop
                    ? fromHeroContext.widget
                    : toHeroContext.widget;
                return hero.child;
              },
            );
          },*/
    );
  }
}
