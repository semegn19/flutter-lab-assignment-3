import 'package:albums/domain/bloc/album/album_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:albums/domain/bloc/album/album_bloc.dart';
import 'package:albums/data/models/album.dart';
import 'package:albums/domain/bloc/album/album_state.dart';


class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: const Text('My Albums'),
        centerTitle: true,
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          // Handle initial state - trigger initial load
          if (state is AlbumInitial) {
            context.read<AlbumBloc>().add(FetchAlbums());
          }

          // Loading state
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<AlbumBloc>().add(FetchAlbums()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Loaded state
          if (state is AlbumDataLoaded) {
            final albums = state.albums;
            if (albums.isEmpty) {
              return const Center(child: Text('No albums found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return _AlbumTile(
                  album: album,
                  thumbnailUrl: state.thumbnailMap[album.id],
                );
              },
            );
          }

          // Fallback for unknown states
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  final Album album;
  final String? thumbnailUrl;

  const _AlbumTile({
    Key? key,
    required this.album,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildThumbnail(),
      title: Text(album.title),
      onTap: () => context.pushNamed('detail', extra: album), //nav
    );
  }

  Widget _buildThumbnail() {
    if (thumbnailUrl == null) {
      return const CircleAvatar(child: Icon(Icons.image_not_supported));
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(thumbnailUrl!),
    );
  }
}