import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

// ---------------------------------------------------------------------------
// Design Palette (E-commerce Style)
// ---------------------------------------------------------------------------
class AppColors {
  static const Color header = Color(0xFF131921); // Amazon Dark Slate
  static const Color primary = Color(0xFF2874F0); // Flipkart Royal Blue
  static const Color accent = Color(0xFFFF9900); // Amazon Amber/Orange
  static const Color background = Color(0xFFF1F3F6); // Soft gray shopping surface
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF878787);
  static const Color border = Color(0xFFE0E0E0);
  static const Color success = Color(0xFF388E3C);
}

// ---------------------------------------------------------------------------
// Product Model with Web Images
// ---------------------------------------------------------------------------
class Product {
  final String id;
  final String title;
  final String brand;
  final int price;
  final int originalPrice;
  final int gsm;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String tag;

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.gsm,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.tag,
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
    title: 'B2B Copier A4 Paper (75 GSM, 500 Sheets)',
    brand: 'B2B',
    price: 210,
    originalPrice: 280,
    gsm: 75,
    rating: 4.8,
    reviewCount: 1420,
    imageUrl: 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500&q=80',
    tag: 'Best Seller',
  ),
  const Product(
    id: 'jk-easy-75',
    title: 'JK Easy Copier Paper A4 Size 75 GSM (1 Ream)',
    brand: 'JK Paper',
    price: 235,
    originalPrice: 310,
    gsm: 75,
    rating: 4.9,
    reviewCount: 3890,
    imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&q=80',
    tag: 'Assured',
  ),
  const Product(
    id: 'tnpl-ultra-70',
    title: 'TNPL Ultra White Multi-Purpose A4 Copier Paper',
    brand: 'TNPL',
    price: 198,
    originalPrice: 250,
    gsm: 70,
    rating: 4.6,
    reviewCount: 890,
    imageUrl: 'https://images.unsplash.com/photo-1568667256549-094345857637?w=500&q=80',
    tag: 'Value Choice',
  ),
  const Product(
    id: 'jk-cedar-80',
    title: 'JK Cedar Super Bright Executive Bond 80 GSM',
    brand: 'JK Paper',
    price: 275,
    originalPrice: 360,
    gsm: 80,
    rating: 4.9,
    reviewCount: 650,
    imageUrl: 'https://images.unsplash.com/photo-1517842645767-c639042777db?w=500&q=80',
    tag: 'Premium',
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
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// Shell & Bottom Navigation
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
        backgroundColor: AppColors.header,
        action: SnackBarAction(
          label: 'GO TO CART',
          textColor: AppColors.accent,
          onPressed: () => setState(() => _currentIndex = 2),
        ),
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

  int get _cartCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);

  @override
  Widget build(BuildContext context) {
    final screens = [
      StoreHomeScreen(onAddProduct: _addToCart),
      CategoriesScreen(onAddProduct: _addToCart),
      CartScreen(
        cartItems: _cart.values.toList(),
        onUpdateQuantity: _updateQuantity,
      ),
      const OrdersScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        selectedIndex: _currentIndex,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view, color: AppColors.primary),
            label: 'Brands',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_cart, color: AppColors.primary),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: AppColors.primary),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 1: Store Home (Amazon/Flipkart Style)
// ---------------------------------------------------------------------------
class StoreHomeScreen extends StatelessWidget {
  final ValueChanged<Product> onAddProduct;

  const StoreHomeScreen({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Amazon Style Top Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.header,
            expandedHeight: 110,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping, color: AppColors.accent, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          'PAPER HUB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'WHOLESALE',
                            style: TextStyle(
                              color: AppColors.header,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Search Bar
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppColors.textSecondary),
                          SizedBox(width: 8),
                          Text(
                            'Search JK, TNPL, B2B Copier Paper...',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2874F0), Color(0xFF0C4BB3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'FLAT 25% OFF',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Direct Factory Rates\nFree Express Delivery',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.2),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Minimum 5 boxes delivery free',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=200&q=80',
                      width: 90,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Deals of the day title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deals of the Day',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    'View All >',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),

          // Product List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = kProducts[index];
                  return ProductCardAmazon(product: p, onAdd: () => onAddProduct(p));
                },
                childCount: kProducts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

class ProductCardAmazon extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCardAmazon({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final discountPercent = (((product.originalPrice - product.price) / product.originalPrice) * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Box with Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  height: 110,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 110,
                    width: 100,
                    color: AppColors.background,
                    child: const Icon(Icons.file_copy, size: 40, color: AppColors.primary),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.header,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(6)),
                  ),
                  child: Text(
                    product.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.2),
                ),
                const SizedBox(height: 4),

                // Rating & GSM
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${product.rating}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.star, size: 10, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${product.reviewCount})',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.gsm} GSM',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price & Offer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${product.originalPrice}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$discountPercent% off',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Action
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.header,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
// Screen 2: Categories / Brands
// ---------------------------------------------------------------------------
class CategoriesScreen extends StatelessWidget {
  final ValueChanged<Product> onAddProduct;

  const CategoriesScreen({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brands & Grades', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text('Select by Brand', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              _brandChip('JK Paper'),
              const SizedBox(width: 8),
              _brandChip('TNPL'),
              const SizedBox(width: 8),
              _brandChip('B2B Copier'),
            ],
          ),
          const SizedBox(height: 16),
          ...kProducts.map((p) => ProductCardAmazon(product: p, onAdd: () => onAddProduct(p))),
        ],
      ),
    );
  }

  Widget _brandChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 3: Cart Screen with Sticky Flipkart Checkout Bar
// ---------------------------------------------------------------------------
class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(String id, int delta) onUpdateQuantity;

  const CartScreen({super.key, required this.cartItems, required this.onUpdateQuantity});

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cart'), backgroundColor: Colors.white),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/1170/1170576.png',
                width: 90,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              const Text('Your Cart is Empty!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Add paper reams to place wholesale order', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    final total = cartItems.fold<int>(0, (sum, i) => sum + (i.product.price * i.quantity));
    final totalReams = cartItems.fold<int>(0, (sum, i) => sum + i.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart'), backgroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(item.product.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('₹${item.product.price} / ream', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary),
                            onPressed: () => onUpdateQuantity(item.product.id, -1),
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                            onPressed: () => onUpdateQuantity(item.product.id, 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Sticky Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('₹$total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text('$totalReams Reams selected', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.header,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(cart: cartItems, total: total),
                        ),
                      );
                    },
                    child: const Text('PLACE ORDER', style: TextStyle(fontWeight: FontWeight.bold)),
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
// Screen 4: Checkout Screen (Instant WhatsApp Launch)
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
  final _shopController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final items = widget.cart
        .map((c) => '${c.product.brand} (${c.product.gsm} GSM) x ${c.quantity} Ream')
        .join('\n');

    final message = '''
Hello Paper Hub,
I want to place an order:

*Customer:* ${_nameController.text.trim()}
*Shop Name:* ${_shopController.text.trim().isEmpty ? 'N/A' : _shopController.text.trim()}
*Mobile:* ${_phoneController.text.trim()}
*Address:* ${_addressController.text.trim()}

*Products:*
$items

*Total Amount:* ₹${widget.total}
*Payment Mode:* Cash on Delivery
''';

    final uri = Uri.parse('https://wa.me/917038343215?text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp open nahi ho saka')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shopController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildField('Full Name', _nameController, Icons.person_outline, (v) => v!.isEmpty ? 'Enter name' : null),
            const SizedBox(height: 12),
            _buildField('Shop / Business Name (Optional)', _shopController, Icons.storefront_outlined, null),
            const SizedBox(height: 12),
            _buildField('10-Digit Mobile Number', _phoneController, Icons.phone_outlined, (v) => v!.length < 10 ? 'Enter valid number' : null, type: TextInputType.phone),
            const SizedBox(height: 12),
            _buildField('Complete Address with Landmark', _addressController, Icons.location_on_outlined, (v) => v!.isEmpty ? 'Enter address' : null, maxLines: 3),
            const SizedBox(height: 18),

            // Price Details Summary Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PRICE DETAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable (COD)'),
                      Text('₹${widget.total}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp Official Green
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _submitOrder,
                icon: const Icon(Icons.chat),
                label: const Text('CONFIRM ON WHATSAPP', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller, IconData icon, String? Function(String?)? validator, {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      validator: validator,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 5: Orders Tab
// ---------------------------------------------------------------------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), backgroundColor: Colors.white),
      body: const Center(
        child: Text('All confirmed orders will show here', style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 6: Account & Support
// ---------------------------------------------------------------------------
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Account'), backgroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
                SizedBox(width: 14),
                Text('Paper Hub Wholesale Buyer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.support_agent, color: AppColors.primary),
            title: const Text('Direct Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final uri = Uri.parse('https://wa.me/917038343215');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}
