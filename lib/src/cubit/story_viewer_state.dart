part of 'story_viewer_cubit.dart';

class StoryViewerState extends Equatable {
  const StoryViewerState({
    this.storyIndex = 0,
    this.storyPlaying = false,
    this.uiShowing = true,
    this.previewShadowShowing = false,
    this.replying = false,
  });

  final int storyIndex;
  final bool storyPlaying;
  final bool uiShowing;
  final bool previewShadowShowing;
  final bool replying;

  @override
  List<Object> get props => [
        storyIndex,
        storyPlaying,
        uiShowing,
        previewShadowShowing,
        replying,
      ];

  StoryViewerState copyWith({
    int? storyIndex,
    bool? storyPlaying,
    bool? uiShowing,
    bool? previewShadowShowing,
    bool? nextShadowShowing,
    bool? replying,
  }) {
    return StoryViewerState(
      storyIndex: storyIndex ?? this.storyIndex,
      storyPlaying: storyPlaying ?? this.storyPlaying,
      uiShowing: uiShowing ?? this.uiShowing,
      previewShadowShowing: previewShadowShowing ?? this.previewShadowShowing,
      replying: replying ?? this.replying,
    );
  }
}
