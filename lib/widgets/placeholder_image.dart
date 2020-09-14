import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlaceholderImage extends StatelessWidget {
  final IconData iconData;
  final Widget child;
  final double width;
  final double height;
  final bool loading;
  final BorderRadius borderRaius;
  final Color backgroundColor;
  final List<Color> backgroundColors;

  const PlaceholderImage(
      {this.iconData,
      this.child,
      this.width,
      this.height,
      this.loading = false,
      this.borderRaius,
      this.backgroundColor,
      this.backgroundColors});
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
        child: child == null ? defaultChild() : child,
      ),
    );
  }

  Widget defaultChild() {
    if (loading) {
      return SpinKitRing(
        color: Colors.white70,
        size: ScreenUtil().setWidth(64),
        lineWidth: ScreenUtil().setWidth(4),
        duration: Duration(milliseconds: 1200),
      );
    } else {
      return Icon(
        iconData == null ? Icons.broken_image : iconData,
        color: Colors.white70,
        size: ScreenUtil().setWidth(76),
      );
    }
  }
}
