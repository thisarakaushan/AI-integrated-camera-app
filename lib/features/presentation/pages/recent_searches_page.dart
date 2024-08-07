import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class RecentSearchesPage extends StatelessWidget {
  const RecentSearchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopRowWidget(
              onMenuPressed: () {
                Navigator.pop(context); // Close the recent searches page
              },
              onEditPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/main-page',
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCategory('Previous 30 Days'),
                  _buildCategory('Previous 7 Days'),
                  _buildCategory('Today'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
