class StoryItemModel {
  final String id;
  final String ownerID;
  final String url;
  final String source;
  final DateTime storyTime;
  final Duration displayDuration;
  const StoryItemModel({
    this.id = "",
    this.ownerID = "",
    this.url = "",
    this.source = "gallery",
    this.storyTime,
    this.displayDuration,
  });
  Duration get duration => displayDuration ?? Duration(seconds: 6);
  DateTime get timestamp => storyTime ?? DateTime.now();
}
