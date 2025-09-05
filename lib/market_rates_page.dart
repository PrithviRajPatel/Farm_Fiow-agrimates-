
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class MarketRatesPage extends StatefulWidget {
  const MarketRatesPage({super.key});

  @override
  State<MarketRatesPage> createState() => _MarketRatesPageState();
}

class _MarketRatesPageState extends State<MarketRatesPage> {
  // TODO: Add your data.gov.in API key here
  final String _marketApiKey = '579b464db66ec23bdd000001b7f15aa82e92493d4ab203dbbc7b2af1';
  // TODO: Add your Gemini API key here
  final String _geminiApiKey = 'AIzaSyC-a3CqW2S9j2lLuL6ffFPtT5ayvIE1Ygs';

  String _selectedState = 'Punjab';
  String _selectedMarket = '';
  List<dynamic> _markets = [];
  List<dynamic> _commodities = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _aiAdvice = 'Loading advice...';

  @override
  void initState() {
    super.initState();
    _fetchMarkets();
  }

  Future<void> _fetchMarkets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$_marketApiKey&format=json&filters[state]=$_selectedState'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _markets = data['records'].map((record) => record['market']).toSet().toList();
          if (_markets.isNotEmpty) {
            _selectedMarket = _markets[0];
            _fetchCommodities();
          }
        });
      } else {
        throw Exception('Failed to load markets');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCommodities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$_marketApiKey&format=json&filters[state]=$_selectedState&filters[market]=$_selectedMarket'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _commodities = data['records'];
          _isLoading = false;
        });
        _fetchAiAdvice();
      } else {
        throw Exception('Failed to load commodities');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAiAdvice() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _geminiApiKey);
    final prompt =
        'Given the current market prices in $_selectedMarket, $_selectedState, what are your trading recommendations for the following commodities: ${_commodities.map((c) => c['commodity']).join(', ')}?';
    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      setState(() {
        _aiAdvice = response.text ?? 'No advice generated.';
      });
    } catch (e) {
      setState(() {
        _aiAdvice = 'Failed to get AI advice.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Rates'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMarketSelectionCard(),
                        const SizedBox(height: 24),
                        _buildMarketRatesSection(),
                        const SizedBox(height: 24),
                        _buildAiTraderCard(),
                      ],
                    ),
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
            DropdownButtonFormField<String>(
              value: _selectedState,
              items: ['Punjab', 'Haryana', 'Uttar Pradesh', 'Maharashtra'] // Add more states as needed
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedState = value;
                    _fetchMarkets();
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_markets.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedMarket,
                items: _markets.map((market) => DropdownMenuItem(value: market, child: Text(market))).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMarket = value;
                      _fetchCommodities();
                    });
                  }
                },
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
        Text(
          'Market Rates - $_selectedMarket, $_selectedState',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _commodities.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final commodity = _commodities[index];
            return CropCard(
              name: commodity['commodity'] ?? 'N/A',
              price: (commodity['modal_price'] ?? 0).toString(),
              minPrice: (commodity['min_price'] ?? 0).toString(),
              maxPrice: (commodity['max_price'] ?? 0).toString(),
              arrivalDate: commodity['arrival_date'] ?? 'N/A',
            );
          },
        ),
      ],
    );
  }

  Widget _buildAiTraderCard() {
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Trader Advice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 16),
            Text(_aiAdvice),
          ],
        ),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String name;
  final String price;
  final String minPrice;
  final String maxPrice;
  final String arrivalDate;

  const CropCard({
    super.key,
    required this.name,
    required this.price,
    required this.minPrice,
    required this.maxPrice,
    required this.arrivalDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text('Arrival: $arrivalDate', style: const TextStyle(fontSize: 12)),
            const Spacer(),
            const Text('Modal Price', style: TextStyle(fontSize: 12)),
            Text('₹$price', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceChip(label: 'Min Price', value: '₹$minPrice', color: Colors.red.shade100),
                PriceChip(label: 'Max Price', value: '₹$maxPrice', color: Colors.green.shade100),
              ],
            ),
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
      padding: const EdgeInsets.all(4),
      label: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
      backgroundColor: color,
    );
  }
}
