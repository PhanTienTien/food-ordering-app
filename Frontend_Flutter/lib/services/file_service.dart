import 'package:dio/dio.dart';
import 'dio_client.dart';

class FileService {
  final Dio _dio = DioClient().dio;

  Future<String?> uploadImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post('/files/upload', data: formData);
      final data = response.data;

      if (data is Map && data['url'] != null) {
        return data['url'] as String;
      }
      return null;
    } on DioException catch (e) {
      throw Exception('Upload failed: ${e.message}');
    }
  }
}
