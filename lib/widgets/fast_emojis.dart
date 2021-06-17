import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FastEmojis extends StatelessWidget {
  final void Function(String? emoji)? onEmojiSelected;

  const FastEmojis({
    Key? key,
    this.onEmojiSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: 16),
              Expanded(
                child: FastEmoji(emoji: '😂', onSelected: onEmojiSelected),
              ),
              Expanded(
                child: FastEmoji(emoji: '😯', onSelected: onEmojiSelected),
              ),
              Expanded(
                child: FastEmoji(emoji: '😍', onSelected: onEmojiSelected),
              ),
              Expanded(
                child: FastEmoji(emoji: '😢', onSelected: onEmojiSelected),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: <Widget>[
              const SizedBox(width: 16),
              Expanded(
                child: FastEmoji(emoji: '👏', onSelected: onEmojiSelected),
              ),
              Expanded(
                child: FastEmoji(emoji: '🔥', onSelected: onEmojiSelected),
              ),
              Expanded(
                child: FastEmoji(emoji: '🎉', onSelected: onEmojiSelected),
              ),
              Expanded(
                child: FastEmoji(emoji: '💯', onSelected: onEmojiSelected),
              ),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}

class FastEmoji extends StatelessWidget {
  final String? emoji;
  final void Function(String? emoji)? onSelected;

  const FastEmoji({
    Key? key,
    this.emoji,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        onSelected!(emoji);
      },
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          emoji!,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 56,
          ),
        ),
      ),
    );
  }
}
