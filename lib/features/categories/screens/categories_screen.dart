import 'package:flutter/material.dart';

import '../../home/screens/MainScreens.dart';
import '../../product/screens/category_products.dart';


class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'title': 'Fashion', 'image': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d'},
      {'title': 'Sneakers', 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'},
      {'title': 'Accessories', 'image': 'https://images.unsplash.com/photo-1523293182086-7651a899d37f'},
      {'title': 'Tech', 'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'},
      {'title': 'Home', 'image': 'https://images.unsplash.com/photo-1513694203232-719a280e022f'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNovaAppBar(context, title: 'NOVA'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Explore', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Curated collections for the modern aesthetic.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenericCategoryProductsScreen(categoryName: cat['title']!),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: NetworkImage(cat['image']!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat['title']!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const Text('Shop the latest >', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
