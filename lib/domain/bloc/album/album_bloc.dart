import 'package:flutter_bloc/flutter_bloc.dart';
import 'album_event.dart';
import 'album_state.dart';
import '../../../data/repositories/album_repository.dart';
import '../../../data/models/photo.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository repository;
  List<Photo> _allPhotos = []; // Store all photos for detail access

  AlbumBloc(this.repository) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchAlbumPhotos>(_onFetchAlbumPhotos); 
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await repository.fetchAlbums();
      _allPhotos = await repository.fetchAllPhotos(); // Store all photos
      
      final thumbMap = <int, String>{};
      for (final photo in _allPhotos) {
        thumbMap.putIfAbsent(photo.albumId, () => photo.thumbnailUrl);
      }
      
      emit(AlbumDataLoaded(albums, thumbMap, _allPhotos));
    } catch (e) {
      emit(AlbumError());
    }
  }

  Future<void> _onFetchAlbumPhotos(
    FetchAlbumPhotos event,
    Emitter<AlbumState> emit,
  ) async {
    if (state is AlbumDataLoaded) {
      final currentState = state as AlbumDataLoaded;
      final albumPhotos = _allPhotos.where((p) => p.albumId == event.albumId).toList();
      emit(currentState.copyWith(currentAlbumPhotos: albumPhotos));
    }
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}