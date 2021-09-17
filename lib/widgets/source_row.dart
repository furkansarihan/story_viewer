import 'package:flutter/material.dart';

import 'package:story_viewer/viewer.dart';

class SourceRow extends StatelessWidget {
  final StoryViewer? viewer;
  final String? source;

  const SourceRow({Key? key, this.viewer, this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool camera = source == 'camera';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
          child: Icon(
            camera
                ? viewer!.customizer.cameraSourceIcon
                : viewer!.customizer.gallerySourceIcon,
            color: Colors.white,
            size: 24,
          ),
        ),
        Text(
          camera
              ? viewer!.customizer.cameraSource
              : viewer!.customizer.gallerySource,
          textAlign: TextAlign.left,
          maxLines: 1,
          style: Theme.of(context).textTheme.caption!.merge(TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              )),
        ),
      ],
    );
  }
}
