// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/story_viewer.dart';

import 'main.dart';

class DetailedHome extends StatefulWidget {
  @override
  _DetailedHomeState createState() => _DetailedHomeState();
}

class _DetailedHomeState extends State<DetailedHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Hero(
                  tag: 'basic_hero',
                  child: CupertinoButton(
                      child: Column(
                        children: [
                          Text('Basic'),
                          Icon(Icons.image),
                        ],
                      ),
                      onPressed: () {
                        pushStoryView(basicStoryViewer(heroTag: 'basic_hero'));
                      }),
                ),
                CupertinoButton(
                    child: Column(
                      children: [
                        Text('Custom'),
                        Icon(Icons.camera),
                      ],
                    ),
                    onPressed: () {
                      pushStoryView(customStoryViewer());
                    }),
                CupertinoButton(
                    child: Column(
                      children: [
                        Text('Blurred'),
                        Icon(Icons.blur_circular),
                      ],
                    ),
                    onPressed: () {
                      pushStoryView(basicStoryViewer(trusted: false));
                    }),
              ],
            ),
            StoryViewer(
              key: ValueKey('2'),
              loop: false,
              progressBorderRadius: BorderRadius.all(Radius.circular(12)),
              backgroundColor: Colors.blueGrey,
              ratio: StoryRatio.r4_3,
              stories: [
                StoryItemModel(
                  displayDuration: Duration(seconds: 10),
                  imageProvider: NetworkImage(images2[0]),
                ),
                StoryItemModel(
                  displayDuration: Duration(seconds: 10),
                  imageProvider: NetworkImage(images2[1]),
                ),
              ],
              userModel: UserModel(
                username: 'monotony',
                profilePicture: NetworkImage(images2[2]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pushStoryView(Widget storyViewer) {
    Navigator.of(context).push(PageRouteBuilder(
      fullscreenDialog: true,
      transitionDuration: Duration(milliseconds: 300),
      opaque: false, // set to false
      pageBuilder: (_, __, ___) => storyViewer,
    ));
  }

  Widget basicStoryViewer({
    String heroTag = '',
    bool trusted = true,
    bool hasReply = true,
  }) {
    return StoryViewer(
      displayerUserID: 'displayer',
      heroTag: heroTag,
      hasReply: hasReply,
      trusted: trusted,
      mediaAlignment: Alignment.topCenter,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      progressRowPadding: EdgeInsets.all(8),
      stories: [
        StoryItemModel(
          imageProvider: NetworkImage(
              'https://i.pinimg.com/originals/7e/43/61/7e436110ed2827aacf105ff7355eb2aa.jpg'),
        ),
      ],
      userModel: UserModel(
        username: 'mark',
        profilePicture: NetworkImage(
          'https://static.toiimg.com/photo/46453492.cms',
        ),
      ),
    );
  }

  Widget customStoryViewer() {
    StoryViewerController controller = StoryViewerController();
    controller.addListener(
      onPlayed: () {
        print('onPlayed: callback outside of story_viewer');
      },
      onPaused: () {
        print('onPaused: callback outside of story_viewer');
      },
      onIndexChanged: () {
        print('onIndexChanged: callback outside of story_viewer');
      },
      onComplated: () {
        print('onComplated: callback outside of story_viewer');
      },
      onUIHide: () {
        print('onUIHide: callback outside of story_viewer');
      },
      onUIShow: () {
        print('onUIShow: callback outside of story_viewer');
      },
    );
    return StoryViewer(
      viewerController: controller,
      hasReply: false,
      customValues: Customizer(
        sendIcon: CupertinoIcons.right_chevron,
        closeIcon: CupertinoIcons.down_arrow,
      ),
      stories: [
        StoryItemModel(
          displayDuration: Duration(seconds: 20),
          storyTime: DateTime(2020, 10),
          imageProvider: NetworkImage(
              'https://media.vanityfair.com/photos/5d1517768d443600098464f6/9:16/w_747,h_1328,c_limit/mark-zuckerberg-democracy.jpg'),
        ),
        StoryItemModel(
          imageProvider: NetworkImage(
              'https://media.vanityfair.com/photos/5d1517768d443600098464f6/9:16/w_747,h_1328,c_limit/mark-zuckerberg-democracy.jpg'),
        ),
      ],
      userModel: UserModel(
        username: 'zuckerberg',
        profilePicture: NetworkImage(
          'https://static.toiimg.com/photo/46453492.cms',
        ),
      ),
      profilePicture: ClipOval(
        child: Image.network(
          'https://static.toiimg.com/photo/46453492.cms',
          width: 32,
          height: 32,
          fit: BoxFit.fitHeight,
        ),
      ),
      getAdditionalLayersBeforeMedia: ({
        StoryViewer? viewer,
        StoryViewerController? viewerController,
      }) {
        return [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
          )
        ];
      },
      getAdditionalLayersAfterMedia: ({
        StoryViewer? viewer,
        StoryViewerController? viewerController,
      }) {
        return [
          IntrinsicHeight(
              child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.purple,
              ],
            )),
            child: Text(
              'This is an additional layer for ${viewerController?.currentIndex}',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          )),
        ];
      },
      placeholderBackground: Colors.blueGrey,
      backgroundColor: Colors.grey,
      mediaAlignment: Alignment.center,
    );
  }
}
