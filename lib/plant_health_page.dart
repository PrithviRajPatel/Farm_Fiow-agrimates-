
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class PlantHealthPage extends StatefulWidget {
  const PlantHealthPage({super.key});

  @override
  State<PlantHealthPage> createState() => _PlantHealthPageState();
}

class _PlantHealthPageState extends State<PlantHealthPage> {
  // TODO: Add your Gemini API key here
  static const String _apiKey = 'AIzaSyC-a3CqW2S9j2lLuL6ffFPtT5ayvIE1Ygs';

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _analysisResult;
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = null;
      });
      await _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: _apiKey);
    final imageBytes = await _image!.readAsBytes();
    final content = [Content.multi([
      TextPart('Analyze this plant image and provide a health assessment. If a disease is detected, identify it, and suggest a treatment.'),
      DataPart('image/jpeg', imageBytes),
    ])];

    try {
      final response = await model.generateContent(content);
      setState(() {
        _analysisResult = response.text ?? 'No analysis result.';
      });
    } catch (e) {
      setState(() {
        _analysisResult = 'Error during analysis: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Health'),
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
              if (_image != null) _buildAnalysisSection(),
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
                  'AI-powered disease and pest detection',
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
                      onTap: () => _pickImage(ImageSource.camera),
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
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: Colors.green, size: 40),
                            Text('Upload Image', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis Result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: _isAnalyzing
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          _analysisResult ?? 'Analysis complete.',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
