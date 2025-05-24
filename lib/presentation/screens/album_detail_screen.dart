import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:albums/data/models/album.dart';
import 'package:albums/data/models/photo.dart';
import 'package:albums/presentation/widgets/timeout_image.dart';
import 'package:albums/domain/bloc/album/album_bloc.dart';
import 'package:albums/domain/bloc/album/album_state.dart';
import 'package:albums/domain/bloc/album/album_event.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  const AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    context.read<AlbumBloc>().add(FetchAlbumPhotos(album.id));

    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        List<Photo> photos = [];
        if (state is AlbumDataLoaded) {
          photos = state.currentAlbumPhotos ?? [];
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade200,
            leading: BackButton(onPressed: () => context.pop()),  //nav
            title: Text('Album: ${album.title}'),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album metadata section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Album ID: ${album.id}\nUser ID: ${album.userId}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              // Photos header with retry button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Photos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                  ],
                ),
              ),
              // Photo grid or loading/error states
              Expanded(
                child: _buildPhotoGrid(context, state, photos),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoGrid(BuildContext context, AlbumState state, List<Photo> photos) {
    if (state is AlbumDataLoaded && photos.isEmpty) {
      return const Center(child: Text('No photos found'));
    }

    if (state is AlbumError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<AlbumBloc>().add(
              FetchAlbumPhotos(album.id)),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is AlbumLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return TimeoutImage(
          url: photos[index].thumbnailUrl,
          width: double.infinity,
          height: double.infinity,
          timeout: const Duration(seconds: 5),
        );
      },
    );
  }
}