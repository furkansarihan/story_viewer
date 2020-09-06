# story_viewer

This package provides common story view experience for any Flutter app.

<img src="https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2Fstory_viewer_01.png?alt=media&token=01e2af66-aabc-4025-bdce-36de7f6e2d3b" width="500" />

## Usage

This is basic usage of story_viewer.

``` Dart
StoryViewer(
    padding: EdgeInsets.all(8),
    backgroundColor: Colors.white,
    ratio: StoryRatio.r16_9,
    stories: [
        StoryItemModel(url:"an_url"),
        StoryItemModel(url:"an_url"),
        StoryItemModel(url:"an_url"),
    ],
    userModel: UserModel(
        username: "story_viewer",
        profilePictureUrl: "profile_url",
    ),
);
```
Check out ```example/lib/detailed_example.dart``` for more!

## Dependencies

| Package Name| Type | Description | 
| ----------- | ----------- | ----------- |
| extended_image| Core | Caching images, slide out page |
| flutter_screenutil | Core | Device-Size spesific visual behaviours|
| flutter_spinkit | Visual | Loading animation|