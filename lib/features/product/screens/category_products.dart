import 'package:flutter/material.dart';

import '../../home/screens/MainScreens.dart';
import '../../product_management/product_details.dart';

class GenericCategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  const GenericCategoryProductsScreen({super.key, required this.categoryName});

  List<ProductModel> _getProductsForCategory(String category) {
    switch (category) {
      case 'Fashion':
        return [
          ProductModel(title: 'Structured Wool Blazer', price: '24,500', imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35'),
          ProductModel(title: 'Oversized Linen Blazer', price: '18,200', imageUrl: 'https://img1.theiconic.com.au/1h0VLsBzN1PRVj0Hp9V2tGfFAzQ=/fit-in/1000x0/filters:fill(ffffff):quality(85):format(webp)/http%3A%2F%2Fstatic.theiconic.com.au%2Fp%2Faere-5556-8159311-1.jpg'),
          ProductModel(title: 'Classic Silk Dress', price: '15,000', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f'),
          ProductModel(title: 'Tailored Trench Coat', price: '29,000', imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d'),
        ];
      case 'Sneakers':
        return [
          ProductModel(title: 'Nike Air Max Runner', price: '6,500', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'),
          ProductModel(title: 'Urban Street Sneaker', price: '4,800', imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77'),
          ProductModel(title: 'Classic White Trainer', price: '3,900', imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a'),
          ProductModel(title: 'High-Top Runner', price: '7,200', imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5'),
        ];
      case 'Accessories':
        return [
          ProductModel(title: 'Chanel Bleu Perfume', price: '8,500', imageUrl: 'https://images.unsplash.com/photo-1523293182086-7651a899d37f'),
          ProductModel(title: 'Minimalist Gold Watch', price: '12,000', imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9'),
          ProductModel(title: 'Leather Crossbody Bag', price: '9,400', imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa'),
          ProductModel(title: 'Designer Sunglasses', price: '6,100', imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083'),
        ];
      case 'Tech':
        return [
          ProductModel(title: 'Over-Ear Wireless Headphones', price: '14,000', imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'),
          ProductModel(title: 'Smart Sport Watch', price: '9,900', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30'),
          ProductModel(title: 'Portable Mini Speaker', price: '3,500', imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1'),
        ];
      case 'Home':
        return [
          ProductModel(title: 'Modern Ceramic Vase', price: '2,400', imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f'),
          ProductModel(title: 'Aesthetic Table Lamp', price: '4,200', imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c'),
          ProductModel(title: 'Scented Soy Candle', price: '1,200', imageUrl: 'https://images.unsplash.com/photo-1603006905003-be475563bc59'),
        ];
      default:
        return [
          ProductModel(title: 'Featured Item', price: '5,000', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final products = _getProductsForCategory(categoryName);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          categoryName.toUpperCase(),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surfaceContainerHighest : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'EGP ${product.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}