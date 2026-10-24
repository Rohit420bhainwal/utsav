
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/leads/lead_detail_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/date_utils.dart';
import 'leads_controller.dart';

class LeadsScreen extends StatelessWidget {
  LeadsScreen({super.key});

  final LeadsController controller = Get.put(LeadsController());

  static const double _maxContentWidth = 1200;
  static const Color _pageBackground = Color(0xFFF7F8FA);
  static const Color _primaryText = Color(0xFF202124);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _pageBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        title: const Text('My Leads'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.leads.isEmpty) {
          return _buildEmptyState(context);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
            constraints.maxWidth < 600 ? 16.0 : 28.0;

            final columns = constraints.maxWidth >= 950
                ? 2
                : 1;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _maxContentWidth,
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    22,
                    horizontalPadding,
                    28,
                  ),
                  children: [
                    _buildPageHeading(context),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: controller.leads.map<Widget>((lead) {
                        final cardWidth = columns == 2
                            ? (constraints.maxWidth -
                            horizontalPadding * 2 -
                            18)
                            .clamp(0.0, _maxContentWidth)
                            .toDouble() /
                            2
                            : constraints.maxWidth -
                            horizontalPadding * 2;

                        return SizedBox(
                          width: cardWidth,
                          child: _buildLeadCard(context, lead),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildPageHeading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your enquiries',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'View and track enquiries for your event services.',
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadCard(
      BuildContext context,
      dynamic lead,
      ) {
    final theme = Theme.of(context).textTheme;

    final service = lead['service'] ?? {};
    final event = lead['eventDetails'] ?? {};
    final vendor = lead['vendorId'] ?? {};
    final vendorUser = vendor['userId'] ?? {};
    print("vendorUser: $vendorUser");
    final vendorName = (vendorUser['name'] ?? 'Unknown Vendor').toString();
    final businessName = (vendor['businessName'] ?? '').toString();

    final title = (service['title'] ?? 'No Title').toString();
    final category = (service['categoryName'] ?? '').toString();
    final city = (service['city'] ?? '').toString();

    final eventDate = DateUtilsHelper.formatDate(event['eventDate']);
    final guestCount = (event['guestCount'] ?? 0).toString();
    final budget = (event['budget'] ?? '-').toString();

    final status =
    (lead['status'] ?? 'new').toString().toUpperCase();
    final createdAt = DateUtilsHelper.formatDate(lead['createdAt']);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.to(
                () => LeadDetailScreen(),
            arguments: lead['_id'],
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE9EAF0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor information
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                    AppColors.secondary.withOpacity(0.10),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Text(
                          vendorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _primaryText,
                          ),
                        ),*/
                        if (businessName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            businessName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Color(0xFF9A9DA5),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 16),

              // Service information
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.titleMedium?.copyWith(
                  fontSize: 17,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                  color: _primaryText,
                ),
              ),
              const SizedBox(height: 7),

              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (category.isNotEmpty)
                    _metadataText(
                      icon: Icons.category_outlined,
                      text: category,
                    ),
                  if (city.isNotEmpty)
                    _metadataText(
                      icon: Icons.location_on_outlined,
                      text: city,
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // Event details
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _detailItem(
                            icon: Icons.calendar_month_outlined,
                            label: 'Event date',
                            value: eventDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _detailItem(
                            icon: Icons.people_outline_rounded,
                            label: 'Guests',
                            value: guestCount,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _detailItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Budget',
                      value: controller.formatBudget(budget),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Status and creation date
              Row(
                children: [
                  _statusBadge(status),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      'Created $createdAt',
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metadataText({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: _primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: 40,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No leads yet',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: _primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your enquiries will appear here when they become available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return Colors.grey.shade700;
      case 'converted':
        return const Color(0xFF168451);
      case 'contacted':
        return const Color(0xFFD98212);
      case 'new':
        return const Color(0xFF2878D0);
      default:
        return Colors.grey.shade700;
    }
  }
}