import 'package:get/get.dart';
import '../../model/service_model.dart';
import '../../services/api_service.dart';

class ServiceDetailsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = true.obs;
  var service = Rxn<ServiceModel>();

  final String serviceId;

  ServiceDetailsController(this.serviceId);

  @override
  void onInit() {
    super.onInit();
    fetchService();
  }

  Future<void> fetchService() async {
    try {
      isLoading.value = true;

      final response = await apiService.get("services/$serviceId",withAuth: false);
      print("response_detail: $response");

      if (response["success"] == true) {
        service.value =
            ServiceModel.fromJson(response["data"]);
      }
    } catch (e) {
      print("Details error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}