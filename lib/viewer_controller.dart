import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:story_viewer/viewer.dart';
import 'models/story_item.dart';

class StoryViewerController {
  late StoryViewer viewer;
  bool? trusted;
  bool _uiHiding = false;
  bool _prewShadowShowing = false;
  bool get uiHiding => _uiHiding;
  bool get isPlaying => _playing;
  bool get replying => _replying;
  List<Function> _onPlays = <Function>[];
  List<Function> _onPauseds = <Function>[];
  List<Function> _onIndexChangeds = <Function>[];
  List<Function> _onComplateds = <Function>[];
  List<Function> _onPrewShadowShows = <Function>[];
  List<Function> _onPrewShadowHides = <Function>[];
  List<Function> _onUIShows = <Function>[];
  List<Function> _onUIHides = <Function>[];

  Map<ImageProvider?, bool> _loadedStories = Map<ImageProvider?, bool>();
  List<StoryItemModel> get stories => viewer.stories ?? [];
  String get ownerUserID => viewer.displayerUserID ?? '';
  String get heroTag => viewer.heroTag ?? '';

  int? currentIndex;
  StoryItemModel get currentStory =>
      stories.length > currentIndex! && stories.isNotEmpty
          ? stories.elementAt(currentIndex!)
          : StoryItemModel();

  bool get owner => currentStory.ownerID == ownerUserID;
  String get currentHeroTag =>
      viewer.heroTag ?? currentStory.hashCode.toString();

  StoryViewerController({
    this.currentIndex = 0,
  });

  late AnimationController animationController;
  Timer? uiHider;
  Timer? prevShadower;
  Timer? nexter;

  bool _playing = false;
  bool _goingNext = true;
  bool _replying = false;
  bool _slideInfo = false;

  void play() {
    if (_playing) {
      return;
    }
    if (_replying) {
      return;
    }
    if (!trusted!) {
      return;
    }
    if (_slideInfo) {
      return;
    }
    if (stories.isEmpty) {
      return;
    }
    if (!_loadedStories.containsKey(currentStory.imageProvider)) {
      return;
    }
    if (_uiHiding) {
      _uiHiding = false;
      _callFunctions(_onUIShows);
    }
    if (_prewShadowShowing) {
      _prewShadowShowing = false;
      _callFunctions(_onPrewShadowHides);
    }
    uiHider?.cancel();
    prevShadower?.cancel();
    _playing = true;
    _callFunctions(_onPlays);
  }

  void handPlay({bool prewStory = false}) {
    if (prewStory) {
      previous();
    } else if (_goingNext) {
      next();
    } else {
      play();
    }
  }

  void replyPlay() {
    _replying = false;
    play();
  }

  void infoPlay() {
    _slideInfo = false;
    play();
  }

  void pause() {
    if (!_playing) {
      return;
    }
    _playing = false;
    _callFunctions(_onPauseds);
  }

  void replyPause() {
    if (!viewer.hasReply) {
      return;
    }
    _replying = true;
    _playing = false;
    _callFunctions(_onPauseds);
  }

  void infoPause() {
    _slideInfo = true;
    _playing = false;
    _callFunctions(_onPauseds);
  }

  void elementPause() {
    cancelHider();
    _playing = false;
    _callFunctions(_onPauseds);
  }

  void handPause({bool prewShadowShow = false}) {
    if (!_playing) {
      return;
    }
    if (prewShadowShow) {
      prevShadower = Timer(Duration(milliseconds: 75), () {
        _prewShadowShowing = true;
        _callFunctions(_onPrewShadowShows);
        prevShadower?.cancel();
      });
    }
    _goingNext = true;
    nexter = Timer(Duration(milliseconds: 400), () {
      _goingNext = false;
      nexter?.cancel();
    });
    uiHider = Timer(Duration(milliseconds: 750), () {
      _uiHiding = true;
      _callFunctions(_onUIHides);
      uiHider?.cancel();
    });
    _playing = false;
    _callFunctions(_onPauseds);
  }

  void cancelHider() {
    uiHider?.cancel();
  }

  void next() {
    cancelHider();
    currentIndex = currentIndex! + 1;
    if (currentIndex! >= stories.length) {
      if (viewer.loop) {
        currentIndex = 0;
        _callFunctions(_onIndexChangeds);
        play();
      } else {
        currentIndex = stories.length - 1;
        animationController.removeStatusListener(statusListener);
        animationController.animateTo(
          animationController.upperBound,
          duration: Duration(
            milliseconds: 1,
          ),
        );
        complated();
        return;
      }
    }
    animationController.reset();
    animationController.duration = currentStory.duration;
    _callFunctions(_onIndexChangeds);
  }

  void previous() {
    cancelHider();
    if (animationController.value < 0.25) {
      currentIndex = currentIndex! - 1;
      _callFunctions(_onIndexChangeds);
    }
    if (currentIndex! <= 0) {
      currentIndex = 0;
    }
    animationController.reset();
    animationController.duration = currentStory.duration;
    play();
  }

  void complated() {
    _callFunctions(_onComplateds);
  }

  void changeIndex({int? newIndex}) {
    currentIndex = newIndex;
    if (currentIndex! <= 0) {
      currentIndex = 0;
    } else if (currentIndex! >= stories.length) {
      currentIndex = stories.length - 1;
    }
    animationController.reset();
    animationController.duration = currentStory.duration;
    _callFunctions(_onIndexChangeds);
  }

  void load(ImageProvider? provider) {
    _loadedStories[provider] = true;
  }

  bool? isLoaded(ImageProvider provider) {
    return _loadedStories.containsKey(provider)
        ? _loadedStories[provider]
        : false;
  }

  void statusListener(status) {
    if (status == AnimationStatus.forward) {
    } else if (status == AnimationStatus.completed) {
      next();
    } else if (status == AnimationStatus.dismissed) {
      pause();
    }
  }

  void addListener({
    Function? onPlayed,
    Function? onPaused,
    Function? onIndexChanged,
    Function? onComplated,
    Function? onPrewShadowShow,
    Function? onPrewShadowHide,
    Function? onUIShow,
    Function? onUIHide,
  }) {
    if (onPlayed != null) _onPlays.add(onPlayed);
    if (onPaused != null) _onPauseds.add(onPaused);
    if (onIndexChanged != null) _onIndexChangeds.add(onIndexChanged);
    if (onComplated != null) _onComplateds.add(onComplated);
    if (onPrewShadowShow != null) _onPrewShadowShows.add(onPrewShadowShow);
    if (onPrewShadowHide != null) _onPrewShadowHides.add(onPrewShadowHide);
    if (onUIShow != null) _onUIShows.add(onUIShow);
    if (onUIHide != null) _onUIHides.add(onUIHide);
  }

  void _callFunctions(List<Function> _l) => _l.forEach((_f) => _f.call());
}
