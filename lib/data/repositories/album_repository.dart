import 'package:albums/data/providers/api_service.dart';
import 'package:albums/data/models/photo.dart';
import 'package:albums/data/models/album.dart';

class AlbumRepository {
  final ApiService _api;
  AlbumRepository(this._api);

  Future<List<Photo>> fetchAllPhotos() async {
    return await _api.getAllPhotos();
  }

  Future<List<Album>> fetchAlbums() async {
    return await _api.getAlbums();
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    return await _api.getPhotosByAlbum(albumId);
  }

  void dispose() => _api.dispose();
}