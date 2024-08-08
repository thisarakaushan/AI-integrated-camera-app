import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class RecentSearchesPage extends StatelessWidget {
  const RecentSearchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Define a list of categories dynamically
    final categories = [
      'Previous 30 Days',
      'Previous 7 Days',
      'Today',
      // Add more categories as needed
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF051338),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add spacing to move the TopRowWidget
            SizedBox(height: 20),

            TopRowWidget(
              onMenuPressed: () {
                Navigator.pop(context);
              },
              onEditPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/main-page',
                );
              },
            ),

            // Move the Recent Searches text
            Padding(
              padding: const EdgeInsets.all(16), // top padding
              child: Center(
                child: Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, // Set the text color to white
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey, // Grey line between categories
                  thickness: 1, // Line thickness
                ),
                itemBuilder: (context, index) {
                  return _buildCategory(categories[index]);
                },
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
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
