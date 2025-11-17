import 'package:flutter/material.dart';

extension RadiusExtension on BuildContext {
  // Default Rounded
  BorderRadius get brXs => BorderRadius.circular(4);
  BorderRadius get brSm => BorderRadius.circular(8);
  BorderRadius get brMd => BorderRadius.circular(16);
  BorderRadius get brLg => BorderRadius.circular(24);
  BorderRadius get brXl => BorderRadius.circular(32);
  BorderRadius get brFull => BorderRadius.circular(999);

  // Top Only
  BorderRadius get brOnlyTopXs => const BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(4),
  );
  BorderRadius get brOnlyTopSm => const BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(8),
  );
  BorderRadius get brOnlyTopMd => const BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );
  BorderRadius get brOnlyTopLg => const BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );
  BorderRadius get brOnlyTopXl => const BorderRadius.only(
    topLeft: Radius.circular(32),
    topRight: Radius.circular(32),
  );

  // Bottom Only
  BorderRadius get brOnlyBottomXs => const BorderRadius.only(
    bottomLeft: Radius.circular(4),
    bottomRight: Radius.circular(4),
  );
  BorderRadius get brOnlyBottomSm => const BorderRadius.only(
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );
  BorderRadius get brOnlyBottomMd => const BorderRadius.only(
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );
  BorderRadius get brOnlyBottomLg => const BorderRadius.only(
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );
  BorderRadius get brOnlyBottomXl => const BorderRadius.only(
    bottomLeft: Radius.circular(32),
    bottomRight: Radius.circular(32),
  );

  // Left Only
  BorderRadius get brOnlyLeftSm => const BorderRadius.only(
    topLeft: Radius.circular(8),
    bottomLeft: Radius.circular(8),
  );
  BorderRadius get brOnlyLeftMd => const BorderRadius.only(
    topLeft: Radius.circular(16),
    bottomLeft: Radius.circular(16),
  );
  BorderRadius get brOnlyLeftLg => const BorderRadius.only(
    topLeft: Radius.circular(24),
    bottomLeft: Radius.circular(24),
  );

  // Right Only
  BorderRadius get brOnlyRightSm => const BorderRadius.only(
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );
  BorderRadius get brOnlyRightMd => const BorderRadius.only(
    topRight: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );
  BorderRadius get brOnlyRightLg => const BorderRadius.only(
    topRight: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );
}
