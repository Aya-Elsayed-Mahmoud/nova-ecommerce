import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../categories/screens/categories_screen.dart';
import '../../product_management/product_details.dart';

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
              height: 450,
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