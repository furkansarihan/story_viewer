import 'package:flutter/widgets.dart';

class StoryItemModel {
  final String id;
  final String ownerID;
  final ImageProvider? imageProvider;
  final String source;
  final DateTime? storyTime;
  final Duration? displayDuration;
  const StoryItemModel({
    this.id = '',
    this.ownerID = '',
    required this.imageProvider,
    this.source = 'gallery',
    this.storyTime,
    this.displayDuration,
  });
  Duration get duration => displayDuration ?? Duration(seconds: 6);
  DateTime get timestamp => storyTime ?? DateTime.now();
}
