import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

// ---------------------------------------------------------------------------
// Design Theme Colors
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
// WhatsApp Helper Function (Web & Mobile Compatible)
// ---------------------------------------------------------------------------
Future<void> openWhatsAppChat(String phone, {String text = ''}) async {
  final cleanNumber = phone.replaceAll(RegExp(r'[^0-9]'), '');
  final fullNumber = cleanNumber.startsWith('91') ? cleanNumber : '91$cleanNumber';
  final encodedMsg = Uri.encodeComponent(
    text.isNotEmpty ? text : 'Hello Paper Hub, mujhe order/inquiry karni hai.',
  );

  // Web aur Mobile dono platform par work karega
  final Uri url = Uri.parse("https://api.whatsapp.com/send?phone=$fullNumber&text=$encodedMsg");

  try {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  } catch (e) {
    debugPrint('WhatsApp open error: $e');
  }
}

// ---------------------------------------------------------------------------
// WhatsApp 2 Numbers Bottom Sheet Modal
// ---------------------------------------------------------------------------
void showWhatsAppDialog(BuildContext context, {String customText = ''}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.whatsapp.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat, color: AppColors.whatsapp, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paper Hub WhatsApp Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Chat shuru karne ke liye number chunein:',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Number 1: 7038343215
              _SupportTile(
                title: 'WhatsApp Support 1',
                phone: '+91 7038343215',
                desc: 'Orders, Pricing & General Inquiry',
                onTap: () {
                  Navigator.pop(ctx);
                  openWhatsAppChat('7038343215', text: customText);
                },
              ),
              const SizedBox(height: 10),

              // Number 2: 9175635317
              _SupportTile(
                title: 'WhatsApp Support 2',
                phone: '+91 9175635317',
                desc: 'Bulk Booking & Delivery Help',
                onTap: () {
                  Navigator.pop(ctx);
                  openWhatsAppChat('9175635317', text: customText);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

class _SupportTile extends StatelessWidget {
  final String title;
  final String phone;
  final String desc;
  final VoidCallback onTap;

  const _SupportTile({
    required this.title,
    required this.phone,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.whatsapp,
              radius: 18,
              child: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(
                    phone,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(desc, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
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
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'A4',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '70 GSM',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 9,
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
              const Text(
                'All Types of A4 Paper',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const Text(
                'Best Quality  |  Best Price',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
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
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.whatsapp,
        child: const Icon(Icons.chat, color: Colors.white),
        onPressed: () => showWhatsAppDialog(context),
      ),
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
                        Text(
                          'Quality A4 Paper\nat Best Price',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, height: 1.2),
                        ),
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
// 3. Products Screen (Filtering + Cart integration)
// ---------------------------------------------------------------------------
class ProductsScreen extends StatefulWidget {
  final Function(Product) onAddToCart;
  final VoidCallback onOpenCart;

  const ProductsScreen({super.key, required this.onAddToCart, required this.onOpenCart});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedBrand = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedBrand == 'All'
        ? kProducts
        : kProducts.where((p) => p.brand == _selectedBrand).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: widget.onOpenCart),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: ['All', 'B2B', 'JK', 'TNPL'].map((brand) {
                final isSelected = _selectedBrand == brand;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(brand),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => setState(() => _selectedBrand = brand),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final p = filtered[i];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        PaperReamWidget(brand: p.brand, primaryColor: p.brandColor, width: 70, height: 80),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('${p.gsm} GSM • ${p.sheets} Sheets', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              const SizedBox(height: 6),
                              Text('₹${p.price} / Ream', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          onPressed: () {
                            widget.onAddToCart(p);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${p.title} added to cart!'),
                                duration: const Duration(milliseconds: 900),
                              ),
                            );
                          },
                          child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
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
class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: PaperReamWidget(
                brand: product.brand,
                primaryColor: product.brandColor,
                width: 160,
                height: 190,
              ),
            ),
            const SizedBox(height: 24),
            Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              '₹${product.price} / Ream',
              style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            const Text('Specifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _specRow('Size', 'A4 (210 x 297 mm)'),
            _specRow('GSM', '${product.gsm} GSM'),
            _specRow('Sheets per ream', '${product.sheets} Sheets'),
            _specRow('Ideal for', 'Photocopy, Laser, & Inkjet Printing'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whatsapp,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text(
                      'Order on WhatsApp',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showWhatsAppDialog(
                        context,
                        customText: 'Hi Paper Hub, mujhe ${product.title} (₹${product.price}) order karna hai.',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(String key, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(color: AppColors.textMuted)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    final cartItems = cart.entries.map((e) {
      final p = kProducts.firstWhere((prod) => prod.id == e.key);
      return {'product': p, 'quantity': e.value};
    }).toList();

    final total = cartItems.fold<int>(
      0,
      (sum, item) => sum + ((item['product'] as Product).price * (item['quantity'] as int)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your Cart is Empty', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, i) {
                      final item = cartItems[i];
                      final p = item['product'] as Product;
                      final qty = item['quantity'] as int;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              PaperReamWidget(brand: p.brand, primaryColor: p.brandColor, width: 50, height: 60),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      '₹${p.price} x $qty = ₹${p.price * qty}',
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => onUpdateQuantity(p.id, -1),
                                  ),
                                  Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => onUpdateQuantity(p.id, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            '₹$total',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.whatsapp,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text(
                            'Send Order on WhatsApp',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            final orderText = 'Paper Hub Order Summary:\nTotal Amount: ₹$total\nItems: ${cart.length} items';
                            showWhatsAppDialog(context, customText: orderText);
                          },
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

// ---------------------------------------------------------------------------
// 6. Orders Screen
// ---------------------------------------------------------------------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _orderCard('ORD-2026-001', '10 Reams (B2B 70 GSM)', '₹2,100', 'Delivered'),
          _orderCard('ORD-2026-002', '5 Reams (JK 70 GSM)', '₹1,150', 'Dispatched'),
        ],
      ),
    );
  }

  Widget _orderCard(String id, String desc, String amount, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        title: Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            Text(status, style: const TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Contact Screen (Both Numbers Integrated)
// ---------------------------------------------------------------------------
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paper Hub Helpdesk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Agar aapko paper rates, bulk inquiry ya order ke bare me koi sawal ho toh hume direct WhatsApp karein:',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Number 1: 7038343215
            _ContactCard(
              title: 'Support Desk 1',
              subtitle: 'Price Quotations & New Orders',
              number: '+91 7038343215',
              onTap: () => openWhatsAppChat('7038343215'),
            ),
            const SizedBox(height: 12),

            // Number 2: 9175635317
            _ContactCard(
              title: 'Support Desk 2',
              subtitle: 'Order Tracking & Urgent Help',
              number: '+91 9175635317',
              onTap: () => openWhatsAppChat('9175635317'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: AppColors.whatsapp,
          child: Icon(Icons.chat, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(number, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.whatsapp,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: onTap,
          child: const Text('Chat', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}
