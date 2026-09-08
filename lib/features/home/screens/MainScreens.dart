import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Wishlist/wishlist.dart';
import '../../cart/cartScreen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../product_management/product_details.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/models/user_profile_model.dart';
import '../../profile/services/profile_api_service.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class ProductModel {
  final String title;
  final String price;
  final String imageUrl;

  ProductModel({
    required this.title,
    required this.price,
    required this.imageUrl,
  });
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
      ProductModel(
        title: 'Structured Wool Blazer',
        price: '24,500',
        imageUrl:
        'https://images.unsplash.com/photo-1594938298603-c8148c4dae35',
      ),
      ProductModel(
        title: 'Oversized Linen Blazer',
        price: '18,200',
        imageUrl:
        'https://img1.theiconic.com.au/1h0VLsBzN1PRVj0Hp9V2tGfFAzQ=/fit-in/1000x0/filters:fill(ffffff):quality(85):format(webp)/http%3A%2F%2Fstatic.theiconic.com.au%2Fp%2Faere-5556-8159311-1.jpg',
      ),
      ProductModel(
        title: 'Double-Breasted Wool',
        price: '21,000',
        imageUrl: 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8',
      ),
      ProductModel(
        title: 'Classic Silk Dress',
        price: '15,000',
        imageUrl:
        'https://images.unsplash.com/photo-1539109136881-3be0616acf4b',
      ),
      ProductModel(
        title: 'Tailored Trench Coat',
        price: '29,000',
        imageUrl:
        'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
      ),
      ProductModel(
        title: 'Urban Street Sneaker',
        price: '4,800',
        imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77',
      ),
    ];
    emit(HomeLoaded(products));
  }
}

PreferredSizeWidget buildNovaAppBar(
    BuildContext context, {
      required String title,
    }) {
  final theme = Theme.of(context);
  final iconColor = theme.iconTheme.color ?? theme.textTheme.bodyLarge?.color;

  return AppBar(
    backgroundColor: theme.scaffoldBackgroundColor,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: Icon(Icons.menu, color: iconColor),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        color: theme.textTheme.bodyLarge?.color,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.shopping_bag_outlined, color: iconColor),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
      ),
    ],
  );
}

class AppDrawer extends StatelessWidget {
  final UserProfileModel? profile;
  final int selectedIndex;
  final Function(int)? onDestinationSelected;

  const AppDrawer({
    super.key,
    this.profile,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.cardColor,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.scaffoldBackgroundColor,
              backgroundImage: (profile?.profileImageUrl != null)
                  ? NetworkImage(profile!.profileImageUrl!)
                  : null,
              child: (profile?.profileImageUrl == null)
                  ? Icon(
                Icons.person,
                size: 36,
                color: theme.hintColor,
              )
                  : null,
            ),
            accountName: Row(
              children: [
                Expanded(
                  child: Text(
                    profile?.fullName ?? 'NOVA User',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (profile?.isPremium == true) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_outlined,
                          size: 12,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            accountEmail: Text(
              profile?.email ?? 'welcome@nova.com',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  title: 'Home',
                  index: 0,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  title: 'Explore',
                  index: 1,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.favorite_border,
                  selectedIcon: Icons.favorite,
                  title: 'Wishlist',
                  index: 2,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag,
                  title: 'Cart',
                  index: 3,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  title: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'NOVA v2.4.1',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required int index,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isSelected = selectedIndex == index;

    final activeColor = isDarkMode ? Colors.white : Colors.black;
    final tileBgColor = isSelected
        ? (isDarkMode ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.08))
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: tileBgColor,
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? activeColor : theme.iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? activeColor : theme.textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (onDestinationSelected != null) {
            onDestinationSelected!(index);
          }
        },
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
  UserProfileModel? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await ProfileApiService().getProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
        });
      }
    } catch (_) {}
  }

  void setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _screens => [
    HomeScreenContent(profile: _userProfile),
    const CategoriesScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: AppDrawer(
        profile: _userProfile,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          } else {
            final targetTab = index > 3 ? index - 1 : index;
            setTab(targetTab);
          }
        },
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.cardColor,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor ?? theme.colorScheme.primary,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor ?? theme.hintColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final UserProfileModel? profile;

  const HomeScreenContent({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final firstName = profile?.fullName?.trim().isNotEmpty == true
        ? profile!.fullName!.trim().split(' ').first
        : 'User';

    return BlocProvider(
      create: (context) => HomeCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: buildNovaAppBar(context, title: 'NOVA'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $firstName 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                "We've curated something special for you.",
                style: TextStyle(color: theme.hintColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'NEW ARRIVALS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        MainLayout.changeTab(context, 1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explore Collection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Picked for you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
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
                                  builder: (context) =>
                                      ProductDetailsScreen(product: product),
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
                                        image: DecorationImage(
                                          image: NetworkImage(product.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'EGP ${product.price}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
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