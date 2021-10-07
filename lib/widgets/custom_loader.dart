import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with TickerProviderStateMixin {
  Animation? animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    animation = Tween(begin: 20.0, end: 80.0).animate(CurvedAnimation(
        curve: Curves.bounceInOut, parent: animationController!));
    animationController!.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(microseconds: 100))
            .then((value) => animationController!.repeat());
      }
    });
    animationController!.forward();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        return Container(
          child: Center(
            child: CircleAvatar(
              radius: animation!.value,
              backgroundImage: AssetImage("assets/images/favicon.jpeg"),
            ),
          ),
        );
      },
    );
  }
}
