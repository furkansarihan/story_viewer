import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/story_viewer_cubit.dart';
import 'layers/layers.dart';
import 'models/models.dart';

class StoryViewer extends StatelessWidget {
  const StoryViewer({
    Key? key,
    this.systemOverlayStyle,
    required this.stories,
    this.contentBorderRadius = 0.0,
    this.progressHeight = 2,
    this.progressBorderRadius = BorderRadius.zero,
    this.progressRowPadding = const EdgeInsets.only(
      top: 6,
      left: 4,
      right: 4,
    ),
    this.profileRow,
    this.replyRow,
    this.onSwipeUp,
    this.swipeUpTreshold = 30,
    this.fullScreen = true,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  final SystemUiOverlayStyle? systemOverlayStyle;
  final List<StoryModel> stories;

  final double contentBorderRadius;

  final double progressHeight;
  final BorderRadiusGeometry progressBorderRadius;
  final EdgeInsets progressRowPadding;

  final Widget? profileRow;
  final Widget? replyRow;

  final Function? onSwipeUp;
  final double swipeUpTreshold;
  final bool fullScreen;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget body = BlocProvider<StoryViewerCubit>(
      create: (c) => StoryViewerCubit(context, this),
      child: fullScreen
          ? _Root(this)
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(color: backgroundColor),
                ContentLayer(this),
                UiLayer(this),
              ],
            ),
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
      child: Material(color: Colors.transparent, child: body),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root(this.viewer, {Key? key}) : super(key: key);

  final StoryViewer viewer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.uiShowing != state2.uiShowing;
      },
      builder: (context, state) {
        return DismissiblePage(
          minRadius: viewer.contentBorderRadius,
          maxRadius: viewer.contentBorderRadius * 2,
          backgroundColor: viewer.backgroundColor,
          direction: DismissiblePageDismissDirection.down,
          onDismissed: () => Navigator.of(context).maybePop(),
          isFullScreen: false,
          onDragStart: () {
            debugPrint('onDragStart');
            FocusScope.of(context).unfocus();
            context.read<StoryViewerCubit>().pause();
          },
          onDragUpdate: (details) {
            // TODO:
            // log('onDragUpdate: ${details.primaryDelta}');
            // if ((details.primaryDelta?.abs() ?? 0) > viewer.swipeUpTreshold) {
            //   viewer.onSwipeUp?.call();
            // }
          },
          onDragEnd: () {
            // log('onDragStart: ${details.primaryVelocity}');
            context.read<StoryViewerCubit>().play();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: ContentLayer(viewer),
              ),
              UiLayer(viewer),
            ],
          ),
        );
      },
    );
  }
}
