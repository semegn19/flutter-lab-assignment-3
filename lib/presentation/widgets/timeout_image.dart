import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimeoutImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final Duration timeout;

  const TimeoutImage({
    super.key,
    required this.url,
    this.width = 50,
    this.height = 50,
    this.timeout = const Duration(seconds: 5),
  });

  Future<Uint8List> _fetchBytes() async {
    final res = await http.get(Uri.parse(url)).timeout(timeout);
    if (res.statusCode == 200) {
      return res.bodyBytes;
    }
    throw Exception('HTTP ${res.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _fetchBytes(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (snap.hasError || snap.data == null) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'Picture\nunavailable',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
          );
        }
        return Image.memory(
          snap.data!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      },
    );
  }
}