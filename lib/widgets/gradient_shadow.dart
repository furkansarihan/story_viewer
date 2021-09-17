import 'package:flutter/material.dart';

class GradientShadow extends StatelessWidget {
  final bool top;
  final bool expand;
  final double? height;
  final double? width;
  final List<double>? stops;
  final List<int>? alphas;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const GradientShadow({
    Key? key,
    this.height,
    this.top = true,
    this.stops,
    this.alphas,
    this.color,
    this.borderRadius,
    this.width,
    this.expand = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color _c = color ?? Colors.black;
    Widget returnW = IgnorePointer(
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            colors: [
              for (var alpha in alphas!) _c.withAlpha(alpha),
            ],
            begin: FractionalOffset(0.0, top ? 1.0 : 0.0),
            end: FractionalOffset(0.0, top ? 0.0 : 1.0),
            stops: stops,
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
    if (expand) {
      return returnW;
    }

    return Positioned(
        bottom: top ? null : 0, top: top ? 0 : null, child: returnW);
  }
}
