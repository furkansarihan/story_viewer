import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';
import 'package:story_viewer/story_viewer.dart';

class StoryProgressWidget extends StatefulWidget {
  const StoryProgressWidget({
    Key key,
    this.viewer,
  }) : super(key: key);

  final StoryViewer viewer;

  @override
  _StoryProgressWidgetState createState() => _StoryProgressWidgetState();
}

class _StoryProgressWidgetState extends State<StoryProgressWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
      duration: context.read<StoryViewerCubit>().currentStory.duration,
    );
    animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          context.read<StoryViewerCubit>().next();
          break;
        default:
      }
    });
    super.initState();
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color progressColor = Colors.white;
    return BlocListener<StoryViewerCubit, StoryViewerState>(
      listenWhen: (previous, current) {
        return previous.storyPlaying != current.storyPlaying;
      },
      listener: (context, state) {
        if (state.storyPlaying) {
          animationController.forward();
        } else {
          animationController.stop(canceled: true);
        }
      },
      child: Flexible(
        flex: 1,
        child: Container(
          constraints: BoxConstraints.expand(
            height: widget.viewer.progressHeight,
          ),
          decoration: BoxDecoration(
            color: progressColor.withAlpha(100),
            borderRadius: widget.viewer.progressBorderRadius,
          ),
          margin: EdgeInsets.symmetric(horizontal: 0.5),
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) => Transform(
              transform: Matrix4.diagonal3Values(
                animationController.value,
                1.0,
                1.0,
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                height: widget.viewer.progressHeight,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: widget.viewer.progressBorderRadius,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
