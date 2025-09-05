
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  // TODO: Add your Gemini API key here
  static const String _apiKey = 'AIzaSyC-a3CqW2S9j2lLuL6ffFPtT5ayvIE1Ygs';

  late final GenerativeModel _model;
  late final ChatSession _chat;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    _chat = _model.startChat();
    _chatHistory.add({'role': 'model', 'text': 'Hello! How can I help you today?'});
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _chatHistory.add({'role': 'user', 'text': _controller.text});
    });

    try {
      final responseStream = _chat.sendMessageStream(Content.text(_controller.text));
      await for (final response in responseStream) {
        final text = response.text;
        if (text != null) {
          setState(() {
            if (_chatHistory.last['role'] == 'model') {
              _chatHistory.last['text'] = _chatHistory.last['text']! + text;
            } else {
              _chatHistory.add({'role': 'model', 'text': text});
            }
          });
        }
      }
    } catch (e) {
      setState(() {
        _chatHistory.add({'role': 'model', 'text': 'Error: ${e.toString()}'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final message = _chatHistory[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isUser)
                          const CircleAvatar(
                            child: Icon(Icons.assistant),
                          ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Text(message['text']!),
                        ),
                        const SizedBox(width: 8.0),
                        if (isUser)
                          const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
