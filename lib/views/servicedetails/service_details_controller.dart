import 'package:get/get.dart';
import '../../model/review_model.dart';
import '../../model/service_model.dart';
import '../../services/api_service.dart';
import '../../utils/api_exceptions.dart';

class ServiceDetailsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = true.obs;
  var service = Rxn<ServiceModel>();

  final String serviceId;

  var errorMessage = "".obs;
  var isError = false.obs;

  var reviews = <ReviewModel>[].obs;
  var isReviewLoading = false.obs;

  ServiceDetailsController(this.serviceId);

  @override
  void onInit() {
    super.onInit();
    fetchService();
    fetchReviews();
  }

  static const Map<String, String> _pricingLabels = {
    "per_plate": "Per Plate",
    "per_day": "Per Day",
    "per_hour": "Per Hour",
    "fixed": "Fixed Price",
    "package": "Package"

  };

  String priceModelConversion(String? pricingModel) {
    if (pricingModel == null || pricingModel.trim().isEmpty) {
      return "-";
    }

    return _pricingLabels[pricingModel.toLowerCase()] ?? "-";
  }


  Future<void> fetchService() async {
    try {
      isLoading.value = true;
      isError.value = false;
      print("serviceId: $serviceId");
      final response = await apiService.get("services/$serviceId", withAuth: false,);

      service.value = ServiceModel.fromJson(response["data"]);


    } on NoInternetException catch (e) {
      errorMessage.value = e.message;
      isError.value = true;

    } on TimeoutException catch (e) {
      errorMessage.value = e.message;
      isError.value = true;

    } on UnauthorizedException catch (e) {
      errorMessage.value = e.message;
      isError.value = true;

    } on ServerException catch (e) {
      errorMessage.value = e.message;
      isError.value = true;

    } catch (e) {
      errorMessage.value = "Something went wrong";
      isError.value = true;

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReviews() async {
    try {
      isReviewLoading.value = true;

      final response = await apiService.get(
        "reviews/service/$serviceId",
        withAuth: false,
      );

      if (response["success"] == true) {
        reviews.value = (response["data"] as List)
            .map((e) => ReviewModel.fromJson(e))
            .toList();
      }

    } catch (e) {
      print("Review Error: $e");
    } finally {
      isReviewLoading.value = false;
    }
  }
}