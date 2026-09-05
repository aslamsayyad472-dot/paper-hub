import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

const String whatsappNumber = '91XXXXXXXXXX';

class Product {
  final String name;
  final int price;

  const Product(this.name, this.price);
}

const products = [
  Product('B2B Paper', 210),
  Product('JK Paper', 230),
  Product('TNPL Paper', 200),
];

class PaperHubApp extends StatelessWidget {
  const PaperHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
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

  int get total {
    int amount = 0;

    for (final product in products) {
      amount += (cart[product.name] ?? 0) * product.price;
    }

    return amount;
  }

  void addToCart(Product product) {
    setState(() {
      cart[product.name] = (cart[product.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
      ),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cart: cart,
          total: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        cart.values.fold<int>(0, (sum, quantity) => sum + quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paper Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: openCart,
                icon: const Icon(Icons.shopping_cart),
              ),
              if (itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff182848),
                  Color(0xff4b6cb7),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PAPER HUB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Quality paper. Simple ordering.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Our Products',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...products.map(
            (product) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(product.name[0]),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('70 GSM • A4'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () => addToCart(product),
                      child: const Text('ADD'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          FilledButton.icon(
            onPressed: itemCount == 0 ? null : openCart,
            icon: const Icon(Icons.receipt_long),
            label: Text(
              itemCount == 0
                  ? 'Add products to order'
                  : 'Proceed to Order • ₹$total',
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

  String buildOrderMessage() {
    final lines = <String>[
      '*Paper Hub Order*',
      '',
    ];

    for (final product in products) {
      final quantity = widget.cart[product.name] ?? 0;

      if (quantity > 0) {
        lines.add(
          '${product.name} x $quantity = ₹${product.price * quantity}',
        );
      }
    }

    lines.addAll([
      '',
      '*Total: ₹${widget.total}*',
      'Payment: Cash on Delivery',
      '',
      'Customer: ${nameController.text}',
      'Mobile: ${phoneController.text}',
      'Address: ${addressController.text}',
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
            'Please fill Name, Mobile and Address',
          ),
        ),
      );
      return;
    }

    final url = Uri.parse(
      'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(buildOrderMessage())}',
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp'),
          ),
        );
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...products
                      .where(
                        (product) =>
                            (widget.cart[product.name] ?? 0) > 0,
                      )
                      .map(
                        (product) => Text(
                          '${product.name} × ${widget.cart[product.name]}'
                          ' — ₹${product.price * widget.cart[product.name]!}',
                        ),
                      ),

                  const Divider(),

                  Text(
                    'Total: ₹${widget.total}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    'Payment: Cash on Delivery',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Customer Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Delivery Address',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 18),

          FilledButton.icon(
            onPressed: sendWhatsApp,
            icon: const Icon(Icons.chat),
            label: const Text(
              'Place Order on WhatsApp',
            ),
          ),
        ],
      ),
    );
  }
}
