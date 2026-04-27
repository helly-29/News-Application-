import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load news");
    }
  }

  String formatDate(String date) {
    final parsed = DateTime.parse(date);
    return "${parsed.day}-${parsed.month}-${parsed.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My News App - Helly Leuva"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final news = articles[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      news['urlToImage'] != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.network(
                                news['urlToImage'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news['title'] ?? "No Title",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),

                            Text(
                              formatDate(news['publishedAt']),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              news['description'] ?? "No Description",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}