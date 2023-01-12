import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';
import 'package:story_viewer/src/layers/gesture_layer/gesture_layer.dart';

import 'package:story_viewer/story_viewer.dart';

import 'widgets/progress_row.dart';

class UiLayer extends StatelessWidget {
  const UiLayer(
    this.viewer, {
    Key? key,
  }) : super(key: key);

  final StoryViewer viewer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.uiShowing != state2.uiShowing;
      },
      builder: (context, state) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: state.uiShowing ? 1 : 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 86,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black38, Colors.transparent]),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: PreviewShadow(),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: StoryProgressRow(viewer),
              ),
              const GestureLayer(),
              Positioned(
                top: viewer.progressRowPadding.vertical + viewer.progressHeight,
                left: 0,
                right: 0,
                child: viewer.profileRow ?? ProfileRow(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: viewer.replyRow ?? const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PreviewShadow extends StatelessWidget {
  const PreviewShadow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.previewShadowShowing != state2.previewShadowShowing;
      },
      builder: (context, state) {
        return AnimatedContainer(
          width: 80,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: state.previewShadowShowing
                  ? [Colors.black38, Colors.transparent]
                  : [Colors.transparent, Colors.transparent],
            ),
          ),
        );
      },
    );
  }
}
