import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class FastEmojis extends StatelessWidget {
  final Function(String emoji) onEmojiSelected;

  const FastEmojis({Key key, this.onEmojiSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double size = ScreenUtil().setWidth(384);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              emojIcon("😂", size, EdgeInsets.all(12)),
              emojIcon("😯", size, EdgeInsets.all(12)),
              emojIcon("😍", size, EdgeInsets.all(12)),
              emojIcon("😢", size, EdgeInsets.all(12))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              emojIcon("👏", size, EdgeInsets.all(12)),
              emojIcon("🔥", size, EdgeInsets.all(12)),
              emojIcon("🎉", size, EdgeInsets.all(12)),
              emojIcon("💯", size, EdgeInsets.all(12))
            ],
          )
        ],
      ),
    );
  }

  Widget emojIcon(String emoji, double size, EdgeInsets padd) {
    return GestureDetector(
        onTap: () {
          onEmojiSelected?.call(emoji);
        },
        child: Padding(
            padding: padd,
            child: Text(
              emoji,
              style: TextStyle(fontSize: ScreenUtil().setSp(size)),
            )));
  }
}
