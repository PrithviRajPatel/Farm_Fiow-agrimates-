import 'package:flutter/material.dart';
import 'weather_page.dart';
import 'mandi_page.dart';
import 'npk_page.dart';

class DashboardPage extends StatelessWidget {
  final String? crop; // ✅ add crop field

  const DashboardPage({super.key, this.crop}); // ✅ updated constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop != null ? "Dashboard - $crop" : "Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildDashboardCard(
              context,
              title: "Weather",
              icon: Icons.cloud,
              color: Colors.blue,
              page: const WeatherPage(),
            ),
            _buildDashboardCard(
              context,
              title: "Mandi Price",
              icon: Icons.shopping_cart,
              color: Colors.orange,
              // ✅ pass crop forward if you want filtering in MandiPage
              page: MandiPage(crop: crop),
            ),
            _buildDashboardCard(
              context,
              title: "NPK Detection",
              icon: Icons.science,
              color: Colors.purple,
              page: NpkPage(), // No const because it’s StatefulWidget
            ),
          ],
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
