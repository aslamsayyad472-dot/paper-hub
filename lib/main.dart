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

const products = [
  Product(name: 'B2B Paper', subtitle: 'Premium A4 • 70 GSM', price: 210),
  Product(name: 'JK Paper', subtitle: 'Premium A4 • 70 GSM', price: 230),
  Product(name: 'TNPL Paper', subtitle: 'Premium A4 • 70 GSM', price: 200),
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
        fontFamily: 'Arial',
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

  void addToCart(Product product) {
    setState(() {
      cart[product.name] = (cart[product.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int get cartCount {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get cartTotal {
    double total = 0;

    for (final product in products) {
      total += product.price * (cart[product.name] ?? 0);
    }

    return total;
  }

  Future<void> orderOnWhatsApp() async {
    if (cart.isEmpty) return;

    String message = 'Hello Paper Hub,%0A%0AI want to place an order:%0A';

    for (final product in products) {
      final quantity = cart[product.name] ?? 0;

      if (quantity > 0) {
        message +=
            '%0A${product.name} - $quantity ream x ₹${product.price.toInt()}';
      }
    }

    message +=
        '%0A%0ATotal: ₹${cartTotal.toInt()}%0A%0APayment: Cash on Delivery';

    final url = Uri.parse(
      'https://wa.me/917038343215?text=$message',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => CartSheet(
                      cart: cart,
                      products: products,
                      total: cartTotal,
                      onOrder: orderOnWhatsApp,
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 7,
                  top: 5,
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
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF155EEF),
                    Color(0xFF4F8CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Trusted\nPaper Partner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
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
                        Icons
