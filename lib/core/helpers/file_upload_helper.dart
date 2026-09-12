

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class FileUploadHelper {
  FileUploadHelper._();

  static Future<MultipartFile?> toMultipart(String? filePath) async {
    if (filePath == null || filePath.trim().isEmpty) return null;

    final file = File(filePath);
    if (!await file.exists()) return null;

    final ext = filePath.split('.').last.toLowerCase();
    String mimeSubtype;
    switch (ext) {
      case 'png':
        mimeSubtype = 'png';
        break;
      case 'webp':
        mimeSubtype = 'webp';
        break;
      case 'pdf':
        return MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
          contentType: MediaType('application', 'pdf'),
        );
      default:
        mimeSubtype = 'jpeg';
    }

    return MultipartFile.fromFile(
      file.path,
      filename: file.path.split(Platform.pathSeparator).last,
      contentType: MediaType('image', mimeSubtype),
    );
  }
}
