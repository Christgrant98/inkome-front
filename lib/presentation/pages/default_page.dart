import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error 404: Page not found'),
      ),
      body: const Center(
        child: Text('Oops! The page you are looking for does not exist.'),
      ),
    );
  }
}
