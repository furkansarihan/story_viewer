import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:story_viewer/src/cubit/story_viewer_cubit.dart';

class StoryReplyRow extends StatelessWidget {
  const StoryReplyRow({
    Key key,
    this.padding = const EdgeInsets.only(top: 16, bottom: 8),
    this.textFieldPadding = EdgeInsets.zero,
    this.textFieldMargin = EdgeInsets.zero,
    this.textFieldDecoration,
    this.textFieldPlaceholder = '',
    this.textController,
    this.onFocusChange,
    this.textNode,
    this.leadingIcons,
    this.trailingIcons,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry textFieldPadding;
  final EdgeInsetsGeometry textFieldMargin;
  final BoxDecoration textFieldDecoration;
  final String textFieldPlaceholder;
  final TextEditingController textController;
  final Function(bool hasFocus) onFocusChange;
  final FocusNode textNode;
  final List<Widget> leadingIcons;
  final List<Widget> trailingIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black38],
        ),
      ),
      child: Row(
        children: <Widget>[
          Row(
            children: [
              for (var icon in leadingIcons ?? List.empty()) icon,
            ],
          ),
          Expanded(
            child: Container(
              padding: textFieldPadding,
              margin: textFieldMargin,
              decoration: textFieldDecoration,
              child: Focus(
                onFocusChange: (focus) {
                  if (focus) {
                    context.read<StoryViewerCubit>().pause(replyStart: true);
                  } else {
                    // TODO: impl
                    //context.read<StoryViewerCubit>().play();
                  }
                  onFocusChange?.call(focus);
                },
                child: textField(context),
              ),
            ),
          ),
          Row(
            children: [
              for (var icon in trailingIcons ?? List.empty()) icon,
            ],
          ),
        ],
      ),
    );
  }

  Widget textField(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoTextField(
        focusNode: textNode,
        controller: textController,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        placeholderStyle: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white54,
        ),
        decoration: const BoxDecoration(),
        placeholder: textFieldPlaceholder,
        maxLines: 1,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
        onSubmitted: (String message) {},
      );
    } else {
      return TextField(
        focusNode: textNode,
        controller: textController,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 6.5, horizontal: 12),
          border: InputBorder.none,
          helperStyle: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white60,
          ),
          hintStyle: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white54,
          ),
          hintText: textFieldPlaceholder,
        ),
        maxLines: 1,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
        onSubmitted: (String message) {},
      );
    }
  }
}
