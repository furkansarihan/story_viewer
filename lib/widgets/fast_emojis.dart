import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FastEmojis extends StatelessWidget {
  final Function(String emoji) onEmojiSelected;

  const FastEmojis({Key key, this.onEmojiSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FastEmoji(emoji: "😂", onSelected: onEmojiSelected),
              FastEmoji(emoji: "😯", onSelected: onEmojiSelected),
              FastEmoji(emoji: "😍", onSelected: onEmojiSelected),
              FastEmoji(emoji: "😢", onSelected: onEmojiSelected)
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FastEmoji(emoji: "👏", onSelected: onEmojiSelected),
              FastEmoji(emoji: "🔥", onSelected: onEmojiSelected),
              FastEmoji(emoji: "🎉", onSelected: onEmojiSelected),
              FastEmoji(emoji: "💯", onSelected: onEmojiSelected)
            ],
          )
        ],
      ),
    );
  }
}

class FastEmoji extends StatelessWidget {
  final String emoji;
  final Function(String emoji) onSelected;
  const FastEmoji({
    Key key,
    this.emoji,
    this.onSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        onSelected?.call(emoji);
      },
      child: Text(
        emoji,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 32,
        ),
      ),
    );
  }
}
