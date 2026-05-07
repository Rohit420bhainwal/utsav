import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../model/service_model.dart';
import '../../model/category_model.dart';
import '../../services/api_service.dart';
import '../../utils/api_exceptions.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = true.obs;
  var isCategoryLoading = false.obs;
  var isCityLoading = true.obs;

  var isError = false.obs;
  var errorMessage = "".obs;

  var selectedCategory = "All".obs;
  var selectedCity = "".obs;

  var searchController = TextEditingController();

  var categories = <CategoryModel>[].obs;
  var services = <ServiceModel>[].obs;
  var cities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initFlow();
  }

  /// 🔥 MAIN FLOW (FIXED)
  Future<void> initFlow() async {
    try {
      isLoading.value = true;
      isError.value = false;

      /// 1️⃣ Fetch cities first (but DON'T assign default)
      await fetchCities();

      /// 2️⃣ Detect user city
      final userCity = await detectUserCity();

      /// 3️⃣ Validate city
      if (userCity == null) {
        errorMessage.value =
        "We couldn’t detect your location. Please enable location services.";
        isError.value = true;
        return;
      }

      if (!cities.contains(userCity)) {
        /// ❌ NOT SUPPORTED LOCATION
        errorMessage.value =
        "Utsav is not available in your location yet. We’ll be there soon 🎉";
        isError.value = true;
        return;
      }

      /// ✅ SET CITY
      selectedCity.value = userCity;

      /// 4️⃣ Fetch categories + services
      await fetchCategories();
      await fetchServices();

    } catch (e) {
      isError.value = true;
      errorMessage.value = "Something went wrong. Please try again.";
    } finally {
      isLoading.value = false;
      isCityLoading.value = false;
    }
  }

  // ================= FETCH CITIES =================
  Future<void> fetchCities() async {
    try {
      final response = await apiService.get("cities");

      if (response["success"] == true) {
        final List list = response["data"];
        cities.value =
            list.map((e) => e["name"].toString()).toList();
      }
    } catch (e) {
      throw Exception("Failed to load cities");
    }
  }

  // ================= DETECT USER CITY =================
  Future<String?> detectUserCity() async {
    try {
      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position =
      await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
      await placemarkFromCoordinates(
          position.latitude, position.longitude);

      return placemarks.first.locality;

    } catch (e) {
      return null;
    }
  }

  // ================= FETCH CATEGORIES =================
  Future<void> fetchCategories() async {
    try {
      isCategoryLoading.value = true;

      final response = await apiService.get("categories");

      if (response["data"] is List) {
        categories.value = (response["data"] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      }
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // ================= FETCH SERVICES =================
  Future<void> fetchServices({
    String? category,
    String? search,
  }) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await apiService.get(
        "services",
        queryParams: {
          "city": selectedCity.value,
          if (category != null && category != "All")
            "category": category,
          if (search != null && search.isNotEmpty)
            "search": search,
        },
      );

      if (response["data"] is List) {
        services.value = (response["data"] as List)
            .map((e) => ServiceModel.fromJson(e))
            .toList();

        /// 🔥 EMPTY STATE
        if (services.isEmpty) {
          /*isError.value = true;*/
          errorMessage.value =
          "No services available in your area yet. We’ll be there soon 🎉";
        }
      }
    } on ApiException catch (e) {
      isError.value = true;
      errorMessage.value = e.message;
    } catch (e) {
      isError.value = true;
      errorMessage.value =
      "Service not available in your location.";
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CHANGE CATEGORY =================
  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchServices(
      category: category,
      search: searchController.text,
    );
  }

  // ================= CHANGE CITY =================
  void changeCity(String city) {
    selectedCity.value = city;
    fetchServices(
      category: selectedCategory.value,
      search: searchController.text,
    );
  }

  // ================= SEARCH =================
  void onSearch(String value) {
    fetchServices(
      category: selectedCategory.value,
      search: value,
    );
  }
}