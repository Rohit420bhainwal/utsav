class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "https://utbackend-api.onrender.com/api/v1";

  static const String imageBaseUrl = "https://utbackend-api.onrender.com";

  static const Duration requestTimeout = Duration(seconds: 30);
}