import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/photo.dart';


class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Album>> getAlbums() async {
    final uri = Uri.parse('$_baseUrl/albums');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load albums (Status ${response.statusCode})');
    }

    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((e) => Album.fromJson(e)).toList();
  }
  Future<List<Photo>> getPhotosByAlbum(int albumId) async { 
    final uri = Uri.parse('$_baseUrl/photos?albumId=$albumId');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load photos (Status ${response.statusCode})');
    }

    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((e) => Photo.fromJson(e)).toList();
  }

  Future<List<Photo>> getAllPhotos() async {
    final uri = Uri.parse('$_baseUrl/photos');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load all photos (${response.statusCode})');
    }

    return (json.decode(response.body) as List)
        .map((e) => Photo.fromJson(e))
        .toList();
  }
  void dispose() {
    _client.close();
  }
}
