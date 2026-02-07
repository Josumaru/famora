import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWidget extends HookConsumerWidget {
  final String message;
  final String image;
  final String sender;
  final double? lat;
  final double? lng;
  final String time;
  const ChatWidget({
    required this.sender,
    required this.message,
    required this.image,
    this.lng,
    this.lat,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmergency = lat != 0.0 && lng != 0.0;
    if (isEmergency) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Sender + Time
            Row(
              children: [
                CircleAvatar(radius: 18, backgroundImage: NetworkImage(image)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sender,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Iconsax.warning_2_copy, color: Colors.red, size: 26),
              ],
            ),

            const SizedBox(height: 10),

            // Emergency label
            // Row(
            //   children: [
            //     // Icon(Iconsax.flash_copy, color: Colors.red, size: 18),
            //     const SizedBox(width: 6),
            //     Text(
            //       "EMERGENCY MESSAGE",
            //       style: context.textTheme.bodyMedium!.copyWith(
            //         color: Colors.red,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),

            // const SizedBox(height: 6),

            // Message
            Text(message, style: context.textTheme.bodyMedium),

            const SizedBox(height: 12),

            // Open Location
            GestureDetector(
              onTap: () async {
                final url =
                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.location_copy, color: Colors.red, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Buka Lokasi",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      spacing: 8,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(image)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(
                    sender,
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface.withValues(
                        alpha: .8,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  message,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        // Spacer(),
        if (isEmergency) ...[
          GestureDetector(
            onTap: () async {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {}
            },
            child: Icon(Iconsax.location_copy),
          ),
        ],
      ],
    );
  }
}
