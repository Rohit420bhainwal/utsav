import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utsav/services/secure_storage_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../utils/api_exceptions.dart';


class ApiService {
  static const String baseUrl = "https://utbackend-api.onrender.com/api/v1";
  static const String imageBaseUrl = "https://utbackend-api.onrender.com";

/*  static const String baseUrl = "http://192.168.50.50:5000/api/v1";
  /// 🔥 ADD THIS
  static const String imageBaseUrl = "http://192.168.50.50:5000";*/

  //final Dio _dio = Dio(BaseOptions(baseUrl: 'https://192.168.222.102:5000/api/v1/auth/'));

  final box = GetStorage();

  Future<Map<String, String>> getHeaders({bool withAuth = false}) async {
    //final userData = box.read("userData");
    final token = await SecureStorageService.getToken();
    print("token_1: $token");
    final headers = {"Content-Type": "application/json",
      "x-app-type": "customer"
    };
    if (withAuth) {
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }
// Book@myeyent
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body,
      {bool withAuth = false}) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final response = await http.post(url,
        headers: await getHeaders(withAuth: withAuth),
        body: jsonEncode(body));
    // print("status: ${response.statusCode}");
    // print("body: ${response.body}");
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> get(
      String endpoint, {
        bool withAuth = false,
        Map<String, String>? queryParams,
      }) async {
    try {
      final uri = Uri.parse("$baseUrl/$endpoint")
          .replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: await getHeaders(withAuth: withAuth))
          .timeout(const Duration(seconds: 15));

      return _processResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw ApiException("Unexpected error occurred");
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body,
      {bool withAuth = false}) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final response = await http.put(
      url,
      headers: await getHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );

    print("PUT $endpoint -> status: ${response.statusCode}");
    print("PUT $endpoint -> body: ${response.body}");

    return _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw ServerException("Empty response from server");
    }

    final decodedBody = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return decodedBody;

      case 400:
        throw ServerException(decodedBody["message"] ?? "Bad request");

      case 401:
        throw UnauthorizedException();

      case 404:
        throw ServerException("Resource not found");

      case 500:
        throw ServerException("Internal server error");

      default:
        throw ServerException("Something went wrong");
    }
  }

  /// 🖼 GET FULL IMAGE URL
  String getImageUrl(String path) {
    if (path.isEmpty) return "";

    return "$imageBaseUrl/${path.replaceAll("\\", "/")}";
  }

  Future<Map<String, dynamic>> multipartPut(
      String endpoint, {
        required Map<String, String> fields,
        required List<File> files,
        required String fileKey,
      }) async {
    return _multipartRequest(
      "PUT",
      endpoint,
      fields: fields,
      files: files,
      fileKey: fileKey,
    );
  }

  /// 🔥 COMMON MULTIPART METHOD (REUSABLE)
  Future<Map<String, dynamic>> _multipartRequest(
      String method,
      String endpoint, {
        required Map<String, String> fields,
        required List<File> files,
        required String fileKey,
      }) async {
    final uri = Uri.parse("$baseUrl/$endpoint");

    var request = http.MultipartRequest(method, uri);

    /// 🔐 HEADERS
    request.headers.addAll(await getHeaders(withAuth: true));

    /// 📦 FIELDS
    request.fields.addAll(fields);

    /// 🖼 FILES
    for (var file in files) {
      final mimeType = lookupMimeType(file.path) ?? "image/jpeg";
      final mimeSplit = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          contentType: MediaType(
            mimeSplit[0],
            mimeSplit[1],
          ),
        ),
      );
    }

    /// 🚀 SEND
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    /// 🧪 DEBUG
    print("$method $endpoint -> STATUS: ${response.statusCode}");
    print("$method $endpoint -> BODY: ${response.body}");

    /// ⚠️ SAFE PARSE
    try {
      return _processResponse(response);
    } catch (e) {
      print("❌ RAW ERROR RESPONSE: ${response.body}");
      throw Exception("Invalid server response");
    }
  }

}
