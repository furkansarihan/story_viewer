class StoryItemModel {
  final String storyID;
  final String ownerID;
  final String storyURL;
  final String storySource;
  final DateTime storyTime;
  final Duration displayDuration;
  const StoryItemModel({
    this.storyID,
    this.ownerID,
    this.storyURL,
    this.storySource,
    this.storyTime,
    this.displayDuration,
  });
  String get id => storyID ?? "";
  String get ownerId => ownerID ?? "";
  String get url => storyURL ?? "";
  String get source => storySource ?? "gallery";
  Duration get duration => displayDuration ?? Duration(seconds: 6);
  DateTime get timestamp => storyTime ?? DateTime.now();
}
