import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Import feature pages
import 'weather_page.dart';
import 'mandi_page.dart';
import 'npk_page.dart';
import 'irrigation_page.dart';

class DashboardPage extends StatefulWidget {
  final String crop;
  const DashboardPage({super.key, required this.crop});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Dashboard features with navigation targets
  late final List<Map<String, dynamic>> features;

  @override
  void initState() {
    super.initState();
    features = [
      {
        "icon": Icons.cloud,
        "label": "Weather",
        "page": const WeatherPage(),
      },
      {
        "icon": Icons.shopping_cart,
        "label": "Mandi Price",
        "page": MandiPage(crop: widget.crop), // pass crop
      },
      {
        "icon": Icons.science,
        "label": "NPK Detection",
        "page": NpkPage(),
      },
      {
        "icon": Icons.water_drop,
        "label": "Irrigation & Pesticide",
        "page": const IrrigationPage(),
      },
    ];
  }

  // 🔹 Drawer item builder
  Widget _buildDrawerItem(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  // 🔹 Save crop selection reset
  Future<void> _changeCrop() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("selectedCrop");
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/crops");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard - ${widget.crop}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // 🔹 Compact Drawer Header
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                      const Icon(Icons.dashboard, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Dashboard - ${widget.crop}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.cloud, "Weather", Colors.blue, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeatherPage()));
                  }),
                  _buildDrawerItem(
                      Icons.shopping_cart, "Mandi Price", Colors.orange, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MandiPage(crop: widget.crop)));
                  }),
                  _buildDrawerItem(Icons.science, "NPK Detection",
                      Colors.purple, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NpkPage()));
                      }),
                  _buildDrawerItem(Icons.water_drop, "Irrigation & Pesticide",
                      Colors.teal, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IrrigationPage()));
                      }),
                  const Divider(),
                  _buildDrawerItem(Icons.agriculture, "Change Crop", Colors.green,
                      _changeCrop),
                  _buildDrawerItem(Icons.settings, "Settings", Colors.grey, () {
                    Navigator.pushNamed(context, "/settings");
                  }),
                  _buildDrawerItem(Icons.logout, "Logout", Colors.red, () async {
                    await _auth.signOut();
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, "/login");
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔹 Balanced Grid System
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1, // perfect square
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => feature["page"]),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      radius: 32,
                      child:
                      Icon(feature["icon"], size: 32, color: Colors.green),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      feature["label"],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
