import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/servicedetails/service_details_screen.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 16,
        title: Obx(() {
          if (controller.isCityLoading.value) {
            return const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedCity.value.isEmpty
                  ? null
                  : controller.selectedCity.value,
              hint: const Text("Select City"),
              items: controller.cities
                  .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.changeCity(value);
                }
              },
            ),
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.profile);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),

            // ================= SEARCH BAR =================
           /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearch,
                decoration: InputDecoration(
                  hintText: "Search services...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),*/

            // ================= CATEGORY TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Explore Categories",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================= CATEGORY CHIPS =================
            Obx(() {
              if (controller.isCategoryLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip("All"),
                    ...controller.categories
                        .map((cat) =>
                        _buildCategoryChip(cat.name))
                        .toList(),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // ================= SERVICES GRID =================
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.services.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text("No services found"),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.services.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                  itemBuilder: (context, index) {
                    final service = controller.services[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ServiceDetailsScreen(
                          serviceId: service.id, // make sure model has id
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: service.images.isNotEmpty
                                  ? Image.network(
                                controller.apiService.getImageUrl(service.images[0]),
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                // ✅ LOADING (Better UI)
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Container(
                                    height: 110,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Loading...",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },

                                // ✅ ERROR UI (Clean)
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 110,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.broken_image_outlined,
                                            size: 30, color: Colors.grey),
                                        SizedBox(height: 6),
                                        Text(
                                          "Image not available",
                                          style: TextStyle(fontSize: 11, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )
                                  : Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.image_outlined,
                                        size: 30, color: Colors.grey),
                                    SizedBox(height: 6),
                                    Text(
                                      "No Image",
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "₹${service.price.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String name) {
    return Obx(() {
      final isSelected =
          controller.selectedCategory.value == name;

      return GestureDetector(
        onTap: () {
          controller.changeCategory(name);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding:
          const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondary
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary
                  : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(
              color:
              isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}