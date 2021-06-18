import 'package:flutter/material.dart';

class StoryModel {
  const StoryModel({
    this.id,
    this.ownerID,
    this.postedAt,
    this.duration = defaultDuration,
    this.storyType,
    this.imageProvider,
  });

  static const Duration defaultDuration = Duration(seconds: 6);

  final String id;
  final String ownerID;
  final DateTime postedAt;
  final Duration duration;
  final StoryType storyType;
  final ImageProvider imageProvider;
  // TODO: video provider
}

enum StoryType { image, video }
