
import 'package:flutter/material.dart';

import '../cart/cartScreen.dart';
import '../home/screens/MainScreens.dart';

class WishlistManager {
  static final ValueNotifier<List<ProductModel>> items = ValueNotifier([]);

  static void toggleFavorite(ProductModel product) {
    final list = List<ProductModel>.from(items.value);
    if (isFavorite(product)) {
      list.removeWhere((element) => element.title == product.title);
    } else {
      list.add(product);
    }
    items.value = list;
  }

  static bool isFavorite(ProductModel product) {
    return items.value.any((element) => element.title == product.title);
  }

  static void clearAll() {
    items.value = [];
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('My Wishlist',style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 18,
          ),),
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {
            Scaffold.of(context).openDrawer();
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
              },
            ),
          ],
        )
      ,
      body: ValueListenableBuilder<List<ProductModel>>(
        valueListenable: WishlistManager.items,
        builder: (context, wishlist, child) {
          if (wishlist.isEmpty) {
            return Center(
              child: Text(
                'Your wishlist is empty ✨',
                style: TextStyle(color: theme.hintColor, fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${wishlist.length} Items Saved',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.hintColor,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        WishlistManager.clearAll();
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    final product = wishlist[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  height: 240,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E2432),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Low Stock',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: CircleAvatar(
                                  backgroundColor: theme.cardColor,
                                  radius: 18,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.favorite,
                                      color: theme.colorScheme.error,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      WishlistManager.toggleFavorite(product);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Noir Edition',
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'EGP ${product.price}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                      ),
                                      onPressed: () {
                                        CartManager.addToCart(product);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Added to bag successfully!',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Add to Bag',
                                        style: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}