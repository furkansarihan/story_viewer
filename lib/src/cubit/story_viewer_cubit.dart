import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:story_viewer/src/models/models.dart';
import 'package:story_viewer/story_viewer.dart';

part 'story_viewer_state.dart';

class StoryViewerCubit extends Cubit<StoryViewerState> {
  StoryViewerCubit(
    this._context,
    this._storyViewer,
  ) : super(const StoryViewerState());

  final BuildContext _context;
  final StoryViewer _storyViewer;

  final List<int> loadedStories = [];

  Timer uiHideTimer;
  Timer prevShadowTimer;

  // TODO: initialize?

  int get storiesLength => _storyViewer.stories.length;
  // TODO: if empty list?
  StoryModel get currentStory => _storyViewer.stories.elementAt(
        state.storyIndex,
      );

  bool get currentStoryLoaded => isLoaded(currentStory.imageProvider.hashCode);

  @override
  Future<void> close() async {
    return super.close();
  }

  void unload(int hashCode) {
    loadedStories.remove(hashCode);
  }

  void load(int hashCode) {
    loadedStories.add(hashCode);
  }

  bool isLoaded(int hashCode) {
    return loadedStories.contains(hashCode);
  }

  void play() {
    cancelTimers();
    if (!currentStoryLoaded) return;
    emit(state.copyWith(
      storyPlaying: true,
      uiShowing: true,
      previewShadowShowing: false,
      nextShadowShowing: false,
    ));
  }

  void pause({
    bool hideUi = false,
    bool showPrevShadow = false,
  }) {
    if (hideUi) {
      uiHideTimer = Timer(Duration(milliseconds: 750), () {
        emit(state.copyWith(uiShowing: false));
        uiHideTimer.cancel();
      });
    }
    if (showPrevShadow) {
      prevShadowTimer = Timer(Duration(milliseconds: 200), () {
        emit(state.copyWith(previewShadowShowing: true));
        prevShadowTimer.cancel();
      });
    }
    emit(state.copyWith(storyPlaying: false));
  }

  void next() {
    if (state.storyIndex + 1 >= storiesLength) return end();

    emit(state.copyWith(
      storyIndex: state.storyIndex + 1,
      storyPlaying: false,
    ));
    cancelTimers();
  }

  void previous() {
    int newIndex = state.storyIndex - 1;
    if (newIndex.isNegative) newIndex = 0;
    unload(currentStory.imageProvider.hashCode);
    emit(state.copyWith(
      storyIndex: newIndex,
      storyPlaying: state.storyIndex == 0,
    ));
    unload(currentStory.imageProvider.hashCode);
    cancelTimers();
  }

  void cancelTimers() {
    uiHideTimer?.cancel();
    prevShadowTimer?.cancel();
  }

  void end() {
    // handle pop story page
    Navigator.of(_context).pop();
  }
}
