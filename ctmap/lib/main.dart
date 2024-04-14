import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Mulish'), // Font cho bodyText1
          bodyText2: TextStyle(fontFamily: 'Mulish'), // Font cho bodyText2
          headline1: TextStyle(fontFamily: 'Mulish'), // Font cho headline1
          // Thêm các phong cách font khác tùy theo nhu cầu
        ),
      ),
    );
  }
}
