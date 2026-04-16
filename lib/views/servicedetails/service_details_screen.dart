import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/message/message_screen.dart';
import '../../utils/app_colors.dart';
import '../../services/api_service.dart';
import 'service_details_controller.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceId;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceDetailsController(serviceId));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final service = controller.service.value;

        if (service == null) {
          return const Center(child: Text("Service not found"));
        }

        return Stack(
          children: [
            /// ================= SCROLLABLE =================
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 IMAGE CAROUSEL
                  Stack(
                    children: [
                      service.images.isEmpty
                          ? Container(
                        height: 280,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_outlined, size: 60, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              "No images available",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(
                        height: 280,
                        child: PageView.builder(
                          itemCount: service.images.length,
                          itemBuilder: (context, index) {
                            final imageUrl =
                            controller.apiService.getImageUrl(
                                service.images[index]);

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => FullScreenImageViewer(
                                  images: service.images,
                                  initialIndex: index,
                                ));
                              },
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                // ✅ FADE-IN EFFECT
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (wasSynchronouslyLoaded) return child;
                                  return AnimatedOpacity(
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(milliseconds: 400),
                                    child: child,
                                  );
                                },

                                // ✅ LOADING UI
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Container(
                                    height: 280,
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 28,
                                          width: 28,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Loading image...",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },

                                // ✅ ERROR UI
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 280,
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.broken_image_outlined,
                                            size: 50, color: Colors.grey),
                                        SizedBox(height: 10),
                                        Text(
                                          "Failed to load image",
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      /// 🔙 BACK BUTTON
                      Positioned(
                        top: 40,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 TITLE CARD
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                /// ⭐ STARS
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < service.rating.round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                      size: 20,
                                    );
                                  }),
                                ),

                                const SizedBox(width: 8),

                                /// ⭐ AVG RATING
                                Text(
                                  service.rating > 0
                                      ? service.rating.toStringAsFixed(1)
                                      : "0.0",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                /// ⭐ TOTAL REVIEWS
                                Text(
                                  "(${service.totalReviews})",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            /// 🔥 EMPTY STATE
                            if (service.totalReviews == 0)
                              Text(
                                "No reviews yet",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(service.city),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 PRICE
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${service.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Chip(
                          label: Text(service.categoryName),
                          backgroundColor:
                          AppColors.secondary.withOpacity(0.1),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 DESCRIPTION
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(service.description),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            /// ================= BUTTON =================
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final result =
                      await Get.to(() => MessageScreen(
                        serviceId: service.id,
                        serviceTitle: service.title,
                        vendorName:
                        service.vendorName,
                      ));

                      if (result == true) {
                        Get.snackbar(
                          "Success",
                          "Inquiry submitted successfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text(
                      "Message",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// ================= FULL SCREEN VIEWER =================
class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() =>
      _FullScreenImageViewerState();
}

class _FullScreenImageViewerState
    extends State<FullScreenImageViewer> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final imageUrl =
          _apiService.getImageUrl(widget.images[index]);

          return InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: Image.network(imageUrl),
            ),
          );
        },
      ),
    );
  }
}