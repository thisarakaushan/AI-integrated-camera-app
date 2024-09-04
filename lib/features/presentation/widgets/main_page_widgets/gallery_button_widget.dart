import 'package:flutter/material.dart';
import 'package:valuefinder/core/utils/widget_constants.dart';

class GalleryButtonWidget extends StatelessWidget {
  final VoidCallback onGalleryPressed;

  const GalleryButtonWidget({super.key, required this.onGalleryPressed});

  @override
  Widget build(BuildContext context) {
    final double buttonSize = WidgetsConstant.width * 18;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(buttonSize / 2), // Circular border radius
        gradient: const LinearGradient(
          colors: [Color(0xff2753cf), Color(0xffc882ff), Color(0xff46edfe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xff0e235a),
            borderRadius:
                BorderRadius.circular(buttonSize / 2), // Circular border radius
          ),
          child: ElevatedButton(
            onPressed: onGalleryPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    buttonSize / 2), // Circular border radius
              ),
              padding: EdgeInsets.zero,
              shadowColor: Colors.transparent,
            ),
            child: Icon(
              Icons.photo,
              color: Colors.white,
              size: buttonSize * 0.4, // Icon size relative to button size
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class GalleryButtonWidget extends StatelessWidget {
//   final VoidCallback onGalleryPressed;

//   const GalleryButtonWidget({super.key, required this.onGalleryPressed});

//   @override
//   Widget build(BuildContext context) {
//     final double buttonWidth =
//         MediaQuery.of(context).size.width * 0.5; // 60% of screen width
//     final double buttonHeight =
//         MediaQuery.of(context).size.height * 0.07; // 10% of screen height

//     return Container(
//       width: buttonWidth,
//       height: buttonHeight,
//       decoration: BoxDecoration(
//         borderRadius:
//             BorderRadius.circular(buttonHeight / 2), // Circular border radius
//         gradient: const LinearGradient(
//           colors: [Color(0xff2753cf), Color(0xffc882ff), Color(0xff46edfe)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(2),
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//             color: const Color(0xff0e235a),
//             borderRadius: BorderRadius.circular(
//                 buttonHeight / 2), // Circular border radius
//           ),
//           child: ElevatedButton(
//             onPressed: onGalleryPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(
//                     buttonHeight / 2), // Circular border radius
//               ),
//               padding: EdgeInsets.symmetric(
//                   horizontal: buttonWidth * 0.1,
//                   vertical:
//                       buttonHeight * 0.15), // Padding relative to button size
//               shadowColor: Colors.transparent,
//             ),
//             child: const Text(
//               'Gallery',
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
