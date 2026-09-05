import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

class Product {
  final String name;
  final String subtitle;
  final double price;

  const Product({
    required this.name,
    required this.subtitle,
    required this.price,
  });
}

const List<Product> products = [
  Product(
    name: 'B2B Paper',
    subtitle: 'Premium A4 • 70 GSM',
    price: 210,
  ),
  Product(
    name: 'JK Paper',
    subtitle: 'Premium A4 • 70 GSM',
    price: 230,
  ),
  Product(
    name: 'TNPL Paper',
    subtitle: 'Premium A4 • 70 GSM',
    price: 200,
  ),
];

class PaperHubApp extends StatelessWidget {
  const PaperHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF155EEF),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, int> cart = {};

  int get cartCount {
    return cart.values.fold(0, (sum, item) => sum + item);
  }

  double get cartTotal {
    double total = 0;

    for (final product in products) {
      total += product.price * (cart[product.name] ?? 0);
    }

    return total;
  }

  void addProduct(Product product) {
    setState(() {
      cart[product.name] = (cart[product.name] ?? 0) + 1;
    });
  }

  void removeProduct(Product product) {
    setState(() {
      final current = cart[product.name] ?? 0;

      if (current <= 1) {
        cart.remove(product.name);
      } else {
        cart[product.name] = current - 1;
      }
    });
  }

  Future<void> orderOnWhatsApp() async {
    if (cart.isEmpty) return;

    String message = 'Hello Paper Hub,\n\nI want to place an order:\n';

    for (final product in products) {
      final quantity = cart[product.name] ?? 0;

      if (quantity > 0) {
        message +=
            '\n${product.name} - $quantity ream × ₹${product.price.toInt()}';
      }
    }

    message +=
        '\n\nTotal: ₹${cartTotal.toInt()}'
        '\nPayment: Cash on Delivery';

    final uri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/917038343215',
      queryParameters: {
        'text': message,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void openCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CartSheet(
          cart: cart,
          total: cartTotal,
          onAdd: addProduct,
          onRemove: removeProduct,
          onOrder: orderOnWhatsApp,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PAPER HUB',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Quality Paper • Better Price',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: openCart,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF155EEF),
                    Color(0xFF4F8CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Trusted\nPaper Partner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Premium A4 paper at competitive prices.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Cash on Delivery Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Our Brands',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 88,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  brandCard('B2B'),
                  brandCard('JK'),
                  brandCard('TNPL'),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Products',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${products.length} Products',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...products.map(productCard),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 38,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why Paper Hub?',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Quality products • Competitive prices • Easy ordering',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: cartCount > 0
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: openCart,
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(
                    'View Cart • ₹${cartTotal.toInt()}',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget brandCard(String name) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget productCard(Product product) {
    final quantity = cart[product.name] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 42,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${product.price.toInt()} / ream',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          quantity == 0
              ? ElevatedButton(
                  onPressed: () => addProduct(product),
                  child: const Text('ADD'),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => removeProduct(product),
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => addProduct(product),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class CartSheet extends StatelessWidget {
  final Map<String, int> cart;
  final double total;
  final Function(Product) onAdd;
  final Function(Product) onRemove;
  final VoidCallback onOrder;

  const CartSheet({
    super.key,
    required this.cart,
    required this.total,
    required this.onAdd,
    required this.onRemove,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
            ...products
                .where((product) => (cart[product.name] ?? 0) > 0)
                .map(
              (product) {
                final quantity = cart[product.name] ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onRemove(product),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () => onAdd(product),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${total.toInt()}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Payment: Cash on Delivery',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onOrder,
                icon: const Icon(Icons.chat),
                label: const Text(
                  'Order on WhatsApp',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
