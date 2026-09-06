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

  // Tuljabhavani Devi Image Direct CDN URL
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
                  final msg =
                      "Hello Paper Hub,\nI want to place an order for:\n\n*Product:* $title\n*Price:* $price ($unit)";
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
                  final msg =
                      "Hello Paper Hub,\nI want to place an order for:\n\n*Product:* $title\n*Price:* $price ($unit)";
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
    const customEnquiryMsg = "नमस्कार,\n\n"
        "‘श्री तुळजाभवानी कॉम्प्युटर्स’ येथे उपलब्ध असलेल्या ऑनलाईन, प्रिंटिंग, झेरॉक्स तसेच इतर संगणक-संबंधित सेवांबाबत आवश्यक माहिती प्राप्त करून घ्यावयाची आहे.\n\n"
        "त्याअनुषंगाने, उपलब्ध सेवांचा तपशील, लागू असलेले सेवा शुल्क, कार्यपद्धती तसेच आवश्यक असलेली इतर माहिती उपलब्ध करून द्यावी, ही विनंती.\n\n"
        "धन्यवाद.";

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
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        tuljabhavaniImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.brightness_7, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
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
                  _openWhatsAppRaw(partner1Number, customEnquiryMsg);
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
                  _openWhatsAppRaw(partner2Number, customEnquiryMsg);
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF800020), Color(0xFF1A102F)],
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
                            Container(
                              width: 52,
                              height: 52,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.amber, width: 2),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  tuljabhavaniImageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Icon(Icons.brightness_7, color: Colors.white, size: 26),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
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
                        const SizedBox(height: 8),
                        const Text(
                          'सर्व प्रकारच्या ऑनलाईन सेवा, गॅझेट आणि सरकारी फॉर्म्सची कामे खात्रीशीर केली जातात.',
                          style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.2),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rohit Devkule • Chaitanya Kadam',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: _showTuljabhavaniChoice,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
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

                // Category Chips
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF800020),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Product Grid View
                Expanded(
                  child: displayItems.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            final item = displayItems[index];
                            final isFav = favoriteItems.contains(item['id']);

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: Container(
                                            color: const Color(0xFFF0F2F5),
                                            width: double.infinity,
                                            child: Image.network(
                                              item['image'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Icon(Icons.picture_as_pdf, color: Colors.grey, size: 36),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isFav) {
                                                  favoriteItems.remove(item['id']);
                                                } else {
                                                  favoriteItems.add(item['id']);
                                                }
                                              });
                                            },
                                            child: CircleAvatar(
                                              radius: 14,
                                              backgroundColor: Colors.white.withOpacity(0.9),
                                              child: Icon(
                                                isFav ? Icons.favorite : Icons.favorite_border,
                                                size: 16,
                                                color: isFav ? Colors.red : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item['price'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF800020),
                                              ),
                                            ),
                                            Text(
                                              item['unit'],
                                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 32,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _showWhatsAppChoice(item['title'], item['price'], item['unit']);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF800020),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: const Text(
                                              'Order Now',
                                              style: TextStyle(fontSize: 11, color: Colors.white),
                                            ),
                                          ),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        selectedItemColor: const Color(0xFF800020),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => currentNavIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Orders'),
        ],
      ),
    );
  }
}
