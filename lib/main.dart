import 'package:flutter/material.dart';

void main() {
  runApp(const PaperHubApp());
}

// ---------------------------------------------------------------------------
// Design Theme Colors (Exact Match with UI Screenshot)
// ---------------------------------------------------------------------------
class AppColors {
  static const Color primary = Color(0xFF0D5CA8); // Clean Royal Blue
  static const Color primaryLight = Color(0xFFEBF3FC);
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color green = Color(0xFF22C55E);
  static const Color whatsapp = Color(0xFF25D366);
  static const Color orange = Color(0xFFF97316);
}

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------
class Product {
  final String id;
  final String title;
  final String brand;
  final int gsm;
  final int sheets;
  final int price;
  final Color brandColor;

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.gsm,
    this.sheets = 500,
    required this.price,
    required this.brandColor,
  });
}

final List<Product> kProducts = [
  const Product(
    id: 'b2b-70',
    title: 'B2B A4 Paper',
    brand: 'B2B',
    gsm: 70,
    price: 210,
    brandColor: Color(0xFF1565C0),
  ),
  const Product(
    id: 'jk-70',
    title: 'JK A4 Paper',
    brand: 'JK',
    gsm: 70,
    price: 230,
    brandColor: Color(0xFF1E3A8A),
  ),
  const Product(
    id: 'tnpl-70',
    title: 'TNPL A4 Paper',
    brand: 'TNPL',
    gsm: 70,
    price: 200,
    brandColor: Color(0xFF2E7D32),
  ),
];

// ---------------------------------------------------------------------------
// Root App
// ---------------------------------------------------------------------------
class PaperHubApp extends StatelessWidget {
  const PaperHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom Graphic: 3D-Styled Realistic A4 Paper Ream Box
// ---------------------------------------------------------------------------
class PaperReamWidget extends StatelessWidget {
  final String brand;
  final Color primaryColor;
  final double width;
  final double height;

  const PaperReamWidget({
    super.key,
    required this.brand,
    required this.primaryColor,
    this.width = 90,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: width * 0.18,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 15,
                itemBuilder: (_, __) => Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    brand,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('A4', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('70 GSM', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Splash Screen
// ---------------------------------------------------------------------------
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.layers, color: AppColors.primary, size: 40),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PAPER HUB',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('All Types of A4 Paper', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const Text('Best Quality  |  Best Price', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BrandPill(name: 'B2B', color: Color(0xFFD32F2F)),
                  SizedBox(width: 16),
                  _BrandPill(name: 'JK PAPER', color: AppColors.primary),
                  SizedBox(width: 16),
                  _BrandPill(name: 'TNPL', color: Color(0xFF2E7D32)),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.inventory, size: 90, color: AppColors.primary),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                  );
                },
                child: const Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              const Text('Your Paper Partner', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandPill extends StatelessWidget {
  final String name;
  final Color color;
  const _BrandPill({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        name,
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 11),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main Navigation Shell (Tabs: Home, Products, Cart, Orders, Contact)
// ---------------------------------------------------------------------------
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  final Map<String, int> _cart = {'b2b-70': 2, 'jk-70': 1, 'tnpl-70': 1};

  void _updateCart(String id, int delta) {
    setState(() {
      _cart[id] = (_cart[id] ?? 0) + delta;
      if (_cart[id]! <= 0) _cart.remove(id);
    });
  }

  int get cartCount => _cart.values.fold(0, (sum, q) => sum + q);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onViewProducts: () => setState(() => _currentIndex = 1),
        onOpenCart: () => setState(() => _currentIndex = 2),
      ),
      ProductsScreen(
        onAddToCart: (p) => _updateCart(p.id, 1),
        onOpenCart: () => setState(() => _currentIndex = 2),
      ),
      CartScreen(
        cart: _cart,
        onUpdateQuantity: _updateCart,
        onClearCart: () => setState(() => _cart.clear()),
      ),
      const OrdersScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Products'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          const BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Contact'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Home Screen
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final VoidCallback onViewProducts;
  final VoidCallback onOpenCart;

  const HomeScreen({super.key, required this.onViewProducts, required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Paper Hub'),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: onOpenCart),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quality A4 Paper\nat Best Price', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, height: 1.2)),
                        SizedBox(height: 6),
                        Text('For Office | School | Business', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      PaperReamWidget(brand: 'B2B', primaryColor: Color(0xFF1565C0), width: 45, height: 60),
                      SizedBox(width: 4),
                      PaperReamWidget(brand: 'TNPL', primaryColor: Color(0xFF2E7D32), width: 45, height: 60),
                    ],
                  ),
                ],
              ),
            ),

            // Brands Circles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BrandIconCard(name: 'B2B Paper', color: const Color(0xFFD32F2F), onTap: onViewProducts),
                  _BrandIconCard(name: 'JK Paper', color: AppColors.primary, onTap: onViewProducts),
                  _BrandIconCard(name: 'TNPL Paper', color: const Color(0xFF2E7D32), onTap: onViewProducts),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Products Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Our Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  GestureDetector(
                    onTap: onViewProducts,
                    child: const Text('View All >', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Product Grid
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: kProducts.length,
                itemBuilder: (context, i) {
                  final p = kProducts[i];
                  return Container(
                    width: 135,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PaperReamWidget(brand: p.brand, primaryColor: p.brandColor, width: 85, height: 95),
                        const SizedBox(height: 8),
                        Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('₹${p.price} / Ream', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p)),
                              );
                            },
                            child: const Text('View Details', style: TextStyle(fontSize: 11, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandIconCard extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onTap;

  const _BrandIconCard({required this.name, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                name.split(' ')[0],
                style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Products Screen
// ---------------------------------------------------------------------------
class ProductsScreen extends StatefulWidget {
  final Function(Product) onAddToCart;
  final VoidCallback onOpenCart;

  const ProductsScreen({super.key, required this.onAddToCart, required this.onOpenCart});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? kProducts
        : kProducts.where((p) => p.brand.toUpperCase() == _selectedCategory.toUpperCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: widget.onOpenCart),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: ['All', 'B2B', 'JK', 'TNPL'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final p = filtered[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      PaperReamWidget(brand: p.brand, primaryColor: p.brandColor, width: 80, height: 95),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                            Text('${p.gsm} GSM | ${p.sheets} Sheets (1 Ream)', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text('₹${p.price}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
                                const Text(' / Ream', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                minimumSize: const Size(90, 32),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onPressed: () {
                                widget.onAddToCart(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${p.title} added to cart')),
                                );
                              },
                              child: const Text('Add to Cart', style: TextStyle(fontSize: 12, color: Colors.white)),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Product Details Screen
// ---------------------------------------------------------------------------
class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: PaperReamWidget(brand: p.brand, primaryColor: p.brandColor, width: 140, height: 165),
              ),
            ),
            const SizedBox(height: 16),
            Text(p.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            Text('${p.gsm} GSM | ${p.sheets} Sheets (1 Ream)', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('₹${p.price}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
                const Text(' / Ream', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
            const _FeatureRow(text: 'High brightness'),
            const _FeatureRow(text: 'Smooth finish'),
            const _FeatureRow(text: 'Best for printing & photocopy'),
            const _FeatureRow(text: 'Trusted quality'),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18, color: AppColors.primary),
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                      ),
                      Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added $quantity reams to cart')),
                );
              },
              child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Cart Screen
// ---------------------------------------------------------------------------
class CartScreen extends StatelessWidget {
  final Map<String, int> cart;
  final Function(String, int) onUpdateQuantity;
  final VoidCallback onClearCart;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onUpdateQuantity,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    int total = 0;
    cart.forEach((id, qty) {
      final p = kProducts.firstWhere((prod) => prod.id == id);
      total += p.price * qty;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: onClearCart),
        ],
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your Cart is Empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: cart.entries.map((entry) {
                      final p = kProducts.firstWhere((prod) => prod.id == entry.key);
                      final subtotal = p.price * entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            PaperReamWidget(brand: p.brand, primaryColor: p.brandColor, width: 55, height: 65),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text('₹${p.price} / Ream', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      _QtyBtn(icon: Icons.remove, onTap: () => onUpdateQuantity(p.id, -1)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      _QtyBtn(icon: Icons.add, onTap: () => onUpdateQuantity(p.id, 1)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text('₹$subtotal', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('₹$total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CustomerDetailsScreen(totalAmount: total, cart: cart)),
                            );
                          },
                          child: const Text('Proceed to Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Customer Details Screen
// ---------------------------------------------------------------------------
class CustomerDetailsScreen extends StatefulWidget {
  final int totalAmount;
  final Map<String, int> cart;
  const CustomerDetailsScreen({super.key, required this.totalAmount, required this.cart});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _nameCtrl = TextEditingController(text: 'Aslam Sayyad');
  final _phoneCtrl = TextEditingController(text: '9876543210');
  final _addressCtrl = TextEditingController(text: 'Samta Colony');
  final _cityCtrl = TextEditingController(text: 'Majalgaon, Dist. Beed');
  final _pinCtrl = TextEditingController(text: '431131');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InputBox(label: 'Full Name *', hint: 'Enter your name', controller: _nameCtrl, icon: Icons.person_outline),
            _InputBox(label: 'Mobile Number *', hint: 'Enter 10 digit mobile number', controller: _phoneCtrl, icon: Icons.phone_android),
            _InputBox(label: 'Address *', hint: 'House No., Area, Landmark', controller: _addressCtrl, icon: Icons.location_on_outlined),
            _InputBox(label: 'City *', hint: 'Enter city', controller: _cityCtrl, icon: Icons.apartment),
            _InputBox(label: 'Pincode *', hint: 'Enter pincode', controller: _pinCtrl, icon: Icons.pin_drop_outlined),
            const SizedBox(height: 10),
            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Row(
                children: [
                  Icon(Icons.radio_button_checked, color: AppColors.primary, size: 20),
                  SizedBox(width: 10),
                  Icon(Icons.payments_outlined, color: AppColors.green),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cash on Delivery (COD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Pay when you receive the product', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderSummaryScreen(
                      name: _nameCtrl.text,
                      phone: _phoneCtrl.text,
                      address: '${_addressCtrl.text}, ${_cityCtrl.text}',
                      totalAmount: widget.totalAmount,
                      cart: widget.cart,
                    ),
                  ),
                );
              },
              child: const Text('Proceed to WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;

  const _InputBox({required this.label, required this.hint, required this.controller, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Order Summary (WhatsApp Share Screen)
// ---------------------------------------------------------------------------
class OrderSummaryScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final int totalAmount;
  final Map<String, int> cart;

  const OrderSummaryScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, color: AppColors.whatsapp),
                  SizedBox(width: 8),
                  Text('Send Order on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whatsapp, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Paper Hub Order', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const Divider(),
                  ...cart.entries.map((entry) {
                    final p = kProducts.firstWhere((prod) => prod.id == entry.key);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${p.title} 70 GSM × ${entry.value}', style: const TextStyle(fontSize: 13)),
                          Text('₹${p.price * entry.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    );
                  }),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('₹$totalAmount', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Customer Name: $name', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Mobile: $phone', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Address: $address', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const Text('Payment: Cash on Delivery (COD)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  const Text('Thank you!\nPaper Hub', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.whatsapp,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text('Open WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to WhatsApp with Order details...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Orders & Contact Screen
// ---------------------------------------------------------------------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _FilterButton(title: 'All', isSelected: true),
              const SizedBox(width: 8),
              _FilterButton(title: 'Pending', isSelected: false),
              const SizedBox(width: 8),
              _FilterButton(title: 'Delivered', isSelected: false),
            ],
          ),
          const SizedBox(height: 16),
          _OrderHistoryCard(id: '#PH001', date: '12 Sep 2025', amount: 850, status: 'Pending', statusColor: AppColors.orange),
          _OrderHistoryCard(id: '#PH002', date: '10 Sep 2025', amount: 630, status: 'Delivered', statusColor: AppColors.green),
          _OrderHistoryCard(id: '#PH003', date: '05 Sep 2025', amount: 420, status: 'Delivered', statusColor: AppColors.green),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  const _FilterButton({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
      ),
      child: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final String id;
  final String date;
  final int amount;
  final String status;
  final Color statusColor;

  const _OrderHistoryCard({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 2),
              Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 4),
              Text('Total: ₹$amount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. Contact Us Screen
// ---------------------------------------------------------------------------
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ContactActionCard(
                    icon: Icons.chat,
                    color: AppColors.whatsapp,
                    title: 'WhatsApp',
                    subtitle: '+91 98765 43210',
                    action: 'Chat with us',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ContactActionCard(
                    icon: Icons.call,
                    color: AppColors.primary,
                    title: 'Call',
                    subtitle: '+91 98765 43210',
                    action: 'Tap to call',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Our Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Majalgaon, Dist. Beed', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        Text('Maharashtra, India', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryLight, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  "Let's Keep\nYour Business\nAlways Ahead",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary, height: 1.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String action;

  const _ContactActionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.15), radius: 18, child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(action, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
