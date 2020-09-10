# story_viewer

This package provides common story view experience for any Flutter app.

<img src="https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2Fezgif.com-resize.gif?alt=media&token=30a0bbef-fd4d-4907-9813-3a95e97e1651"/>

## Features

- Complate known gestures;
    - next story, previous story
    - hide UI layer on long press
- Custom texts, icons, colors, paddings etc.
- Easy to implement data model for story and story owner user.
- Slide out page on vertical swipe down
- Reply a story just like Instagram with text or emojis on vertical swipe up
- **Display ratio for dynamic view inside any Widget.
- Listener support with callbacks for story with StoryViewerController
    - played, paused, story index changed etc.
- Customized additional layers support for under or on the media layer.
- Blurred layer for possible inappropriate media

** Default and fully tested ratio is 9:16 with full screen.

## Usage

This is common usage of story_viewer

``` Dart
StoryViewer(
    padding: EdgeInsets.all(8),
    backgroundColor: Colors.white,
    ratio: StoryRatio.r16_9,
    stories: [
        StoryItemModel(url:"a_url"),
        StoryItemModel(url:"a_url"),
        StoryItemModel(url:"a_url"),
    ],
    userModel: UserModel(
        username: "story_viewer",
        profilePictureUrl: "profile_url",
    ),
);
```
Custom controller example with event listeners

``` Dart
StoryViewerController controller = StoryViewerController();
controller.addListener(
    onPlayed: () {
        print("'onPlayed' callback outside of story_viewer");
    },
    onPaused: () {
        print("'onPaused' callback outside of story_viewer");
    },
);
return StoryViewer(
    viewerController: controller,
    .
    .
```

Check out ```example/lib/detailed_example.dart``` for more!

## Dependencies

| Package Name| Type | Description | 
| ----------- | ----------- | ----------- |
| extended_image| Core | Caching images, slide out page |
| flutter_screenutil | Core | Device-Size spesific visual behaviours|
| flutter_spinkit | Visual | Loading animation|