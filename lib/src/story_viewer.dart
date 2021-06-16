import 'dart:developer';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/story_viewer_cubit.dart';
import 'layers/layers.dart';
import 'models/models.dart';

class StoryViewer extends StatelessWidget {
  const StoryViewer({
    Key key,
    this.systemOverlayStyle,
    this.stories,
    this.progressHeight = 2,
    this.progressBorderRadius = BorderRadius.zero,
    this.progressRowPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 4,
    ),
  }) : super(key: key);

  final SystemUiOverlayStyle systemOverlayStyle;
  final List<StoryModel> stories;

  final double progressHeight;
  final BorderRadiusGeometry progressBorderRadius;
  final EdgeInsets progressRowPadding;

  @override
  Widget build(BuildContext context) {
    Widget body = BlocProvider<StoryViewerCubit>(
      create: (context) => StoryViewerCubit(context, this),
      child: _Root(this),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Theme.of(context).canvasColor,
            systemNavigationBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
          ),
      child: body,
    );
  }
}

class _Root extends StatelessWidget {
  const _Root(this.viewer, {Key key}) : super(key: key);

  final StoryViewer viewer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.uiShowing != state2.uiShowing;
      },
      builder: (context, state) {
        return DismissiblePage(
          minRadius: 0,
          maxRadius: 24,
          onDismiss: () => Navigator.of(context).pop(),
          isFullScreen: false,
          onDragStart: () {
            log('onDragStart');
            context.read<StoryViewerCubit>().pause();
          },
          onDragEnd: () {
            log('onDragStart');
            context.read<StoryViewerCubit>().play();
          },
          //disabled: !state.uiShowing,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(color: Colors.black45),
              ContentLayer(viewer),
              UiLayer(viewer),
              const GestureLayer(),
            ],
          ),
        );
      },
    );
  }
}
