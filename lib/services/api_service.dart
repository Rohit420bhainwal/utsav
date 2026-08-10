import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:utsav/services/secure_storage_service.dart';
import '../config/api_config.dart';
import '../constants/api_constants.dart';
import '../constants/app_strings.dart';
import '../utils/api_exceptions.dart';

class ApiService {
  final box = GetStorage();

  Future<Map<String, String>> getHeaders({
    bool withAuth = false,
  }) async {
    final token = await SecureStorageService.getToken();

    final headers = <String, String>{
      ApiConstants.contentType: ApiConstants.applicationJson,
      ApiConstants.appType: ApiConstants.customer,
    };

    if (withAuth && token != null) {
      headers[ApiConstants.authorization] =
      '${ApiConstants.bearer} $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body, {
        bool withAuth = false,
      }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');

    final response = await http.post(
      url,
      headers: await getHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> get(
      String endpoint, {
        bool withAuth = false,
        Map<String, String>? queryParams,
      }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: await getHeaders(withAuth: withAuth),
      ).timeout(ApiConfig.requestTimeout);

      return _processResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw ApiException(AppStrings.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> body, {
        bool withAuth = false,
      }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');

    final response = await http.put(
      url,
      headers: await getHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );

    return _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw ServerException(AppStrings.emptyResponse);
    }

    final decodedBody = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return decodedBody;

      case 400:
        throw ServerException(decodedBody["message"] ?? AppStrings.badRequest,);

      case 401:
        throw UnauthorizedException();

      case 404:
        throw ServerException(AppStrings.resourceNotFound);

      case 500:
        throw ServerException(AppStrings.internalServerError);

      default:
        throw ServerException(AppStrings.somethingWentWrong);
    }
  }

  String getImageUrl(String path) {
    if (path.isEmpty) {
      return AppStrings.emptyString;
    }

  //  return '${ApiConfig.imageBaseUrl}/${path.replaceAll("\\", "/")}';
    return path;
  }

  Future<Map<String, dynamic>> multipartPut(
      String endpoint, {
        required Map<String, String> fields,
        required List files,
        required String fileKey,
      }) async {
    return _multipartRequest(
      ApiConstants.put,
      endpoint,
      fields: fields,
      files: files,
      fileKey: fileKey,
    );
  }

  Future<Map<String, dynamic>> _multipartRequest(
      String method,
      String endpoint, {
        required Map<String, String> fields,
        required List files,
        required String fileKey,
      }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');

    final request = http.MultipartRequest(method, uri);

    request.headers.addAll(
      await getHeaders(withAuth: true),
    );

    request.fields.addAll(fields);

    for (final file in files) {
      final mimeType =
          lookupMimeType(file.path) ??
              ApiConstants.defaultImageMimeType;

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

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    return _processResponse(response);
  }
}