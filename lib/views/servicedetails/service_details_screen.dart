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
        /// ================= LOADING =================
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ================= ERROR UI =================
        if (controller.isError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: controller.fetchService,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        final service = controller.service.value;
        final priceModel = controller.priceModelConversion(service?.pricingModel??"");
        print("service: $service");
        /// ================= EMPTY =================
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
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_outlined,
                                size: 60, color: Colors.grey),
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
                            final imageUrl =service.images[index];
                            //controller.apiService.getImageUrl(service.images[index]);
                            print("imageUrl: $imageUrl");
                            return GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                    FullScreenImageViewer(
                                      images: service.images,
                                      initialIndex: index,
                                    ));
                              },
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                /// FADE
                                frameBuilder: (context, child,
                                    frame, wasSync) {
                                  if (wasSync) return child;
                                  return AnimatedOpacity(
                                    opacity:
                                    frame == null ? 0 : 1,
                                    duration:
                                    const Duration(
                                        milliseconds: 400),
                                    child: child,
                                  );
                                },

                                /// LOADING
                                loadingBuilder:
                                    (context, child, progress) {
                                  if (progress == null)
                                    return child;

                                  return Container(
                                    height: 280,
                                    color:
                                    Colors.grey.shade200,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 28,
                                          width: 28,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors
                                                .secondary,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 10),
                                        Text(
                                          "Loading image...",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .grey.shade600,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },

                                /// ERROR IMAGE
                                errorBuilder:
                                    (context, error, stack) {
                                  return Container(
                                    height: 280,
                                    color:
                                    Colors.grey.shade200,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: const [
                                        Icon(
                                            Icons
                                                .broken_image_outlined,
                                            size: 50,
                                            color: Colors.grey),
                                        SizedBox(height: 10),
                                        Text(
                                          "Failed to load image",
                                          style: TextStyle(
                                              color: Colors.grey),
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

                      /// BACK
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

                  /// 🔹 TITLE
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style:
                          textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

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
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              service.rating > 0
                                  ? service.rating
                                  .toStringAsFixed(1)
                                  : "0.0",
                              style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "(${service.totalReviews})",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                             Icon(Icons.location_on,
                                size: 18,
                                color: AppColors.green),
                            const SizedBox(width: 4),
                            Text("${service.vendorAddress}-${service.city}",
                              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 PRICE
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${service.price.toStringAsFixed(0)}/$priceModel",
                          style: textTheme.labelMedium?.copyWith(color: AppColors.secondary,fontWeight: FontWeight.bold),
                          /*style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),*/
                        ),
                        Chip(
                          label:
                          Text(service.categoryName),
                          backgroundColor: AppColors
                              .secondary
                              .withOpacity(0.1),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 DESCRIPTION
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                         Text(
                          "Description",
                          style: textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
                        ),
                        SizedBox(height: 8),
                        Text(service.description,
                          style: textTheme.bodyMedium?.copyWith(color:AppColors.textPrimary ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 REVIEWS
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Customer Reviews",
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "${controller.reviews.length} Reviews",
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        if (controller.isReviewLoading.value)
                          const Center(
                            child: CircularProgressIndicator(),
                          )

                        else if (controller.reviews.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.rate_review_outlined,
                                    color: Colors.grey.shade400,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No reviews yet",
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )

                        else
                          ListView.separated(
                            itemCount: controller.reviews.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) =>
                            const Divider(height: 24),
                            itemBuilder: (context, index) {
                              final review = controller.reviews[index];

                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  /// NAME + RATING
                                  Row(
                                    children: [

                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor:
                                        AppColors.secondary.withOpacity(0.1),
                                        child: Text(
                                          review.customerName
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review.customerName,
                                              style: textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Row(
                                              children: List.generate(
                                                5,
                                                    (star) => Icon(
                                                  star < review.rating.round()
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  size: 16,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    review.review,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                /*  const SizedBox(height: 30),*/
                ],
              ),
            ),

        /*    /// ================= BUTTON =================
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
                      backgroundColor:
                      AppColors.secondary,
                      padding:
                      const EdgeInsets.symmetric(
                          vertical: 16),
                    ),
                    onPressed: () async {
                      final result =
                      await Get.to(() =>
                          MessageScreen(
                            serviceId: service.id,
                            serviceTitle:
                            service.title,
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
                      style:
                      TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        );
      }),
      bottomNavigationBar: Obx(() {

        final service = controller.service.value;

        if (service == null) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                icon: const Icon(
                  Icons.message_rounded,
                  color: Colors.white,
                ),

                label: const Text(
                  "Message Vendor",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                onPressed: () async {
                  final result = await Get.to(
                        () => MessageScreen(
                      serviceId: service.id,
                      serviceTitle: service.title,
                      vendorName: service.vendorName,
                    ),
                  );

                  if (result == true) {
                    Get.snackbar(
                      "Success",
                      "Inquiry submitted successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ),
          ),
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