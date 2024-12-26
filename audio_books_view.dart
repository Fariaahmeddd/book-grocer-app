import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import '../../common/color_extenstion.dart';

class AudioBooksView extends StatefulWidget {
  const AudioBooksView({super.key});

  @override
  State<AudioBooksView> createState() => _AudioBooksViewState();
}

class _AudioBooksViewState extends State<AudioBooksView> {
  TextEditingController _controller = TextEditingController();
  late AudioPlayer _audioPlayer;
  bool _isLoading = false;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  // API call to fetch audio URL based on the book title
  Future<void> searchAudioBook(String query) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.example.com/search_audio'), // Use your actual API endpoint here
      headers: {
        'Client-ID': '97746b62a0b04982a35babd33366c422',
        'Client-Secret': '0920ae0e1019453195ddb3502aca39c9',
      },
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['audioUrl'] != null) {
        setState(() {
          _audioUrl = data['audioUrl'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No audio found'),
            content: Text('No audio file available for this book.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Something went wrong. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        title: Text('Audio Books', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for a book...',
                filled: true,
                fillColor: TColor.textbox,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                searchAudioBook(value);
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _audioUrl == null
                ? Text('Search for a book to listen to the audio')
                : Column(
              children: [
                Text('Audio found:'),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: TColor.primary),
                  onPressed: () {
                    _audioPlayer.setUrl(_audioUrl!).then((_) {
                      _audioPlayer.play();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause, color: TColor.primary),
                  onPressed: () {
                    _audioPlayer.pause();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.stop, color: TColor.primary),
                  onPressed: () {
                    _audioPlayer.stop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return AudioBooksView();  // Show the search results in this view
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Example Book 1'),
          onTap: () {
            query = 'Example Book 1';
            showResults(context);
          },
        ),
        ListTile(
          title: Text('Example Book 2'),
          onTap: () {
            query = 'Example Book 2';
            showResults(context);
          },
        ),
      ],
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Implement the leading icon (typically a back arrow or close button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);  // Close the search and return null
      },
    );
  }
}
