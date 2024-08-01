// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:valuefinder/core/services/upload_image_api_service.dart';

// class CapturePhoto {
//   // Method to save the captured photo to the gallery and upload it to the server
//   Future<void> saveAndUploadPhoto(String imagePath) async {
//     print('Call save photo method');

//     // Check for permissions
//     if (await Permission.storage.request().isGranted) {
//       try {
//         final File imageFile = File(imagePath);
//         if (!await imageFile.exists()) {
//           print('File does not exist at $imagePath');
//           return;
//         }
//         final Uint8List bytes = await imageFile.readAsBytes();

//         final result = await ImageGallerySaver.saveImage(
//           bytes,
//           quality: 100,
//           name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
//         );

//         print('Image saved to gallery: $result');

//         final FirebaseAuth auth = FirebaseAuth.instance;
//         User? user = auth.currentUser;
//         if (user != null) {
//           try {
//             String? token = await user.getIdToken();
//             print('Token: $token'); // printing token for debugging purpose
//             if (token != null) {
//               // Upload image to server
//               final uploadImageApiService = UploadImageApiService(
//                 baseUrl: 'https://uploadimage-s4r2ozb5wq-uc.a.run.app',
//                 token: token,
//               );
//               final uploadResponse =
//                   await uploadImageApiService.uploadImage(imageFile);

//               print(
//                   'uploadResponse : ${uploadResponse.statusCode} ${uploadResponse.body}');
//             } else {
//               print('Error obtaining token: Token is null');
//             }
//           } catch (e) {
//             print('Error getting token: $e');
//           }
//         } else {
//           print('User is not logged in or user object is null');
//         }
//       } catch (e) {
//         print('Error saving image to gallery: $e');
//       }
//     } else {
//       print('Storage permission not granted');
//     }
//   }
// }

// anonymous authentication
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valuefinder/core/services/upload_image_api_service.dart';

class CapturePhoto {
  Future<void> saveAndUploadPhoto(String imagePath) async {
    print('Call save photo method');

    if (await Permission.storage.request().isGranted) {
      try {
        final File imageFile = File(imagePath);
        if (!await imageFile.exists()) {
          print('File does not exist at $imagePath');
          return;
        }
        final Uint8List bytes = await imageFile.readAsBytes();

        final result = await ImageGallerySaver.saveImage(
          bytes,
          quality: 100,
          name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
        );

        print('Image saved to gallery: $result');

        final FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;
        if (user != null) {
          String? token = await user.getIdToken();
          print('Token: $token');
          if (token != null) {
            final uploadImageApiService = UploadImageApiService(
              baseUrl: 'https://uploadimage-s4r2ozb5wq-uc.a.run.app',
              token: token,
            );
            final uploadResponse =
                await uploadImageApiService.uploadImage(imageFile);

            print(
                'uploadResponse : ${uploadResponse.statusCode} ${uploadResponse.body}');
          } else {
            print('Error obtaining token');
          }
        } else {
          print('User is not logged in or user object is null');
        }
      } catch (e) {
        print('Error saving image to gallery: $e');
      }
    } else {
      print('Storage permission not granted');
    }
  }
}
