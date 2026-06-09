import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_resq/core/theme/app_theme.dart';
import 'package:road_resq/routes/app_router.dart';

class RoadResQApp extends ConsumerWidget {
  const RoadResQApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'RoadResQ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: goRouter,
    );
  }
}