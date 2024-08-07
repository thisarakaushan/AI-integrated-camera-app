import 'package:flutter/material.dart';

class SlideTransitionRoute extends PageRouteBuilder {
  final Widget page;

  SlideTransitionRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const offsetBegin = Offset(-1.0, 0.0);
            const offsetEnd = Offset.zero;
            const curve = Curves.easeInOut;

            final offsetAnimation = Tween<Offset>(
              begin: offsetBegin,
              end: offsetEnd,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));

            final slideTransition = SlideTransition(
              position: offsetAnimation,
              child: child,
            );

            return slideTransition;
          },
        );
}
