import 'package:flutter/material.dart';
import 'package:famora/core/themes/extensions/alignment_ext.dart';
import 'package:famora/core/themes/extensions/border_radius_ext.dart';
import 'package:famora/core/themes/extensions/spacing_ext.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/features/auth/presentation/widgets/login_widget.dart';
import 'package:famora/features/auth/presentation/widgets/register_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AuthPage extends StatefulHookConsumerWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: 16.pa,
                child: Column(
                  crossAxisAlignment: context.crossStart,
                  children: [
                    Container(
                      padding: 16.pa,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: context.colorScheme.onSurface.withValues(
                      //       alpha: 0.2,
                      //     ),
                      //   ),
                      //   borderRadius: context.brFull,
                      // ),
                      // child: Icon(Iconsax.arrow_left_copy),
                    ),
                    Text(
                      'Buat akun dan amankan Keluargamu',
                      style: context.textTheme.displaySmall,
                    ),
                    Text(
                      'Daftar dan buat keluargamu aman dari kejahatan',
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: context.brOnlyTopXl,
                    color: context.colorScheme.surface,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: 4.pa,
                        margin: 16.pa,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: context.brFull,
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: context.colorScheme.primary,
                          ),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: context.colorScheme.surface,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Masuk'),
                            Tab(text: 'Daftar'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: TabBarView(
                          controller: _tabController,
                          children: [LoginWidget(), RegisterWidget()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
