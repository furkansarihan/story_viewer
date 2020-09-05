import 'package:flutter/widgets.dart';
import 'package:story_viewer/story_viewer.dart';

class StoryAdditionalLayer extends StatefulWidget {
  final StoryViewerController viewerController;
  final StoryViewer viewer;
  final List<Widget> Function({
    StoryViewer viewer,
    StoryViewerController viewerController,
  }) additions;

  const StoryAdditionalLayer({
    Key key,
    this.viewerController,
    this.viewer,
    this.additions,
  }) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<StoryAdditionalLayer> {
  StoryViewerController get controller => widget.viewerController;

  @override
  void initState() {
    super.initState();
    controller.addCallBacks(
      onIndexChanged: onIndexChanged,
    );
  }

  void onIndexChanged() {
    refreshState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> layers = widget.additions?.call(
      viewerController: widget.viewerController,
      viewer: widget.viewer,
    );
    if (layers.isEmpty) {
      return Container();
    }
    return Stack(
      children: layers,
    );
  }

  void refreshState() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
