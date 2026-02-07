import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ErrorMessageWidget extends ConsumerStatefulWidget {
  const ErrorMessageWidget({super.key, required this.errorMessage});
  final String errorMessage;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ErrorMessageWidgetState();
}

class _ErrorMessageWidgetState extends ConsumerState<ErrorMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.warning_2_copy,
            size: 40,
            color: context.colorScheme.error,
          ),
          Text(
            widget.errorMessage,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
