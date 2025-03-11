import 'package:flutter/material.dart';

extension NavigationMethods on BuildContext {
  void pop() {
    Navigator.pop(this);
  }

  void pushAndRemove(Widget route) {
    Navigator.pushAndRemoveUntil(
      this,
      SlidePageRoute(child: route),
      (route) => false,
    );
  }

  void pushReplacement(Widget route) {
    Navigator.pushReplacement(
      this,
      SlidePageRoute(child: route),
    );
  }

  void push(
    Widget route, {
    Object? arguments,
  }) {
    Navigator.push(
      this,
      SlidePageRoute(child: route),
    );
  }
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget child;

  SlidePageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
