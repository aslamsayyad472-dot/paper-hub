import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PaperHubApp());
}

class PaperHubApp extends StatelessWidget {
  const PaperHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Hub',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        fontFamily: 'Roboto',
      ),
      home: const CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int selectedCategoryIndex = 0;
  int currentNavIndex = 0;
  String searchQuery = '';
  final Set<String> favoriteItems = {};
  final TextEditingController searchController = TextEditingController();

  final String whatsappNumber1 = '917038343215';
  final String whatsappNumber2 = '919175635317';

  final List<String> categories = ['All Papers', '70 GSM A4', 'Bulk Box Offers'];

  final List<Map<String, dynamic>> allItems = [
    {
      'id': '1',
      'title': 'B2B 70 GSM A4 Ream',
      'price': '₹220',
      'unit': 'per ream',
      'badge': 'Regular',
      'category': '70 GSM A4',
      'image': 'https://raw.githubusercontent.com/aslamsayyad472-dot/paperhubstore/main/b2b.jpg',
    },
    {
      'id': '2',
      'title': 'JK Easy Copier 70 GSM',
      'price': '₹240',
      'unit': 'per ream',
      'badge': 'Premium',
      'category': '70 GSM A4',
      'image': 'https://raw.githubusercontent.com/aslamsayyad472-dot/paperhubstore/main/jk.jpg',
    },
    {
      'id': '3',
      'title': 'TNPL Platinum 70 GSM',
      'price': '₹200',
      'unit': 'per ream',
      'badge': 'Best Price',
      'category': '70 GSM A4',
      'image': 'https://raw.githubusercontent.com/aslamsayyad472-dot/paperhubstore/main/tnpl.jpg',
    },
    {
      'id': '4',
      'title': 'B2B Box (10 Reams Pack)',
      'price': '₹2,000',
      'unit': '₹200 / ream',
      'badge': 'Special Offer',
      'category': 'Bulk Box Offers',
      'image': 'https://raw.githubusercontent.com/aslamsayyad472-dot/paperhubstore/main/box.jpg',
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    return allItems.where((item) {
      if (currentNavIndex == 1 && !favoriteItems.contains(item['id'])) {
        return false;
      }
      if (selectedCategoryIndex == 1 && item['category'] != '70 GSM A4') {
        return false;
      }
      if (selectedCategoryIndex == 2 && item['category'] != 'Bulk Box Offers') {
        return false;
      }
      if (searchQuery.isNotEmpty &&
          !item['title'].toString().toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _openWhatsApp(String phone, String title, String price, String unit) async {
    final message = "Hello Paper Hub,\nI want to place an order for:\n\n*Product:* $title\n*Price:* $price ($unit)";
    final encodedText = Uri.encodeComponent(message);

    final whatsappNativeUri = Uri.parse("whatsapp://send?phone=$phone&text=$encodedText");
    final whatsappWebUri = Uri.parse("https://wa.me/$phone?text=$encodedText");

    try {
      if (await canLaunchUrl(whatsappNativeUri)) {
        await launchUrl(whatsappNativeUri, mode: LaunchMode.externalNonBrowserApplication);
      } else {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
    }
  }

  void _showWhatsAppChoice(String title, String price, String unit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select WhatsApp Contact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Order query for $title - $price ($unit)',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: const Text('Contact 1'),
                subtitle: const Text('+91 7038343215'),
                tileColor: const Color(0xFFF7F8FA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                  _openWhatsApp(whatsappNumber1, title, price, unit);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: const Text('Contact 2'),
                subtitle: const Text('+91 9175635317'),
                tileColor: const Color(0xFFF7F8FA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                  _openWhatsApp(whatsappNumber2, title, price, unit);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = filteredItems;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentNavIndex == 1
                            ? 'Favorites'
                            : (currentNavIndex == 2 ? 'My Orders' : 'Paper Hub'),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showWhatsAppChoice("Bulk Inquiry", "-", "General Help");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (val) {
                                    setState(() {
                                      searchQuery = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Search B2B, JK, TNPL...',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (searchQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searchController.clear();
                                      searchQuery = '';
                                    });
                                  },
                                  child: const Icon(Icons.close, color: Colors.grey, size: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = (selectedCategoryIndex + 1) % categories.length;
                          });
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.tune, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1E3A2B) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: displayItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                currentNavIndex == 1 ? Icons.favorite_border : Icons.search_off,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentNavIndex == 1
                                    ? "No favorite products added yet!"
                                    : "No products match your search",
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                          itemCount: displayItems.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final item = displayItems[index];
                            final isFav = favoriteItems.contains(item['id']);

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF1F4),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item['badge'],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E3A2B),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isFav) {
                                              favoriteItems.remove(item['id']);
                                            } else {
                                              favoriteItems.add(item['id']);
                                            }
                                          });
                                        },
                                        child: Icon(
                                          isFav ? Icons.favorite : Icons.favorite_border,
                                          size: 22,
                                          color: isFav ? Colors.red : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item['image'],
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.description,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        item['price'],
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['unit'],
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 34,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF141414),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        _showWhatsAppChoice(item['title'], item['price'], item['unit']);
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.chat, size: 14, color: Colors.white),
                                          SizedBox(width: 6),
                                          Text(
                                            'Order Now',
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
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
            Positioned(
              bottom: 24,
              left: 30,
              right: 30,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_filled,
                          color: currentNavIndex == 0 ? Colors.white : Colors.white54),
                      onPressed: () => setState(() => currentNavIndex = 0),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite,
                          color: currentNavIndex == 1 ? Colors.redAccent : Colors.white54),
                      onPressed: () => setState(() => currentNavIndex = 1),
                    ),
                    IconButton(
                      icon: Icon(Icons.receipt_long,
                          color: currentNavIndex == 2 ? Colors.white : Colors.white54),
                      onPressed: () {
                        setState(() => currentNavIndex = 2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Orders are tracked via WhatsApp chat history.")),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.support_agent,
                          color: currentNavIndex == 3 ? Colors.white : Colors.white54),
                      onPressed: () {
                        _showWhatsAppChoice("Customer Support Query", "-", "Help");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
