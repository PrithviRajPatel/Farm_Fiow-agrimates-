import 'package:flutter/material.dart';
import 'weather_page.dart';
import 'mandi_page.dart';
import 'npk_page.dart';
import 'crops_page.dart'; // ✅ Import CropSelectionPage

class DashboardPage extends StatelessWidget {
  final String? crop;

  const DashboardPage({super.key, this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop != null ? "Dashboard - $crop" : "Dashboard"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            // ✅ Always go back to crop selection page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CropSelectionPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: 3,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildDashboardCard(
                  context,
                  title: "Weather",
                  icon: Icons.cloud,
                  color: Colors.blue,
                  page: const WeatherPage(),
                );
              case 1:
                return _buildDashboardCard(
                  context,
                  title: "Mandi Price",
                  icon: Icons.shopping_cart,
                  color: Colors.orange,
                  page: MandiPage(crop: crop),
                );
              case 2:
                return _buildDashboardCard(
                  context,
                  title: "NPK Detection",
                  icon: Icons.science,
                  color: Colors.purple,
                  page: NpkPage(),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Widget page,
      }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
