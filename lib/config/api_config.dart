class ApiConfig {
  ApiConfig._();
//192.168.222.197
  static const String baseUrl = "https://utbackend-api.onrender.com/api/v1";

  static const String imageBaseUrl = "https://utbackend-api.onrender.com";

  // static const String baseUrl = "https://192.168.222.197:5000/api/v1";
  //
  // static const String imageBaseUrl = "https://192.168.222.197:5000";

  static const Duration requestTimeout = Duration(seconds: 30);
}