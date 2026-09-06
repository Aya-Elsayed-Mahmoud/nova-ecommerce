import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'main_layout.dart';

// دالة موحدة لعمل الـ AppBar بالثلاث شُرط والشنطة مطابقة للفِگما
PreferredSizeWidget buildNovaAppBar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.menu, color: Colors.black), // الثلاث شُرط على الشمال
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black), // شنطة التسوق على اليمين
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmptyPlaceholderScreen(title: 'Cart')),
          );
        },
      ),
    ],
  );
}

// 1. الشاشة الأولى لوحدها (Personalization Complete)
class PersonalizationScreen extends StatelessWidget {
  const PersonalizationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text('Your NOVA is ready. ✨', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("We've created a shopping experience around your style.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f'), fit: BoxFit.cover),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E2C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLayout()),
                  );
                },
                child: const Text('Enter NOVA', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 2. الشاشة الرئيسية (Home)
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildNovaAppBar(context, title: 'NOVA'), // استخدام الـ AppBar الموحد هنا
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hello 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("We've curated something special for you.", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 16),

              // الصورة الكبيرة مع زرار Explore Collection
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1490481651871-ab68de25d43d'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('THE NEW EDIT', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // هينقلنا لتاب Explore (رقم 1) مع الحفاظ على الشريط السفلي
                        MainLayout.changeTab(context, 1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Explore Collection', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Picked for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) return const Center(child: CircularProgressIndicator());
                    if (state is HomeLoaded) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(product.imageUrl), fit: BoxFit.cover)))),
                                const SizedBox(height: 8),
                                Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text('EGP ${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. شاشة الأقسام (Explore)
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const CategoriesScreenContentOnly();
  }
}

class CategoriesScreenContentOnly extends StatelessWidget {
  const CategoriesScreenContentOnly({super.key});
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
      appBar: buildNovaAppBar(context, title: 'NOVA'), // استخدام الـ AppBar الموحد هنا أيضاً
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
                          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.35), BlendMode.darken),
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

// 4. شاشة عرض المنتجات مخصصة لكل قسم بمنتجات حقيقية تليق به
class GenericCategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  const GenericCategoryProductsScreen({super.key, required this.categoryName});

  List<Map<String, dynamic>> _getProductsForCategory(String category) {
    switch (category) {
      case 'Fashion':
        return [
          {'title': 'Structured Wool Blazer', 'price': '24,500', 'image': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35', 'rating': '4.9'},
          {'title': 'Oversized Linen Blazer', 'price': '18,200', 'image': 'https://images.unsplash.com/photo-1534126511673-b6899657816a', 'rating': '4.7'},
          {'title': 'Double-Breasted Wool', 'price': '21,000', 'image': 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8', 'rating': '4.8'},
          {'title': 'Single-Button Cady', 'price': '35,800', 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f', 'rating': '5.0'},
        ];
      case 'Sneakers':
        return [
          {'title': 'Nike Air Max Runner', 'price': '6,500', 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', 'rating': '4.9'},
          {'title': 'Urban Street Sneaker', 'price': '4,800', 'image': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77', 'rating': '4.6'},
          {'title': 'Classic White Kicks', 'price': '3,900', 'image': 'https://images.unsplash.com/photo-1560769629-975ec94e6a86', 'rating': '4.8'},
          {'title': 'High-Top Sport Edition', 'price': '7,200', 'image': 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2', 'rating': '4.7'},
        ];
      case 'Accessories':
        return [
          {'title': 'Chanel Bleu Perfume', 'price': '5,400', 'image': 'https://images.unsplash.com/photo-1523293182086-7651a899d37f', 'rating': '4.9'},
          {'title': 'Classic Leather Watch', 'price': '8,900', 'image': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9', 'rating': '4.8'},
          {'title': 'Designer Sunglasses', 'price': '4,200', 'image': 'https://images.unsplash.com/photo-1511499767150-a48a237f0083', 'rating': '4.5'},
          {'title': 'Minimalist Gold Ring', 'price': '2,500', 'image': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e', 'rating': '4.9'},
        ];
      case 'Tech':
        return [
          {'title': 'Wireless Noise Headphones', 'price': '9,800', 'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e', 'rating': '4.9'},
          {'title': 'Smart Watch Series X', 'price': '11,500', 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30', 'rating': '4.8'},
          {'title': 'Portable Bluetooth Speaker', 'price': '3,600', 'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1', 'rating': '4.7'},
          {'title': 'Minimalist Mechanical Keyboard', 'price': '4,500', 'image': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3', 'rating': '4.9'},
        ];
      case 'Home':
        return [
          {'title': 'Modern Ceramic Vase', 'price': '1,800', 'image': 'https://images.unsplash.com/photo-1513694203232-719a280e022f', 'rating': '4.8'},
          {'title': 'Aromatherapy Table Lamp', 'price': '3,200', 'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c', 'rating': '4.6'},
          {'title': 'Minimalist Indoor Plant Pot', 'price': '1,200', 'image': 'https://images.unsplash.com/photo-1485955900006-10f4d324d411', 'rating': '4.9'},
          {'title': 'Luxury Scented Candle', 'price': '950', 'image': 'https://images.unsplash.com/photo-1603006905003-be475563bc59', 'rating': '4.7'},
        ];
      default:
        return [
          {'title': 'Featured Item 1', 'price': '5,000', 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f', 'rating': '4.5'},
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
        title: Text(categoryName.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmptyPlaceholderScreen(title: 'Cart')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Curated selection of premium items in $categoryName.',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Expanded(
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
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(item['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.favorite_border, size: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('EGP ${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(item['rating'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ],
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

// 5. صفحات فارغة لباقي التبويبات (Wishlist & Profile)
class EmptyPlaceholderScreen extends StatelessWidget {
  final String title;
  const EmptyPlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(title, style: const TextStyle(color: Colors.black)),
      ),
      body: Center(child: Text('$title Screen (Reserved for team member)', style: const TextStyle(color: Colors.grey))),
    );
  }
}