import 'package:get/get.dart';
import '../../services/api_service.dart';

class LeadsController extends GetxController {

  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var leads = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyLeads();
  }

  Future<void> fetchMyLeads() async {

    try {

      isLoading.value = true;

      final response = await _apiService.get(
        "leads/my",
        withAuth: true,
      );

      print("response_lead $response");

      if(response["success"] == true) {
        leads.value = response["data"];
      }

    } catch (e) {
      print("Lead error $e");
    } finally {
      isLoading.value = false;
    }

  }

  String formatBudget(dynamic budget) {
    if (budget == null) return "₹ --";

    try {
      final value = double.parse(budget.toString());

      if (value <= 0) return "₹ --";

      return "₹ ${value.toStringAsFixed(0)}";
    } catch (e) {
      return "₹ --";
    }
  }
}