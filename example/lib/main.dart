// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/models/story_item.dart';
import 'package:story_viewer/models/user.dart';
import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Brightness b = Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Code Pick'),
      ),
      body: Stack(
        children: [
          Center(
              child: CupertinoButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    pushStoryView();
                  })),
        ],
      ),
    );
  }

  pushStoryView() {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => storyViewer()));
  }

  Widget storyViewer() {
    return StoryViewer(
      displayerUserID: "displayer",
      willPop: () {
        return false;
      },
      hasReply: false,
      stories: [
        StoryItemModel(
            displayDuration: Duration(seconds: 20),
            storyURL:
                "https://media.vanityfair.com/photos/5d1517768d443600098464f6/9:16/w_747,h_1328,c_limit/mark-zuckerberg-democracy.jpg"),
        StoryItemModel(
            storyURL:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQAnIurstDvh-haWAitgz09yWDcUTJ9ZMxVFg&usqp=CAU"),
      ],
      userModel: UserModel(
        username: "zuckerberg",
        profilePictureUrl: "https://static.toiimg.com/photo/46453492.cms",
      ),
      profilePicture: ClipOval(
        child: Image.network(
          "https://static.toiimg.com/photo/46453492.cms",
          width: 32,
          height: 32,
          fit: BoxFit.fitHeight,
        ),
      ),
      getAdditionalLayersBeforeMedia: ({
        StoryViewer viewer,
        StoryViewerController viewerController,
      }) {
        return [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueGrey,
                Colors.blueGrey,
              ],
            )),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
          )
        ];
      },
      getAdditionalLayersAfterMedia: ({
        StoryViewer viewer,
        StoryViewerController viewerController,
      }) {
        return [
          Text(
            "This is an additional layer",
            style: TextStyle(color: Colors.white, fontSize: 32),
          )
        ];
      },
      placeholderBackground: Colors.blueGrey,
      backgroundColor: Colors.grey,
      mediaAlignment: Alignment.center,
    );
  }
}
