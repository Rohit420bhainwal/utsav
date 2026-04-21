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
                backgroundColor:
                AppColors.secondary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: Obx(() {
        /// 🔴 ERROR STATE
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off,
                    size: 70, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchServices(),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 16),

              /// ================= CATEGORY TITLE =================
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Explore Categories",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// ================= CATEGORY LIST =================
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
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

              /// ================= SERVICES =================
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator()),
                  );
                }

                if (controller.services.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: Text("No services found")),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  itemCount: controller.services.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final service =
                    controller.services[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            ServiceDetailsScreen(
                              serviceId: service.id,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            /// ================= SAFE IMAGE =================
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: service.images.isNotEmpty
                                  ? Image.network(
                                controller.apiService
                                    .getImageUrl(
                                    service.images[0]),
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                loadingBuilder:
                                    (context, child,
                                    progress) {
                                  if (progress ==
                                      null) return child;

                                  return Container(
                                    height: 110,
                                    color: Colors
                                        .grey.shade200,
                                    child:
                                    const Center(
                                      child:
                                      CircularProgressIndicator(
                                          strokeWidth:
                                          2),
                                    ),
                                  );
                                },

                                errorBuilder: (context,
                                    error, stack) {
                                  return _noImage();
                                },
                              )
                                  : _noImage(),
                            ),

                            /// ================= TEXT =================
                            Padding(
                              padding:
                              const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    service.title,
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style: textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "₹${service.price.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: AppColors
                                          .secondary,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    service.categoryName,
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style: textTheme
                                        .titleSmall
                                        ?.copyWith(color: AppColors.textPrimary),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children:
                                        List.generate(5, (index) {
                                          return Icon(
                                            index <
                                                service.rating
                                                    .round()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.orange,
                                            size: 10,
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        service.rating > 0
                                            ? service.rating
                                            .toStringAsFixed(1)
                                            : "0.0",
                                        style: textTheme.bodySmall?.copyWith(color: AppColors.primary),
                                        // style: const TextStyle(
                                        //     fontWeight:
                                        //     FontWeight.bold),
                                      ),

                                      Text(
                                        "(${service.totalReviews})",
                                        style: textTheme.bodySmall?.copyWith(color: AppColors.primary),
                                        /*style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),*/
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  /// ================= CATEGORY CHIP =================
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

  /// ================= NO IMAGE WIDGET =================
  Widget _noImage() {
    return Container(
      height: 110,
      width: double.infinity,
      color: Colors.grey.shade200,
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
    );
  }
}