import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class ProductModel {
  final String title;
  final String price;
  final String imageUrl;
  ProductModel({required this.title, required this.price, required this.imageUrl});
}

class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  HomeLoaded(this.products);
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void fetchProducts() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    final List<ProductModel> products = [
      ProductModel(title: 'Structured Wool Blazer', price: '24,500', imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35'),
      ProductModel(title: 'Oversized Linen Blazer', price: '18,200', imageUrl: 'https://images.unsplash.com/photo-1534126511673-b6899657816a'),
      ProductModel(title: 'Double-Breasted Wool', price: '21,000', imageUrl: 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8'),
      ProductModel(title: 'Classic Silk Dress', price: '15,000', imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b'), // تم تغيير صورة البنت اللي بالأصفر هنا لصورة فستان فخمة
      ProductModel(title: 'Tailored Trench Coat', price: '29,000', imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d'),
      ProductModel(title: 'Urban Street Sneaker', price: '4,800', imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77'),
    ];
    emit(HomeLoaded(products));
  }
}

void main() {
  runApp(const NovaApp());
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova E-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PersonalizationScreen(),
    );
  }
}

PreferredSizeWidget buildNovaAppBar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.menu, color: Colors.black),
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
        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
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
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E2C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
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

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static void changeTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainLayoutState>();
    state?.setTab(index);
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const CategoriesScreen(),
    const EmptyPlaceholderScreen(title: 'Wishlist'),
    const EmptyPlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildNovaAppBar(context, title: 'NOVA'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hello 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("We've curated something special for you.", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 16),
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
                    const Text('NEW ARRIVALS', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), // تم تعديل الاسم هنا
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        MainLayout.changeTab(context, 1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text('EGP ${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
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

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('PRODUCT DETAILS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('EGP ${product.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Crafted with premium materials to ensure maximum comfort and timeless style. Perfect for any modern wardrobe aesthetic.', style: TextStyle(color: Colors.grey, height: 1.5)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E2C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart successfully!')),
                  );
                },
                child: const Text('Add to Bag', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        title: Text(categoryName.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
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
                      image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(height: 2),
                Text('EGP ${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
      body: Center(child: Text('$title Screen', style: const TextStyle(color: Colors.grey))),
    );
  }
}