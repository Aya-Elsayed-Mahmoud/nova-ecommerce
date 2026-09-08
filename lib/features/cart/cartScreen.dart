

// Cart-------------
import 'package:flutter/material.dart';

import '../categories/screens/categories_screen.dart';
import '../home/screens/MainScreens.dart';
import '../orderConfirmation/OrderConfirmationScreen.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  final String color;

  CartItem({required this.product, this.quantity = 1, this.color = 'Onyx'});
}

// مدير السلة العام لتحديث البيانات ديناميكياً
class CartManager {
  static final ValueNotifier<List<CartItem>> items = ValueNotifier([]);

  static void addToCart(ProductModel product, {String color = 'Onyx'}) {
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere(
          (element) => element.product.title == product.title,
    );

    if (index >= 0) {
      list[index].quantity++;
    } else {
      list.add(CartItem(product: product, color: color));
    }
    items.value = list;
  }

  static void incrementQuantity(int index) {
    final list = List<CartItem>.from(items.value);
    list[index].quantity++;
    items.value = list;
  }

  static void decrementQuantity(int index) {
    final list = List<CartItem>.from(items.value);
    if (list[index].quantity > 1) {
      list[index].quantity--;
    } else {
      list.removeAt(index);
    }
    items.value = list;
  }

  static void removeItem(int index) {
    final list = List<CartItem>.from(items.value);
    list.removeAt(index);
    items.value = list;
  }

  static void clearAll() {
    items.value = [];
  }

  static double get subtotal {
    return items.value.fold(0, (sum, item) {
      final priceClean =
          double.tryParse(item.product.price.replaceAll(',', '')) ?? 0;
      return sum + (priceClean * item.quantity);
    });
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('NOVA',style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: 18,
        ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartManager.items,
        builder: (context, cartItems, child) {
          // الشاشة الثانية: في حالة الشنطة فارغة
          if (cartItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 260,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 70,
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Your bag is empty.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover pieces that define your style.',
                      style: TextStyle(color: theme.hintColor, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoriesScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Explore New Arrivals',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // الشاشة الأولى: حالة وجود عناصر في السلة
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Cart',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${cartItems.length} items',
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => CartManager.clearAll(),
                            child: Text(
                              'Clear All',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Cart Items List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.dividerColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.product.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.product.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                CartManager.removeItem(index),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: theme.hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Color: ${item.color}',
                                        style: TextStyle(
                                          color: theme.hintColor,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'EGP ${item.product.price}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: textColor,
                                            ),
                                          ),

                                          // Counter Widget
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme.scaffoldBackgroundColor,
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      CartManager.decrementQuantity(
                                                        index,
                                                      ),
                                                  child: Text(
                                                    ' − ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  child: Text(
                                                    '${item.quantity}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 13,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      CartManager.incrementQuantity(
                                                        index,
                                                      ),
                                                  child: Text(
                                                    ' + ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                      const SizedBox(height: 20),

                      // Order Summary Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORDER SUMMARY',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'EGP ${CartManager.subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping',
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Calculated at next step',
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Taxes',
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'EGP 0.00',
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 24, color: theme.dividerColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  'EGP ${CartManager.subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Confirm Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      CartManager.clearAll();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderConfirmationScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
