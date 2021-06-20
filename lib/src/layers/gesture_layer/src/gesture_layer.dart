import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';

class GestureLayer extends StatelessWidget {
  const GestureLayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (d) {
        log('onTapUp');
        // viewController.handPlay(prewStory: prewStory);

        if (context.read<StoryViewerCubit>().state.replying) {
          FocusScope.of(context).unfocus();
          context.read<StoryViewerCubit>().play();
          return;
        }

        if (context.read<StoryViewerCubit>().state.uiShowing) {
          bool prevStory =
              d.localPosition.dx < MediaQuery.of(context).size.width * 0.2;
          if (prevStory) {
            context.read<StoryViewerCubit>().previous();
          } else {
            context.read<StoryViewerCubit>().next();
          }
        } else {
          context.read<StoryViewerCubit>().play();
        }
      },
      onTapDown: (d) {
        log('onTapDown');
        bool prevShadow =
            d.localPosition.dx < MediaQuery.of(context).size.width * 0.2;
        // viewController.handPause(prewShadowShow: prewShadowShow);
        context.read<StoryViewerCubit>().pause(
              hideUi: true,
              showPrevShadow: prevShadow,
            );
      },
      onTapCancel: () {
        // TODO: fix
        if (!context.read<StoryViewerCubit>().state.uiShowing) return;
        log('onTapCancel');
        context.read<StoryViewerCubit>().play();
      },
      onHorizontalDragStart: (details) {
        log('onHorizontalDragStart');
        FocusScope.of(context).unfocus();
        context.read<StoryViewerCubit>().pause(
              hideUi: false,
            );
      },
      onHorizontalDragEnd: (details) {
        log('onHorizontalDragEnd');
        context.read<StoryViewerCubit>().play();
      },
      onHorizontalDragUpdate: (details) {},
    );
  }
}
