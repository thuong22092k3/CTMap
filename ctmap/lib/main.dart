import 'package:ctmap/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/pages/routes/routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Mulish'), // Font cho bodyText1
          bodyMedium: TextStyle(fontFamily: 'Mulish'), // Font cho bodyText2
          displayLarge: TextStyle(fontFamily: 'Mulish'), // Font cho headline1
        ),
        colorScheme: ColorScheme.fromSeed(
          primary: AppColors.red,
          seedColor: AppColors.blue
        ),
        scaffoldBackgroundColor: AppColors.white,
      ),
    );
  }
}
