import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UploadImageApiService {
  final String baseUrl;
  final String token;

  UploadImageApiService({required this.baseUrl, required this.token});

  Future<http.Response> uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();
    return await http.Response.fromStream(response);
  }
}
