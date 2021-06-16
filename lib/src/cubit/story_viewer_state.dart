part of 'story_viewer_cubit.dart';

class StoryViewerState extends Equatable {
  const StoryViewerState({
    this.storyIndex = 0,
    this.storyPlaying = false,
    this.uiShowing = true,
    this.previewShadowShowing = false,
  });

  final int storyIndex;
  final bool storyPlaying;
  final bool uiShowing;
  final bool previewShadowShowing;

  @override
  List<Object> get props => [
        storyIndex,
        storyPlaying,
        uiShowing,
        previewShadowShowing,
      ];

  StoryViewerState copyWith({
    int storyIndex,
    bool storyPlaying,
    bool uiShowing,
    bool previewShadowShowing,
    bool nextShadowShowing,
  }) {
    return StoryViewerState(
      storyIndex: storyIndex ?? this.storyIndex,
      storyPlaying: storyPlaying ?? this.storyPlaying,
      uiShowing: uiShowing ?? this.uiShowing,
      previewShadowShowing: previewShadowShowing ?? this.previewShadowShowing,
    );
  }
}
