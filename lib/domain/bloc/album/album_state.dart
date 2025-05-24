import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../data/models/album.dart';
import'package:albums/data/models/photo.dart';

abstract class AlbumState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}
class AlbumLoading extends AlbumState {}
class AlbumError extends AlbumState {
  final String message = "Can't reload. Please check your network and try again.";
  @override List<Object?> get props => [message];
}

class AlbumDataLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, String> thumbnailMap;
  final List<Photo>? currentAlbumPhotos;

  AlbumDataLoaded(this.albums, this.thumbnailMap, [this.currentAlbumPhotos]);

  AlbumDataLoaded copyWith({List<Photo>? currentAlbumPhotos}) {
    return AlbumDataLoaded(
      albums,
      thumbnailMap,
      currentAlbumPhotos ?? this.currentAlbumPhotos,
    );
  }

  @override
  List<Object?> get props => [albums, thumbnailMap, currentAlbumPhotos];
}