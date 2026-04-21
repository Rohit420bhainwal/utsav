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



  Future<void> fetchService() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await apiService.get(
        "services/$serviceId",
        withAuth: false,
      );

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