import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final double value;
  final double maxValue;
  final Color color;
  final IconData icon;
  final String? unit;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.icon,
    this.unit,
  });

  // ✅ Color logic for farmer alerts
  Color _getStatusColor(double value) {
    if (title.toLowerCase().contains("moisture") && value < 30) {
      return Colors.red; // Low moisture alert
    } else if (title.toLowerCase().contains("temperature") && value > 40) {
      return Colors.red; // High temperature alert
    } else if (title.toLowerCase().contains("battery") && value < 20) {
      return Colors.red; // Low battery alert
    }
    return color; // Default assigned color
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _getStatusColor(value), size: 36),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // ✅ Animated Progress Bar with Alert Colors
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 800),
              builder: (context, animatedValue, child) {
                double progress = (animatedValue / maxValue).clamp(0.0, 1.0);
                Color statusColor = _getStatusColor(animatedValue);

                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      color: statusColor,
                      backgroundColor: Colors.grey.shade300,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${animatedValue.toStringAsFixed(1)} ${unit ?? ""}",
                      style: TextStyle(
                        fontSize: 20, // 👈 bigger for easy reading
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
