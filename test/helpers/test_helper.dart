import 'package:mockito/annotations.dart';
import 'package:valuefinder/features/domain/repositories/camera_image_repository.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [CameraImageRepository],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
