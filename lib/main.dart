import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quota_app/providers/app_provider.dart';
import 'package:quota_app/views/author_quotes.dart';
import 'package:quota_app/views/favorite_quota.dart';
import 'package:quota_app/views/search_quota.dart';
import 'package:quota_app/views/splash.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: ((_) => AppProvider())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        SearchQouta.routName: (context) => const SearchQouta(),
        FavQuota.routeName: (context) => const FavQuota(),
        AuthorQuotes.routName: (context) => const AuthorQuotes(),
      },
    );
  }
}
