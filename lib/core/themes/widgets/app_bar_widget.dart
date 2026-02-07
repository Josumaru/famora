import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    this.actionCallback,
    this.leadingCallback,
    this.actionIcon = Iconsax.more_copy,
    this.leadingIcon = Iconsax.arrow_left_2_copy,
    this.title = "Famora",
  });
  final String title;
  final VoidCallbackAction? leadingCallback;
  final VoidCallbackAction? actionCallback;
  final IconData leadingIcon;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => leadingCallback ?? Navigator.pop(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(leadingIcon),
                ),
              ),
              Text(title),
              Align(alignment: Alignment.centerRight, child: Icon(actionIcon)),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: context.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
