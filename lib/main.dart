import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

class Product {
  final String name;
  final String brand;
  final int price;
  final IconData icon;
  final String description;

  const Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.icon,
    required this.description,
  });
}

const products = [
  Product(
    name: 'B2B Paper',
    brand: 'B2B',
    price: 210,
    icon: Icons.description_rounded,
    description: 'Premium quality A4 paper suitable for office and business use.',
  ),
  Product(
    name: 'JK Paper',
    brand: 'JK',
    price: 230,
    icon: Icons.article_rounded,
    description: 'Reliable quality A4 paper for printing, copying and daily use.',
  ),
  Product(
    name: 'TNPL Paper',
    brand: 'TNPL',
    price: 200,
    icon: Icons.note_alt_rounded,
    description: 'Quality A4 paper with smooth printing performance.',
  ),
];

class PaperHubApp extends StatefulWidget {
  const PaperHubApp({super.key});

  @override
  State<PaperHubApp> createState() => _PaperHubAppState();
}

class _PaperHubAppState extends State<PaperHubApp> {
  int currentIndex = 0;
  final Map<Product, int> cart = {};

  void addToCart(Product product) {
    setState(() {
      cart[product] = (cart[product] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void changeQuantity(Product product, int change) {
    setState(() {
      final quantity = (cart[product] ?? 0) + change;

      if (quantity <= 0) {
        cart.remove(product);
      } else {
        cart[product] = quantity;
      }
    });
  }

  int get cartCount {
    return cart.values.fold(0, (sum, item) => sum + item);
  }

  int get cartTotal {
    int total = 0;

    cart.forEach((product, quantity) {
      total += product.price * quantity;
    });

    return total;
  }

  void openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: product,
          onAdd: () => addToCart(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        products: products,
        onProductTap: openProduct,
        onAdd: addToCart,
      ),
      ProductsPage(
        products: products,
        onProductTap: openProduct,
        onAdd: addToCart,
      ),
      CartPage(
        cart: cart,
        total: cartTotal,
        onChange: changeQuantity,
        onCheckout: () {
          if (cart.isEmpty) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutPage(
                cart: cart,
                total: cartTotal,
              ),
            ),
          );
        },
      ),
      const AccountPage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function(Product) onAdd;

  const HomePage({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paper Hub',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Quality paper. Better business.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.notifications_none),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business\nPaper Supplies',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Premium A4 papers at competitive prices.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'COD Available',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 85,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 58,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search paper or brand...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Popular Brands',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: products.map((product) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        product.brand,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Products',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Best Value',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...products.map(
              (product) => ProductCard(
                product: product,
                onTap: () => onProductTap(product),
                onAdd: () => onAdd(product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function(Product) onAdd;

  const ProductsPage({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'All Products',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose the paper that fits your business.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ...products.map(
            (product) => ProductCard(
              product: product,
              onTap: () => onProductTap(product),
              onAdd: () => onAdd(product),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 7),
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                product.icon,
                size: 44,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '₹${product.price} / ream',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAdd,
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
              ),
              icon: Icon(
                Icons.add_shopping_cart,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 230,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                product.icon,
                size: 110,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              product.brand,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₹${product.price}',
              style: TextStyle(
                fontSize: 26,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Product Information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.description,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 22),
            const InfoBox(
              icon: Icons.local_shipping_outlined,
              title: 'Delivery',
              text: 'Doorstep delivery available.',
            ),
            const InfoBox(
              icon: Icons.payments_outlined,
              title: 'Payment',
              text: 'Cash on Delivery available.',
            ),
            const InfoBox(
              icon: Icons.verified_outlined,
              title: 'Quality',
              text: 'Business-ready paper quality.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  onAdd();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
   
