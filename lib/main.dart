import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

// ============================================================
// PRODUCT MODEL
// ============================================================

class Product {
  final String name;
  final String brand;
  final String description;
  final double price;
  final String gsm;
  final String size;
  final String image;

  const Product({
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.gsm,
    required this.size,
    required this.image,
  });
}

// ============================================================
// PRODUCTS
// ============================================================

const List<Product> products = [
  Product(
    name: 'B2B Premium A4',
    brand: 'B2B',
    description: 'Smooth white A4 copier paper for everyday printing.',
    price: 210,
    gsm: '70 GSM',
    size: 'A4',
    image: 'assets/products/b2b.png',
  ),
  Product(
    name: 'JK Copier A4',
    brand: 'JK',
    description: 'Reliable A4 paper suitable for office and business use.',
    price: 230,
    gsm: '70 GSM',
    size: 'A4',
    image: 'assets/products/jk.png',
  ),
  Product(
    name: 'TNPL Copier A4',
    brand: 'TNPL',
    description: 'Quality copier paper with smooth printing performance.',
    price: 200,
    gsm: '70 GSM',
    size: 'A4',
    image: 'assets/products/tnpl.png',
  ),
];

// ============================================================
// APP
// ============================================================

class PaperHubApp extends StatelessWidget {
  const PaperHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF155EEF),
        ),
        fontFamily: 'Arial',
      ),
      home: const MainNavigation(),
    );
  }
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final Map<String, int> cart = {};

  int get cartCount {
    return cart.values.fold(0, (sum, value) => sum + value);
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
      final quantity = cart[product.name] ?? 0;

      if (quantity <= 1) {
        cart.remove(product.name);
      } else {
        cart[product.name] = quantity - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        cart: cart,
        onAdd: addProduct,
        onRemove: removeProduct,
        onOpenCart: () {
          setState(() {
            currentIndex = 2;
          });
        },
        onProductTap: (product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(
                product: product,
                quantity: cart[product.name] ?? 0,
                onAdd: () => addProduct(product),
              ),
            ),
          );
        },
      ),
      ProductsPage(
        cart: cart,
        onAdd: addProduct,
        onRemove: removeProduct,
        onProductTap: (product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(
                product: product,
                quantity: cart[product.name] ?? 0,
                onAdd: () => addProduct(product),
              ),
            ),
          );
        },
      ),
      CartPage(
        cart: cart,
        total: cartTotal,
        onAdd: addProduct,
        onRemove: removeProduct,
        onCheckout: () {
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

    return Scaffold(
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
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
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
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  final Map<String, int> cart;
  final Function(Product) onAdd;
  final Function(Product) onRemove;
  final VoidCallback onOpenCart;
  final Function(Product) onProductTap;

  const HomePage({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.onOpenCart,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF155EEF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAPER HUB',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Your trusted paper partner',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onOpenCart,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF2979FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Paper.\nBetter Business.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Quality A4 paper for offices,\nshops and businesses.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 7),
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
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search paper products...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shop by Brand',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 82,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: const [
                  BrandTile(
                    name: 'B2B',
                    icon: Icons.business_center_outlined,
                  ),
                  BrandTile(
                    name: 'JK',
                    icon: Icons.auto_awesome_outlined,
                  ),
                  BrandTile(
                    name: 'TNPL',
                    icon: Icons.eco_outlined,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${products.length} products',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];

                  return ProductCard(
                    product: product,
                    quantity: cart[product.name] ?? 0,
                    onAdd: () => onAdd(product),
                    onRemove: () => onRemove(product),
                    onTap: () => onProductTap(product),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BRAND TILE
// ============================================================

class BrandTile extends StatelessWidget {
  final String name;
  final IconData icon;

  const BrandTile({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: const Color(0xFF155EEF),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PRODUCTS PAGE
// ============================================================

class ProductsPage extends StatelessWidget {
  final Map<String, int> cart;
  final Function(Product) onAdd;
  final Function(Product) onRemove;
  final Function(Product) onProductTap;

  const ProductsPage({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text(
              'All Products',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];

                  return ProductCard(
                    product: product,
                    quantity: cart[product.name] ?? 0,
                    onAdd: () => onAdd(product),
                    onRemove: () => onRemove(product),
                    onTap: () => onProductTap(product),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PRODUCT CARD
// ============================================================

class ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 92,
              height: 105,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(17),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.description_outlined,
                      size: 45,
                      color: Color(0xFF155EEF),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.brand,
                      style: const TextStyle(
                        color: Color(0xFF155EEF),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    product.name,
                    style: const TextStyle(
    
