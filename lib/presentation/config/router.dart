import 'package:go_router/go_router.dart';

import 'package:albums/data/models/album.dart';
import 'package:albums/presentation/screens/album_list_screen.dart';
import 'package:albums/presentation/screens/album_detail_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'list',
      builder: (context, state) => const AlbumListScreen(),
    ),
    GoRoute(
      path: '/detail',
      name: 'detail',
      builder: (context, state) {
        final album = state.extra as Album;
        return AlbumDetailScreen(album: album);
      },
    ),
  ],
);