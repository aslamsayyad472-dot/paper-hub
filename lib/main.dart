import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

// ---------------------------------------------------------------------------
// Design System & Constants
// ---------------------------------------------------------------------------
class AppColors {
  static const Color primary = Color(0xFF1E3A8A); // Deep Executive Navy
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color accent = Color(0xFF0D9488); // Forest Teal
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC); // Slate tint
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFEF4444);
}

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------
class Product {
  final String id;
  final String name;
  final String brand;
  final int price;
  final int gsm;
  final int sheetsPerReam;
  final double rating;
  final int reviewCount;
  final String badge;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.gsm,
    required this.sheetsPerReam,
    required this.rating,
    required this.reviewCount,
    required this.badge,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

final List<Product> kProducts = [
  const Product(
    id: 'b2b-75',
    name: 'B2B Copier High-Speed A4',
    brand: 'B2B',
    price: 210,
    gsm: 75,
    sheetsPerReam: 500,
    rating: 4.8,
    reviewCount: 340,
    badge: 'Best Seller',
  ),
  const Product(
    id: 'jk-easy-70',
    name: 'JK Copier Premium Multipurpose',
    brand: 'JK Paper',
    price: 235,
    gsm: 75,
    sheetsPerReam: 500,
    rating: 4.9,
    reviewCount: 820,
    badge: 'Popular',
  ),
  const Product(
    id: 'tnpl-ultra-80',
    name: 'TNPL Ultra White Copier Sheet',
    brand: 'TNPL',
    price: 198,
    gsm: 70,
    sheetsPerReam: 500,
    rating: 4.7,
    reviewCount: 195,
    badge: 'Value Pack',
  ),
  const Product(
    id: 'jk-cedar-80',
    name: 'JK Cedar Super Bright Bond Paper',
    brand: 'JK Paper',
    price: 275,
    gsm: 80,
    sheetsPerReam: 500,
    rating: 4.9,
    reviewCount: 140,
    badge: 'Executive',
  ),
];

// ---------------------------------------------------------------------------
// Main App Entry
// ---------------------------------------------------------------------------
class PaperHubApp extends StatelessWidget {
  const PaperHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub Pro',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          centerTitle: false,
        ),
      ),
      home: const MainShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// Main Shell (State holder for Cart)
// ---------------------------------------------------------------------------
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Map<String, CartItem> _cart = {};

  void _addToCart(Product product) {
    setState(() {
      if (_cart.containsKey(product.id)) {
        _cart[product.id]!.quantity += 1;
      } else {
        _cart[product.id] = CartItem(product: product);
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.brand} ream added to cart'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateQuantity(String productId, int delta) {
    setState(() {
      if (!_cart.containsKey(productId)) return;
      _cart[productId]!.quantity += delta;
      if (_cart[productId]!.quantity <= 0) {
        _cart.remove(productId);
      }
    });
  }

  int get _cartItemCount =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onAddProduct: _addToCart),
      CatalogScreen(onAddProduct: _addToCart),
      CartScreen(
        cartItems: _cart.values.toList(),
        onUpdateQuantity: _updateQuantity,
      ),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          elevation: 0,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.1),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
              label: 'Explore',
            ),
            const NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune, color: AppColors.primary),
              label: 'Catalog',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _cartItemCount > 0,
                label: Text('$_cartItemCount'),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: _cartItemCount > 0,
                label: Text('$_cartItemCount'),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.shopping_bag, color: AppColors.primary),
              ),
              label: 'Cart',
            ),
            const NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon: Icon(Icons.local_shipping, color: AppColors.primary),
              label: 'Orders',
            ),
            const NavigationDestination(
              icon: Icon(Icons.business_center_outlined),
              selectedIcon: Icon(Icons.business_center, color: AppColors.primary),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 1: Home Dashboard
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final ValueChanged<Product> onAddProduct;

  const HomeScreen({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.layers_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Paper Hub',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'B2B Wholesale & Supply',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search 70 GSM, 75 GSM, or brands...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded, size: 20),
                  color: AppColors.primary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Business Value Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'WHOLESALE DISPATCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Guaranteed 99.9% Jam-Free Copier Paper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bulk tier discounts apply automatically from 20+ reams.',
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Metrics / Assurance Bar
          Row(
            children: const [
              Expanded(
                child: _MetricBadge(
                  icon: Icons.verified_user_outlined,
                  title: 'Genuine Stock',
                  subtitle: 'Mill Certified',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MetricBadge(
                  icon: Icons.local_shipping_outlined,
                  title: 'Same-Day Dispatch',
                  subtitle: 'Bulk Ready',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MetricBadge(
                  icon: Icons.receipt_long_outlined,
                  title: 'GST Invoice',
                  subtitle: 'Tax Input Claim',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Paper Reams',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Specifications'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Product List Cards
          ...kProducts.map((p) => _ProductListItem(product: p, onAdd: () => onAddProduct(p))),
        ],
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MetricBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const _ProductListItem({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Ream Indicator
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_copy_rounded, color: AppColors.primary, size: 26),
                const SizedBox(height: 4),
                Text(
                  '${product.gsm} GSM',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.brand.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '★ ${product.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.sheetsPerReam} Sheets / Ream • High Brightness',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Ream'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
  }
}

// ---------------------------------------------------------------------------
// Screen 2: Catalog Screen
// ---------------------------------------------------------------------------
class CatalogScreen extends StatelessWidget {
  final ValueChanged<Product> onAddProduct;

  const CatalogScreen({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Brand Catalog',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Select by Paper Density',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(label: const Text('All Grades'), selected: true, onSelected: (_) {}),
              FilterChip(label: const Text('70 GSM (Economy)'), selected: false, onSelected: (_) {}),
              FilterChip(label: const Text('75 GSM (Standard)'), selected: false, onSelected: (_) {}),
              FilterChip(label: const Text('80 GSM (Executive)'), selected: false, onSelected: (_) {}),
            ],
          ),
          const SizedBox(height: 20),
          ...kProducts.map((p) => _ProductListItem(product: p, onAdd: () => onAddProduct(p))),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 3: Cart Screen with Quantity Controls
// ---------------------------------------------------------------------------
class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(String id, int delta) onUpdateQuantity;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Supply Cart', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
              const SizedBox(height: 14),
              const Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add paper reams or boxes to request delivery',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = cartItems.fold<int>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final totalReams = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply Cart', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${item.product.price} / ream',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () => onUpdateQuantity(item.product.id, -1),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => onUpdateQuantity(item.product.id, 1),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total ($totalReams Reams)',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      Text(
                        '₹$subtotal',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              cart: cartItems,
                              total: subtotal,
                            ),
                          ),
                        );
                      },
                      child: const Text('Proceed to Order Details', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
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

// ---------------------------------------------------------------------------
// Screen 4: Checkout Screen
// ---------------------------------------------------------------------------
class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cart;
  final int total;

  const CheckoutScreen({super.key, required this.cart, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firmNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final itemsSummary = widget.cart
        .map((c) => '• ${c.product.brand} (${c.product.gsm} GSM) x ${c.quantity} reams = ₹${c.product.price * c.quantity}')
        .join('\n');

    final message = '''
*OFFICIAL PAPER ORDER - PAPER HUB*
---------------------------------------
*Client Details:*
Name: ${_nameController.text.trim()}
Firm/Shop: ${_firmNameController.text.trim().isEmpty ? 'N/A' : _firmNameController.text.trim()}
Phone: ${_phoneController.text.trim()}
Address: ${_addressController.text.trim()}

*Order Breakdown:*
$itemsSummary

*Total Amount:* ₹${widget.total}
*Payment Method:* Cash on Delivery / UPI on Dispatch
---------------------------------------
Please confirm supply availability and dispatch timeline.
''';

    final uri = Uri.parse('https://wa.me/917038343215?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp for confirmation')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firmNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Specification', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Delivery & Contact Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Contact Person Name', Icons.person_outline),
              validator: (v) => v!.isEmpty ? 'Enter name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _firmNameController,
              decoration: _inputDecoration('Company / Shop Name (Optional)', Icons.storefront_outlined),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('Mobile Number', Icons.phone_outlined),
              validator: (v) => v!.length < 10 ? 'Enter valid 10-digit number' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: _inputDecoration('Delivery Address & Landmark', Icons.place_outlined),
              validator: (v) => v!.isEmpty ? 'Enter full address' : null,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payable at Delivery', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '₹${widget.total}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075E54), // WhatsApp Business green
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _submitOrder,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Confirm via WhatsApp', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 5: Orders / History Screen
// ---------------------------------------------------------------------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatches & Orders', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text(
              'No active dispatches',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Orders confirmed on WhatsApp will appear here',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 6: Account & Support
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Support', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.business, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'B2B Enterprise Account',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Paper Hub Direct Desk',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _AccountTile(
            icon: Icons.support_agent_outlined,
            title: 'Contact Supplier Desk',
            subtitle: 'Direct WhatsApp inquiry',
            onTap: () async {
              final uri = Uri.parse('https://wa.me/917038343215');
              if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          _AccountTile(
            icon: Icons.description_outlined,
            title: 'Download Mill Test Reports',
            subtitle: 'Brightness & GSM certifications',
            onTap: () {},
          ),
          _AccountTile(
            icon: Icons.shield_outlined,
            title: 'Terms of Supply & Returns',
            subtitle: 'Damaged ream replacement policy',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
