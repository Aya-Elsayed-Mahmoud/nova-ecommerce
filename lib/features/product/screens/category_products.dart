import 'package:flutter/material.dart';

class GenericCategoryProductsScreen extends StatelessWidget {
final String categoryName;
const GenericCategoryProductsScreen({super.key, required this.categoryName});

List<Map<String, dynamic>> _getProductsForCategory(String category) {
switch (category) {
case 'Fashion':
return [
{'title': 'Structured Wool Blazer', 'price': '24,500', 'image': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35'},
{'title': 'Oversized Linen Blazer', 'price': '18,200', 'image': 'https://images.unsplash.com/photo-1534126511673-b6899657816a'},
{'title': 'Classic Silk Dress', 'price': '15,000', 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f'},
{'title': 'Tailored Trench Coat', 'price': '29,000', 'image': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d'},
];
case 'Sneakers':
return [
{'title': 'Nike Air Max Runner', 'price': '6,500', 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'},
{'title': 'Urban Street Sneaker', 'price': '4,800', 'image': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77'},
{'title': 'Classic White Trainer', 'price': '3,900', 'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a'},
{'title': 'High-Top Runner', 'price': '7,200', 'image': 'https://images.unsplash.com/photo-1608231387042-66d1773070a5'},
];
case 'Accessories':
return [
{'title': 'Chanel Bleu Perfume', 'price': '8,500', 'image': 'https://images.unsplash.com/photo-1523293182086-7651a899d37f'},
{'title': 'Minimalist Gold Watch', 'price': '12,000', 'image': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9'},
{'title': 'Leather Crossbody Bag', 'price': '9,400', 'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa'},
{'title': 'Designer Sunglasses', 'price': '6,100', 'image': 'https://images.unsplash.com/photo-1511499767150-a48a237f0083'},
];
case 'Tech':
return [
{'title': 'Over-Ear Wireless Headphones', 'price': '14,000', 'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'},
{'title': 'Smart Sport Watch', 'price': '9,900', 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30'},
{'title': 'Portable Mini Speaker', 'price': '3,500', 'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1'},
];
case 'Home':
return [
{'title': 'Modern Ceramic Vase', 'price': '2,400', 'image': 'https://images.unsplash.com/photo-1513694203232-719a280e022f'},
{'title': 'Aesthetic Table Lamp', 'price': '4,200', 'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c'},
{'title': 'Scented Soy Candle', 'price': '1,200', 'image': 'https://images.unsplash.com/photo-1603006905003-be475563bc59'},
];
default:
return [
{'title': 'Featured Item', 'price': '5,000', 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f'},
];
}
}

@override
Widget build(BuildContext context) {
  final products = _getProductsForCategory(categoryName);
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(categoryName.toUpperCase(), style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5)),
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
          final item = products[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: NetworkImage(item['image']), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(item['title'], maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13)),
              const SizedBox(height: 2),
              Text('EGP ${item['price']}', style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          );
        },
      ),
    ),
  );
}}