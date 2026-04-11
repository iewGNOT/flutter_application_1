import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';

final class LifeGachaApp extends ConsumerWidget {
  const LifeGachaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'LifeGacha',
      debugShowCheckedModeBanner: false,
      theme: LifeGachaTheme.light(),
      darkTheme: LifeGachaTheme.dark(),
      routerConfig: router,
    );
  }
}
