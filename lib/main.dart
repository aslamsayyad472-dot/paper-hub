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

  // Paper Hub Contacts
  final String whatsappNumber1 = '917038343215';
  final String whatsappNumber2 = '919175635317';

  // Partner Store Contacts (Shree Tuljabhavani Computers)
  final String partner1Name = 'Rohit Devkule';
  final String partner1Number = '919175635317';
  final String partner2Name = 'Chaitanya Kadam';
  final String partner2Number = '919209097597';

  // Tuljabhavani Devi Image URL
  final String tuljabhavaniImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Tulja_Bhavani_Devi.jpg/500px-Tulja_Bhavani_Devi.jpg';

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

  // Universal WhatsApp Launcher
  Future<void> _openWhatsAppRaw(String phone, String message) async {
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

  // Paper Hub Order Popup
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
                title: const Text('Paper Hub - Line 1'),
                subtitle: const Text('+91 7038343215'),
                tileColor: const Color(0xFFF7F8FA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                  final msg = "Hello Paper Hub,\nI want to place an order for:\n\n*Product:* $title\n*Price:* $price ($unit)";
                  _openWhatsAppRaw(whatsappNumber1, msg);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: const Text('Paper Hub - Line 2'),
                subtitle: const Text('+91 9175635317'),
                tileColor: const Color(0xFFF7F8FA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                  final msg = "Hello Paper Hub,\nI want to place an order for:\n\n*Product:* $title\n*Price:* $price ($unit)";
                  _openWhatsAppRaw(whatsappNumber2, msg);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Shree Tuljabhavani Computers Enquiry Popup
  void _showTuljabhavaniChoice() {
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.amber,
                    backgroundImage: NetworkImage(tuljabhavaniImageUrl),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'श्री तुळजाभवानी कॉम्प्युटर्स',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'DTP, Bond, Xerox & Online Services',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: Text(partner1Name),
                subtitle: const Text('+91 9175635317'),
                tileColor: const Color(0xFFF7F8FA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                  final msg = "नमस्कार,\nमला 'श्री तुळजाभवानी कॉम्प्युटर्स' च्या ऑनलाईन / प्रिंटिंग सेवेबद्दल माहिती हवी आहे.";
                  _openWhatsAppRaw(partner1Number, msg);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: Text(partner2Name),
                subtitle: const Text('+91 9209097597'),
                tileColor: const Color(0xFFF7F8FA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {
                  Navigator.pop(context);
                  final msg = "नमस्कार,\nमला 'श्री तुळजाभवानी कॉम्प्युटर्स' च्या ऑनलाईन / प्रिंटिंग सेवेबद्दल माहिती हवी आहे.";
                  _openWhatsAppRaw(partner2Number, msg);
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
                // Top App Bar
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

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    height: 46,
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
                            onChanged: (val) => setState(() => searchQuery = val),
                            decoration: const InputDecoration(
                              hintText: 'Search B2B, JK, TNPL...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() {
                              searchController.clear();
                              searchQuery = '';
                            }),
                            child: const Icon(Icons.close, color: Colors.grey, size: 18),
                          ),
                      ],
                    ),
                  ),
                ),

                // Promotion Banner with Tuljabhavani Devi Photo
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF800020), Color(0xFF1A102F)], // Elegant rich maroon-gold theme
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF800020).withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Devi Photo with golden circular border
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.amber, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white12,
                                backgroundImage: NetworkImage(tuljabhavaniImageUrl),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'श्री तुळजाभवानी कॉम्प्युटर्स',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.amberAccent, width: 0.7),
                                        ),
                                        child: const Text(
                                          'Partner Store',
                                          style: TextStyle(
                                            color: Colors.amberAccent,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'DTP, Bond, Xerox, Cast & Income Certificate',
                                    style: TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'सर्व प्रकारच्या ऑनलाईन सेवा, गॅझेट आणि सरकारी फॉर्म्सची कामे खात्रीशीर केली जातात.',
                          style: TextStyle(color: Colors.white60, fontSize: 10, height: 1.2),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rohit Devkule • Chaitanya Kadam',
                              style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: _showTuljabhavaniChoice,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF25D366),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.chat, color: Colors.white, size: 12),
                                    SizedBox(width: 5),
                                    Text(
                                      'WhatsApp Contact',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Category Tabs
                Container(
                  height: 38,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategoryIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Products Grid
                Expanded(
                  child: displayItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                currentNavIndex == 1 ? Icons.favorite_border : Icons.search_off,
                                size: 50,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                currentNavIndex == 1
                                    ? "No favorite products added yet!"
                                    : "No products match your search",
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 2, 20, 90),
                          itemCount: displayItems.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final item = displayItems[index];
                            final isFav = favoriteItems.contains(item['id']);

                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF1F4),
                                borderRadius: BorderRadius.circular(20),
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
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item['badge'],
                                          style: const TextStyle(
                                            fontSize: 9,
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
                                          size: 20,
                                          color: isFav ? Colors.red : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          item['image'],
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.description,
                                            size: 45,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        item['price'],
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['unit'],
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 32,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF141414),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        _showWhatsAppChoice(item['title'], item['price'], item['unit']);
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.chat, size: 13, color: Colors.white),
                                          SizedBox(width: 5),
                                          Text(
                                            'Order Now',
                                            style: TextStyle(fontSize: 11, color: Colors.white),
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

            // Bottom Navigation
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(26),
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
                          color: currentNavIndex == 0 ? Colors.white : Colors.white54, size: 22),
                      onPressed: () => setState(() => currentNavIndex = 0),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite,
                          color: currentNavIndex == 1 ? Colors.redAccent : Colors.white54, size: 22),
                      onPressed: () => setState(() => currentNavIndex = 1),
                    ),
                    IconButton(
                      icon: Icon(Icons.receipt_long,
                          color: currentNavIndex == 2 ? Colors.white : Colors.white54, size: 22),
                      onPressed: () {
                        setState(() => currentNavIndex = 2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Orders are tracked via WhatsApp chat history.")),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.support_agent,
                          color: currentNavIndex == 3 ? Colors.white : Colors.white54, size: 22),
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
