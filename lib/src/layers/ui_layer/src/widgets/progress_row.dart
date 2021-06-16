import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:story_viewer/story_viewer.dart';
import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';

import 'progress_widget.dart';

class StoryProgressRow extends StatelessWidget {
  const StoryProgressRow(
    this.viewer, {
    Key key,
  }) : super(key: key);

  final StoryViewer viewer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.storyIndex != state2.storyIndex;
      },
      builder: (context, state) {
        Color progressColor = Colors.white;
        return Padding(
          padding: viewer.progressRowPadding,
          child: Row(
            children: [
              for (var i = 0; i < viewer.stories.length; i++)
                if (i == context.read<StoryViewerCubit>().state.storyIndex)
                  StoryProgressWidget(viewer: viewer)
                else
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                        color: i <
                                context
                                    .read<StoryViewerCubit>()
                                    .state
                                    .storyIndex
                            ? progressColor
                            : progressColor.withAlpha(100),
                        borderRadius: viewer.progressBorderRadius,
                      ),
                      height: viewer.progressHeight,
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
