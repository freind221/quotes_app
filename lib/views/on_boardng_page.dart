import 'package:flutter/material.dart';
import 'package:quota_app/utilis/widgets/custom_button.dart';
import 'package:quota_app/views/author_quotes.dart';
import 'package:quota_app/views/favorite_quota.dart';
import 'package:quota_app/views/search_quota.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, AuthorQuotes.routName);
                },
                text: 'Author Quota'),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, SearchQouta.routName);
                },
                text: 'Search any Quota'),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, FavQuota.routeName);
                },
                text: 'Favorite Quota'),
          ],
        ),
      )),
    );
  }
}
