import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';

import 'package:story_viewer/story_viewer.dart';

import 'widgets/progress_row.dart';

class UiLayer extends StatelessWidget {
  const UiLayer(
    this.viewer, {
    Key key,
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
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                left: 0,
                child: PreviewShadow(),
              ),
              StoryProgressRow(viewer),
            ],
          ),
        );
      },
    );
  }
}

class PreviewShadow extends StatelessWidget {
  const PreviewShadow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.previewShadowShowing != state2.previewShadowShowing;
      },
      builder: (context, state) {
        return AnimatedContainer(
          width: 80,
          height: MediaQuery.of(context).size.height,
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
