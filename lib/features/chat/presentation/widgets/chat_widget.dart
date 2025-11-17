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
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(image)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Text(
                  sender,
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface.withValues(alpha: .8),
                  ),
                ),
                Text(
                  time,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
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
        Spacer(),
        (lat != null && lng != null)
            ? GestureDetector(
                onTap: () async {
                  final url =
                      'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {}
                },
                child: Icon(Iconsax.location_copy),
              )
            : SizedBox(),
      ],
    );
  }
}
