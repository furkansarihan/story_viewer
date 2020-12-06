import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaceholderImage extends StatelessWidget {
  final IconData iconData;
  final Widget child;
  final double width;
  final double height;
  final bool loading;
  final BorderRadius borderRaius;
  final Color backgroundColor;
  final List<Color> backgroundColors;

  const PlaceholderImage({
    this.iconData,
    this.child,
    this.width,
    this.height,
    this.loading = false,
    this.borderRaius,
    this.backgroundColor,
    this.backgroundColors,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRaius,
        color: backgroundColor,
        gradient: backgroundColor == null
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: backgroundColors != null
                    ? backgroundColors.length == 2
                        ? backgroundColors
                        : [
                            Colors.grey[900],
                            Colors.black,
                          ]
                    : [
                        Colors.grey[900],
                        Colors.black,
                      ],
              )
            : null,
      ),
      child: Center(
        child: child ?? defaultChild(),
      ),
    );
  }

  Widget defaultChild() {
    if (loading) {
      return CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
      );
    } else {
      return Icon(
        iconData ?? Icons.broken_image,
        color: Colors.white70,
      );
    }
  }
}
