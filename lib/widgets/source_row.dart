import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:story_viewer/viewer.dart';

class SourceRow extends StatelessWidget {
  final StoryViewer viewer;
  final String source;

  const SourceRow({Key key, this.viewer, this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool camera = source == "camera";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(12),
            0,
            ScreenUtil().setWidth(12),
            ScreenUtil().setWidth(16),
          ),
          child: Icon(
            camera ? Icons.camera_alt : Icons.image,
            color: Colors.white,
            size: ScreenUtil().setWidth(64),
          ),
        ),
        Text(
          //camera ? l["camera"] : l["gallery"],
          camera ? viewer.textRepo.cameraSource : viewer.textRepo.gallerySource,
          textAlign: TextAlign.left,
          maxLines: 1,
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(40),
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
