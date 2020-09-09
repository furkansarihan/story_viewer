import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'models/story_item.dart';

class StoryViewerController {
  final List<StoryItemModel> stories;
  final String heroTag;
  final String heroKey;
  final String ownerUserID;
  bool trusted;
  bool _uiHiding = false;
  bool _prewShadowShowing = false;
  bool get uiHiding => _uiHiding;
  bool get isPlaying => _playing;
  bool get replying => _replying;
  List<Function> _onPlays = List<Function>();
  List<Function> _onPauseds = List<Function>();
  List<Function> _onIndexChangeds = List<Function>();
  List<Function> _onComplateds = List<Function>();
  List<Function> _onPrewShadowShows = List<Function>();
  List<Function> _onPrewShadowHides = List<Function>();
  List<Function> _onUIShows = List<Function>();
  List<Function> _onUIHides = List<Function>();

  int currentIndex;
  StoryItemModel get currentStory =>
      stories.length > currentIndex && stories.isNotEmpty
          ? stories.elementAt(currentIndex)
          : StoryItemModel();

  bool get isLong => (ScreenUtil.screenHeight / ScreenUtil.screenWidth) > 1.78;
  bool get owner => currentStory.ownerID == ownerUserID;
  String get currentHeroTag =>
      heroTag != null ? heroTag : "${currentStory.id}$heroKey";

  StoryViewerController({
    this.ownerUserID,
    this.heroTag,
    this.heroKey,
    this.stories,
    this.currentIndex = 0,
    this.trusted = true,
  });

  AnimationController animationController;
  Timer uiHider;
  Timer prevShadower;
  Timer nexter;

  bool _playing = false;
  bool _goingNext = true;
  bool _replying = false;
  bool _slideInfo = false;

  void play() {
    if (_playing) {
      return null;
    }
    if (_replying) {
      return null;
    }
    if (!trusted) {
      return null;
    }
    if (_slideInfo) {
      return null;
    }
    if (stories.isEmpty) {
      return null;
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
      play();
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
      return null;
    }
    _playing = false;
    _callFunctions(_onPauseds);
  }

  void replyPause() {
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

  void handPause({bool prewShadowShow}) {
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
    currentIndex = currentIndex + 1;
    if (currentIndex >= stories.length) {
      currentIndex = stories.length - 1;
      animationController.animateTo(animationController.upperBound);
      complated();
      return null;
    }
    animationController.reset();
    animationController.duration = currentStory.duration;
    _callFunctions(_onIndexChangeds);
  }

  void previous() {
    cancelHider();
    if (animationController.value < 0.25) {
      currentIndex = currentIndex - 1;
    }
    if (currentIndex <= 0) {
      currentIndex = 0;
    }
    animationController.reset();
    animationController.duration = currentStory.duration;
    _callFunctions(_onIndexChangeds);
  }

  void complated() {
    _callFunctions(_onComplateds);
  }

  void changeIndex({int newIndex}) {
    currentIndex = newIndex;
    if (currentIndex <= 0) {
      currentIndex = 0;
    } else if (currentIndex >= stories.length) {
      currentIndex = stories.length - 1;
    }
    animationController.reset();
    animationController.duration = currentStory.duration;
    _callFunctions(_onIndexChangeds);
  }

  void addCallBacks({
    Function onPlayed,
    Function onPaused,
    Function onIndexChanged,
    Function onComplated,
    Function onPrewShadowShow,
    Function onPrewShadowHide,
    Function onUIShow,
    Function onUIHide,
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

  void _callFunctions(List<Function> _l) => _l.forEach((_f) => _f?.call());
}
