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

  const Product(this.name, this.brand, this.price, this.icon);
}

const List<Product> products = [
  Product('B2B Paper', 'B2B', 210, Icons.description),
  Product('JK Paper', 'JK', 230, Icons.article),
  Product('TNPL Paper', 'TNPL', 200, Icons.note_alt),
];

class PaperHubApp extends StatefulWidget {
  const PaperHubApp({super.key});

  @override
  State<PaperHubApp> createState() => _PaperHubAppState();
}

class _PaperHubAppState extends State<PaperHubApp> {
  int tab = 0;
  final Map<Product, int> cart = {};

  int get total {
    int value = 0;
    cart.forEach((p, q) {
      value += p.price * q;
    });
    return value;
  }

  int get count {
    int value = 0;
    cart.forEach((p, q) {
      value += q;
    });
    return value;
  }

  void add(Product p) {
    setState(() {
      cart[p] = (cart[p] ?? 0) + 1;
    });
  }

  void remove(Product p) {
    setState(() {
      final q = (cart[p] ?? 0) - 1;
      if (q <= 0) {
        cart.remove(p);
      } else {
        cart[p] = q;
      }
    });
  }

  void details(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsPage(
          product: p,
          add: () => add(p),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onAdd: add,
        onDetails: details,
      ),
      ProductsPage(
        onAdd: add,
        onDetails: details,
      ),
      CartPage(
        cart: cart,
        total: total,
        onAdd: add,
        onRemove: remove,
        onCheckout: () {
          if (cart.isEmpty) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutPage(
                cart: cart,
                total: total,
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
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color(0xffF5F7FB),
      ),
      home: Scaffold(
        body: pages[tab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) {
            setState(() {
              tab = i;
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
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: const Icon(Icons.shopping_cart_outlined),
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
  final Function(Product) onAdd;
  final Function(Product) onDetails;

  const HomePage({
    super.key,
    required this.onAdd,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.blue,
                      Color(0xff1565C0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paper Hub',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Quality paper for your business',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff0D47A1),
                  Color(0xff1976D2),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Paper\nFor Business',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'B2B • JK • TNPL',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Cash on Delivery Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 75,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search paper or brand...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Our Brands',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              brandBox('B2B'),
              brandBox('JK'),
              brandBox('TNPL'),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Popular Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ProductCard(
            product: products[0],
            onAdd: () => onAdd(products[0]),
            onDetails: () => onDetails(products[0]),
          ),
          ProductCard(
            product: products[1],
            onAdd: () => onAdd(products[1]),
            onDetails: () => onDetails(products[1]),
          ),
          ProductCard(
            product: products[2],
            onAdd: () => onAdd(products[2]),
            onDetails: () => onDetails(products[2]),
          ),
        ],
      ),
    );
  }

  Widget brandBox(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  final Function(Product) onAdd;
  final Function(Product) onDetails;

  const ProductsPage({
    super.key,
    required this.onAdd,
    required this.onDetails,
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
          const SizedBox(height: 5),
          const Text(
            'Choose your preferred paper brand.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ProductCard(
            product: products[0],
            onAdd: () => onAdd(products[0]),
            onDetails: () => onDetails(products[0]),
          ),
          ProductCard(
            product: products[1],
            onAdd: () => onAdd(products[1]),
            onDetails: () => onDetails(products[1]),
          ),
          ProductCard(
            product: products[2],
            onAdd: () => onAdd(products[2]),
            onDetails: () => onDetails(products[2]),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onDetails;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetails,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                product.icon,
                size: 45,
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
                    ),
                  ),
                  const SizedBox(height: 5),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(
                Icons.add_shopping_cart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Product product;
  final VoidCallback add;

  const DetailsPage({
    super.key,
    required this.product,
    required this.add,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
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
          const SizedBox(height: 10),
          Text(
            '₹${product.price} / ream',
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Premium quality paper suitable for office printing, '
            'photocopying and daily business requirements.',
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const InfoTile(
            icon: Icons.local_shipping,
            text: 'Doorstep Delivery',
          ),
          const InfoTile(
            icon: Icons.payments,
            text: 'Cash on Delivery',
          ),
          const InfoTile(
            icon: Icons.verified,
            text: 'Quality Paper',
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                add();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text(
                'Add to Cart',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final Map<Product, int> cart;
  final int total;
  final Function(Product) onAdd;
  final Function(Product) onRemove;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cart,
    required this.total,
    required this.onAdd,
    required this.onRemove,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Cart',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: cart.entries.map((entry) {
                final p = entry.key;
                final q = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        p.icon,
                        size: 38,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('₹${p.price} / ream'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => onRemove(p),
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      ),
                      Text(
                        '$q',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => onAdd(p),
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),
       
