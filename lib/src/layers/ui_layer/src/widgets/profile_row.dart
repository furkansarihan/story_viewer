import 'package:flutter/material.dart';
import 'package:story_viewer/src/models/models.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:story_viewer/story_viewer.dart';
import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    this.userModel,
    this.profilePicturePadding,
    this.usernamePadding,
    this.usernameStyle,
    this.storyTimeStyle,
    this.trailingWidgets,
    this.customizer = const Customizer(),
    Key key,
  }) : super(key: key);

  final UserModel userModel;
  final EdgeInsets profilePicturePadding;
  final EdgeInsets usernamePadding;
  final TextStyle usernameStyle;
  final TextStyle storyTimeStyle;
  final List<Widget> trailingWidgets;
  final Customizer customizer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userModel?.profilePicture != null
                ? Padding(
                    padding: profilePicturePadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF555555),
                        backgroundImage: userModel.profilePicture,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                userModel?.username != null
                    ? Text(
                        userModel.username,
                        style: usernameStyle ??
                            Theme.of(context)
                                .textTheme
                                .bodyText2
                                .merge(TextStyle(color: Colors.white)),
                        maxLines: 1,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 8),
                StoryTime(customizer: customizer),
              ],
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: Row(
            children: [
              for (var widget in trailingWidgets ?? List.empty()) widget,
            ],
          ),
        )
      ],
    );
  }
}

class StoryTime extends StatelessWidget {
  const StoryTime({
    this.customizer,
    Key key,
  }) : super(key: key);

  final Customizer customizer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewerCubit, StoryViewerState>(
      buildWhen: (StoryViewerState state1, StoryViewerState state2) {
        return state1.storyIndex != state2.storyIndex;
      },
      builder: (context, state) {
        DateTime postedAt =
            context.watch<StoryViewerCubit>().currentStory.postedAt;
        if (postedAt == null) return const SizedBox.shrink();
        return Text(
          getDurationText(_storyDurationSincePosted(postedAt)),
          style: Theme.of(context)
              .textTheme
              .caption
              .merge(TextStyle(color: Colors.white60)),
        );
      },
    );
  }

  Duration _storyDurationSincePosted(DateTime postedAt) {
    return Duration(
      milliseconds: _currentTime().millisecondsSinceEpoch -
          postedAt.millisecondsSinceEpoch,
    );
  }

  DateTime _currentTime() {
    return DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch +
              customizer.timeGap.inMilliseconds ??
          0,
    );
  }

  String getDurationText(Duration duration) {
    if (duration.isNegative) return '';

    if (duration.inSeconds < 1) {
      return customizer.now;
    } else if (duration.inMinutes < 1) {
      return '${duration.inSeconds}${customizer.seconds}';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}${customizer.minutes}';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}${customizer.hours}';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}${customizer.days}';
    } else {
      return '${duration.inDays ~/ 7}${customizer.weeks}';
    }
  }
}

class Customizer {
  const Customizer({
    this.now = 'now',
    this.seconds = 's',
    this.minutes = 'm',
    this.hours = 'h',
    this.days = 'd',
    this.weeks = 'w',
    this.timeGap = Duration.zero,
  });
  final String now;
  final String seconds;
  final String minutes;
  final String hours;
  final String days;
  final String weeks;

  final Duration timeGap;
}
