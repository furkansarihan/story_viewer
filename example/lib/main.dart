// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:example/detailed_example.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/models/story_item.dart';
import 'package:story_viewer/models/user.dart';
import 'package:story_viewer/viewer.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var images = [
      "https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FScreen%20Shot%202020-09-06%20at%2013.24.29.png?alt=media&token=30f1e802-e3f2-4cdb-b95c-b1f886bfeba2",
      "https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FScreen%20Shot%202020-09-06%20at%2013.24.48.png?alt=media&token=69743845-dfcb-4245-83bf-3f543715e2bd",
      "https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FScreen%20Shot%202020-09-06%20at%2013.27.04.png?alt=media&token=750c65a5-216b-4e6b-840d-8efe10042ed6"
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('story_viewer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StoryViewer(
            padding: EdgeInsets.all(8),
            backgroundColor: Colors.white,
            ratio: StoryRatio.r16_9,
            stories: [
              StoryItemModel(imageProvider: NetworkImage(images[0])),
              StoryItemModel(imageProvider: NetworkImage(images[1])),
              StoryItemModel(imageProvider: NetworkImage(images[2])),
            ],
            userModel: UserModel(
              username: "flutter",
              profilePictureUrl:
                  "https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png",
            ),
          ),
          MaterialButton(
              child: Text("Explore More!"),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => DetailedHome()));
              }),
        ],
      ),
    );
  }
}
