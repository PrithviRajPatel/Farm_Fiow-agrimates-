import 'package:flutter/material.dart';

class MarketRatesPage extends StatelessWidget {
  const MarketRatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MarketRates', style: TextStyle(fontWeight: FontWeight.bold)),
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
              _buildLiveMarketRatesCard(),
              const SizedBox(height: 24),
              _buildMarketSelectionCard(),
              const SizedBox(height: 24),
              _buildMarketRatesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveMarketRatesCard() {
    return Card(
      color: Colors.green.shade400,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Market Rates',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Real-time crop prices from agricultural markets across India',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MarketStat(label: 'Last Updated', value: '2:37:08 AM'),
                MarketStat(label: 'Market Status', value: 'active'),
                MarketStat(label: 'Total Arrivals', value: '0 qtl'),
                MarketStat(label: 'Active Traders', value: '0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketSelectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Market Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Major Mandi'),
                      DropdownButtonFormField<String>(
                        value: 'Moga (Punjab)',
                        items: ['Moga (Punjab)']
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Or Enter Custom Location'),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter city/district name',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Search Crops'),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Search for specific crops...'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketRatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Rates - Moga Agricultural Market',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('22 crops listed'),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            CropCard(name: 'Wheat', price: '2,430', minPrice: '2,425', maxPrice: '2,435'),
            CropCard(name: 'Paddy (Dhan)', price: '0', minPrice: '0', maxPrice: '0'),
            CropCard(name: 'Cotton', price: '0', minPrice: '0', maxPrice: '0'),
            CropCard(name: 'Maize', price: '0', minPrice: '0', maxPrice: '0'),
          ],
        ),
      ],
    );
  }
}

class MarketStat extends StatelessWidget {
  final String label;
  final String value;

  const MarketStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class CropCard extends StatelessWidget {
  final String name;
  final String price;
  final String minPrice;
  final String maxPrice;

  const CropCard({
    super.key,
    required this.name,
    required this.price,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text('Price per Quintal'),
            const Spacer(),
            Text('Modal Price', style: const TextStyle(fontSize: 12)),
            Text('₹$price', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceChip(label: 'Min Price', value: '₹$minPrice', color: Colors.red.shade100),
                PriceChip(label: 'Max Price', value: '₹$maxPrice', color: Colors.green.shade100),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: 0.5, backgroundColor: Colors.red.shade100, valueColor: AlwaysStoppedAnimation(Colors.green.shade100)),
          ],
        ),
      ),
    );
  }
}

class PriceChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const PriceChip({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      backgroundColor: color,
    );
  }
}
