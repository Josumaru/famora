import 'package:famora/core/providers/navigation_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/features/chat/presentation/pages/chat_page.dart';
import 'package:famora/features/home/presentation/pages/home_page.dart';
import 'package:famora/features/monitor/presentation/pages/monitor_page.dart';
import 'package:famora/features/setting/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavigationPage extends HookConsumerWidget {
  const NavigationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(navigationProvider);
    return PersistentTabView(
      controller: controller,
      tabs: [
        // PersistentTabConfig(
        //   screen: HomePage(),
        //   item: ItemConfig(
        //     activeForegroundColor: context.colorScheme.primary,
        //     icon: Padding(
        //       padding: const EdgeInsets.only(top: 3.0),
        //       child: Icon(Iconsax.home_1_copy),
        //     ),
        //     title: "Home",
        //   ),
        // ),
        PersistentTabConfig(
          screen: ChatPage(),
          item: ItemConfig(
            activeForegroundColor: context.colorScheme.primary,
            icon: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Icon(Iconsax.message_copy),
            ),
            title: "Chat",
          ),
        ),
        PersistentTabConfig(
          screen: MonitorPage(),
          item: ItemConfig(
            activeForegroundColor: context.colorScheme.primary,
            icon: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Icon(Iconsax.map_1_copy),
            ),
            title: "Monitor",
          ),
        ),
        PersistentTabConfig(
          screen: SettingPage(),
          item: ItemConfig(
            activeForegroundColor: context.colorScheme.primary,
            icon: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Icon(Iconsax.setting_2_copy),
            ),
            title: "Setting",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          border: Border(
            top: BorderSide(
              color: context.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          color: context.colorScheme.surface,
        ),
      ),
    );
  }
}
