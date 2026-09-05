import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

const String whatsappNumber = '917038343215';

class Product {
  final String name;
  final String brand;
  final String description;
  final int price;
  final IconData icon;

  const Product({
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.icon,
  });
}

const products = [
  Product(
    name: 'B2B A4 Paper',
    brand: 'B2B',
    description: '70 GSM • A4 • Premium Quality',
    price: 210,
    icon: Icons.description,
  ),
  Product(
    name: 'JK A4 Paper',
    brand: 'JK',
    description: '70 GSM • A4 • Premium Quality',
    price: 230,
    icon: Icons.article,
  ),
  Product(
    name: 'TNPL A4 Paper',
    brand: 'TNPL',
    description: '70 GSM • A4 • Premium Quality',
    price: 200,
    icon: Icons.note_alt,
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
          seedColor: const Color(0xff174EA6),
        ),
        scaffoldBackgroundColor: const Color(0xffF5F7FB),
        fontFamily: 'sans',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final Map<String, int> cart = {};

  int get cartCount {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  int get cartTotal {
    int total = 0;

    for (final product in products) {
      total += (cart[product.name] ?? 0) * product.price;
    }

    return total;
  }

  void addProduct(Product product) {
    setState(() {
      cart[product.name] = (cart[product.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void decreaseProduct(Product product) {
    final quantity = cart[product.name] ?? 0;

    if (quantity <= 1) {
      setState(() {
        cart.remove(product.name);
      });
    } else {
      setState(() {
        cart[product.name] = quantity - 1;
      });
    }
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(
          cart: cart,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        cart: cart,
        cartCount: cartCount,
        cartTotal: cartTotal,
        onAdd: addProduct,
        onDecrease: decreaseProduct,
        onCart: openCart,
      ),
      ProductsPage(
        cart: cart,
        onAdd: addProduct,
        onDecrease: decreaseProduct,
      ),
      OrdersPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Map<String, int> cart;
  final int cartCount;
  final int cartTotal;
  final Function(Product) onAdd;
  final Function(Product) onDecrease;
  final VoidCallback onCart;

  const HomePage({
    super.key,
    required this.cart,
    required this.cartCount,
    required this.cartTotal,
    required this.onAdd,
    required this.onDecrease,
    required this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xff174EA6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Paper Hub',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: onCart,
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 28,
                        ),
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 3,
                          top: 2,
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
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff123B7A),
                    Color(0xff2475D9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(.12),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREMIUM PAPER',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Quality paper.\nBetter business.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Wholesale A4 paper at competitive prices.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Our Brands',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${products.length} Products',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];

                  return ProductCard(
                    product: product,
                    quantity: cart[product.name] ?? 0,
                    onAdd: () => onAdd(product),
                    onDecrease: () => onDecrease(product),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),

          if (cartCount > 0)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Color(0xff174EA6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$cartCount items • ₹$cartTotal',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: onCart,
                      child: const Text('View Cart'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  final Map<String, int> cart;
  final Function(Product) onAdd;
  final Function(Product) onDecrease;

  const ProductsPage({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onDecrease,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((product) {
      return product.name.toLowerCase().contains(search.toLowerCase()) ||
          product.brand.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 20, 18, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search paper or brand...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];

                return ProductCard(
                  product: product,
                  quantity: widget.cart[product.name] ?? 0,
                  onAdd: () => widget.onAdd(product),
                  onDecrease: () => widget.onDecrease(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onDecrease;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: const Color(0xffEAF2FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                product.icon,
                size: 38,
                color: const Color(0xff174EA6),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: const TextStyle(
                      color: Color(0xff174EA6),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            quantity == 0
                ? FilledButton(
                    onPressed: onAdd,
                    child: const Text('ADD'),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffEAF2FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: onDecrease,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: onAdd,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Map<String, int> cart;
  final VoidCallback onChanged;

  const CartPage({
    super.key,
    required this.cart,
    required this.onChanged,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get total {
    int value = 0;

    for (final product in products) {
      value += (widget.cart[product.name] ?? 0) * product.price;
    }

    return value;
  }

  int get count {
    return widget.cart.values.fold(0, (a, b) => a + b);
  }

  void add(Product product) {
    setState(() {
      widget.cart[product.name] =
          (widget.cart[product.name] ?? 0) + 1;
    });
    widget.onChanged();
  }

  void remove(Product product) {
    final quantity = widget.cart[product.name] ?? 0;

    setState(() {
      if (quantity <= 1) {
        widget.cart.remove(product.name);
      } else {
        widget.cart[product.name] = quantity - 1;
      }
    });

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final selected = products
        .where((p) => (widget.cart[p.name] ?? 0) > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: selected.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: selected.length,
                    itemBuilder: (context, index) {
                      final product = selected[index];
                      final quantity = widget.cart[product.name]!;

                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xffEAF2FF),
                            child: Icon(
                              product.icon,
                              color: const Color(0xff174EA6),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '₹${product.price} × $quantity = ₹${product.price * quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => remove(product),
                                icon: const Icon(Icons.remove_circle),
                              ),
                              Text('$quantity'),
                              IconButton(
                                onPressed: () => add(product),
                                icon: const Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    22,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '₹$total',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutPage(
                                  cart: widget.cart,
                                  total: total,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(
                            'Checkout • $count Items',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final Map<String, int> cart;
  final int total;

  const CheckoutPage({
    super.key,
    required this.cart,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String buildMessage() {
    final lines = <String>[
      '*🧾 PAPER HUB ORDER*',
      '',
      '━━━━━━━━━━━━━━━━',
      '*Order Details*',
      '━━━━━━━━━━━━━━━━',
    ];

    for (final product in products) {
      final quantity = widget.cart[product.name] ?? 0;

      if (quantity > 0) {
        lines.add(
          '${product.name} × $quantity = ₹${product.price * quantity}',
        );
      }
    }

    lines.addAll([
      '',
      '━━━━━━━━━━━━━━━━',
      '*TOTAL: ₹${widget.total}*',
      'Payment: Cash on Delivery',
      '━━━━━━━━━━━━━━━━',
      '',
      '*Customer Details*',
      'Name: ${nameController.text.trim()}',
      'Mobile: ${phoneController.text.trim()}',
      'Address: ${addressController.text.trim()}',
      '',
      'Thank you for ordering from Paper Hub.',
    ]);

    return lines.join('\n');
  }

  Future<void> sendWhatsApp() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill Name, Mobile Number and Address',
          ),
        ),
      );
      return;
    }

    final url = Uri.parse(
      'https://wa.me/$whatsappNumber'
      '?text=${Uri.encodeComponent(buildMessage())}',
    );

    final opened = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp could not be opened'),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = products
        .where((p) => (widget.cart[p.name] ?? 0) > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ...selected.map(
                  (product) {
                    final quantity = widget.cart[product.name]!;
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${product.name} × $quantity',
                            ),
                          ),
                          Text(
                            '₹${product.price * quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 25),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Grand Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '₹${widget.total}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: Colors.green,
                    ),
                    SizedBox(width: 6),
                    Text('Cash on Delivery'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Customer Name',
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: addressController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Complete Delivery Address',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 65),
                child: Icon(Icons.location_on_outlined),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 55,
            child: FilledButton.icon(
              onPressed: sendWhatsApp,
              icon: const Icon(Icons.chat),
              label: const Text(
                'PLACE ORDER ON WHATSAPP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Your order will be sent directly to Paper Hub.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: const Color(0xffEAF2FF),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  size: 45,
                  color: Color(0xff174EA6),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your WhatsApp orders will be confirmed directly by Paper Hub.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: const Color(0xff174EA6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Paper Hub',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Wholesale Paper Supplier',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Card(
            elevation: 0,
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('Products'),
                  subtitle: Text('B2B • JK • TNPL'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.straighten),
                  title: Text('Paper'),
                  subtitle: Text('A4 • 70 GSM'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.payments_outlined),
                  title: Text('Payment'),
                  subtitle: Text('Cash on Delivery'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.chat_outlined),
                  title: Text('Order Support'),
                  subtitle: Text('WhatsApp Ordering'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Paper Hub • Quality paper. Better business.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
