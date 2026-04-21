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

  var isLoading = false.obs;
  var isCategoryLoading = false.obs;
  var isCityLoading = false.obs;

  var isError = false.obs;
  var errorMessage = "".obs;

  var selectedCategory = "All".obs;
  var selectedCity = "".obs;

  var searchController = TextEditingController();

  var categories = <CategoryModel>[].obs;
  var services = <ServiceModel>[].obs;
  var cities = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await fetchCities();
    await detectUserCity();
    await fetchCategories();
    fetchServices();
  }

  // ================= FETCH CITIES =================
  Future<void> fetchCities() async {
    try {
      isCityLoading.value = true;

      final response = await apiService.get("cities");

      if (response["success"] == true) {
        final List list = response["data"];

        cities.value = list.map((e) => e["name"].toString()).toList();

        if (cities.isNotEmpty) {
          selectedCity.value = cities.first;
        }
      }
    } catch (e) {
      print("City error: $e");
    } finally {
      isCityLoading.value = false;
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
    } catch (e) {
      print("Category error: $e");
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

      Map<String, String> queryParams = {
        "city": selectedCity.value,
      };

      if (category != null && category != "All") {
        queryParams["category"] = category;
      }

      if (search != null && search.isNotEmpty) {
        queryParams["search"] = search;
      }

      final response = await apiService.get(
        "services",
        queryParams: queryParams,
      );

      if (response["data"] is List) {
        services.value = (response["data"] as List)
            .map((e) => ServiceModel.fromJson(e))
            .toList();
      }
    } on ApiException catch (e) {
      isError.value = true;
      errorMessage.value = e.message;
    } catch (e) {
      isError.value = true;
      errorMessage.value = "Something went wrong";
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

  Future<void> detectUserCity() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
      await placemarkFromCoordinates(
          position.latitude, position.longitude);

      final city = placemarks.first.locality;

      if (city != null && cities.contains(city)) {
        selectedCity.value = city;
      }
    } catch (e) {
      print("Location error: $e");
    }
  }
}