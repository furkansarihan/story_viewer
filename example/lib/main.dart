// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/story_viewer.dart';

var images1 = [
  'https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FScreen%20Shot%202020-09-06%20at%2013.24.29.png?alt=media&token=30f1e802-e3f2-4cdb-b95c-b1f886bfeba2',
  'https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FScreen%20Shot%202020-09-06%20at%2013.24.48.png?alt=media&token=69743845-dfcb-4245-83bf-3f543715e2bd',
  'https://firebasestorage.googleapis.com/v0/b/app-monotony.appspot.com/o/assets%2FScreen%20Shot%202020-09-06%20at%2013.27.04.png?alt=media&token=750c65a5-216b-4e6b-840d-8efe10042ed6'
];
var images2 = [
  'https://i.pinimg.com/originals/32/0b/f8/320bf808e83e47487fcfabd767d0a300.jpg',
  'https://g2.img-dpreview.com/C7E98764B33A491FB5130BBDBB17E78C.jpg',
  'https://lh3.googleusercontent.com/proxy/eufQjvBs0llWZYZYX-M2WQoQolEDXKvr7zyVb362OtK1xaF7Dz25ajv880SPFjSi4zzC0r5eA6o7yX_Ow9CWWQzhVcN-niICjcOA0yzeEY9Kf5tGtm5c4k3v_b8IEmnyVts',
  'https://g1.img-dpreview.com/3ACBE6D011274856888F900E563D7A85.jpg',
];

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('story_viewer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MaterialButton(
            child: const Text('Show Story'),
            onPressed: () {
              pushStoryView(storyViewer(true));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: storyViewer(false),
            ),
          ),
        ],
      ),
    );
  }

  storyViewer(bool fullScreen) => StoryViewer(
        //padding: EdgeInsets.all(8),
        //backgroundColor: Colors.white,
        //ratio: StoryRatio.r16_9,
        contentBorderRadius: 8,
        fullScreen: fullScreen,
        progressBorderRadius: BorderRadius.circular(12),
        stories: [
          StoryModel(
            imageProvider: NetworkImage(images2[0]),
            howOld: const Duration(days: 1),
            storyType: StoryType.image,
          ),
          StoryModel(
            imageProvider: NetworkImage(images2[1]),
            howOld: const Duration(days: 1),
            storyType: StoryType.image,
          ),
          StoryModel(
            imageProvider: NetworkImage(images2[2]),
            howOld: const Duration(days: 1),
            storyType: StoryType.image,
          ),
          StoryModel(
            imageProvider: NetworkImage(images2[2]),
            howOld: const Duration(days: 1),
            storyType: StoryType.image,
          ),
        ],
        profileRow: ProfileRow(
          userModel: const UserModel(
            username: 'story_viewer',
            profilePicture: NetworkImage(
              'https://secure.gravatar.com/avatar/ba6b323ae0e4f1bafb2dcf72d63d559e?s=256&d=mm&r=pg',
            ),
          ),
          trailingWidgets: [
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                debugPrint('IconButton');
              },
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                debugPrint('IconButton');
              },
            ),
          ],
        ),
        replyRow: StoryReplyRow(
          textFieldPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          textFieldDecoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(24),
          ),
          textFieldPlaceholder: 'Reply to story_viewer...',
          leadingIcons: const [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ],
          trailingIcons: const [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(
                Icons.ac_unit_outlined,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ],
        ),
      );

  pushStoryView(Widget storyViewer) {
    Navigator.of(context).push(PageRouteBuilder(
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 300),
      opaque: false, // set to false
      pageBuilder: (_, __, ___) => storyViewer,
    ));
  }
}
