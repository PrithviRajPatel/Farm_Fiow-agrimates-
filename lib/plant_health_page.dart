import 'package:flutter/material.dart';

class PlantHealthPage extends StatelessWidget {
  const PlantHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PlantHealth', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Real-time farming intelligence', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.agriculture),
            label: const Text('Agribot AI'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language),
            label: const Text('us English'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScannerCard(),
              const SizedBox(height: 24),
              _buildImageCaptureSection(),
              const SizedBox(height: 24),
              _buildDetectionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerCard() {
    return Card(
      color: Colors.green.shade400,
      child: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 40),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plant Health Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI-powered disease and pest detection for your crops',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCaptureSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capture or Upload Plant Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade400,
                    child: InkWell(
                      onTap: () {},
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white, size: 40),
                            SizedBox(height: 8),
                            Text('Take Photo', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, style: BorderStyle.solid, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: Colors.green, size: 40),
                            SizedBox(height: 8),
                            Text('Upload Image', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('For best results:'),
            const Text('  • Take clear, well-lit photos'),
            const Text('  • Focus on affected plant parts'),
            const Text('  • Avoid blurry or dark images'),
            const Text('  • Include multiple angles if possible'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What Can We Detect?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetectionCategory(
              color: Colors.red,
              title: 'Plant Diseases',
              items: [
                'Leaf spot diseases',
                'Blight and rust',
                'Powdery mildew',
                'Bacterial infections',
                'Viral symptoms',
              ],
            ),
            const SizedBox(height: 16),
            _buildDetectionCategory(
              color: Colors.orange,
              title: 'Pest Infestations',
              items: [
                'Aphids and thrips',
                'Caterpillar damage',
                'Spider mites',
                'Whitefly infestations',
                'Leaf miner damage',
              ],
            ),
            const SizedBox(height: 16),
            _buildDetectionCategory(
              color: Colors.yellow.shade800,
              title: 'Nutrient Deficiencies',
              items: [
                'Nitrogen deficiency',
                'Phosphorus shortage',
                'Potassium deficiency',
                'Iron chlorosis',
                'Magnesium deficiency',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionCategory({
    required Color color,
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: color, size: 16),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 4),
              child: Text('• $item'),
            )),
      ],
    );
  }
}
