import 'package:get/get.dart';
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

  ServiceDetailsController(this.serviceId);

  @override
  void onInit() {
    super.onInit();
    fetchService();
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
}