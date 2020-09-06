# story_viewer

This package provides common story view experience for any Flutter app.

## Usage

This is basic usage of story_viewer.

[logo]: https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FSimulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20-%202020-09-06%20at%2014.01.12%20(wecompress.com).png?alt=media&token=2f0f836c-c735-446e-a9ed-fccb1b4c2e1c "Screenshot"

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