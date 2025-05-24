import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAlbums extends AlbumEvent {}
class FetchAlbumPhotos extends AlbumEvent {
  final int albumId;
  FetchAlbumPhotos(this.albumId);
  @override List<Object?> get props => [albumId];
}
