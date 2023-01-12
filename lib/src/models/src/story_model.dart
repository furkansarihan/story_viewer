import 'package:flutter/material.dart';

class StoryModel {
  const StoryModel({
    required this.howOld,
    this.duration = defaultDuration,
    required this.storyType,
    this.imageProvider,
  });

  static const Duration defaultDuration = Duration(seconds: 6);

  final Duration howOld;
  final Duration duration;
  final StoryType storyType;
  final ImageProvider? imageProvider;
  // TODO: video provider
}

enum StoryType { image, video }
