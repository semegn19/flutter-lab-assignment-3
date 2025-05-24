import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'data/providers/api_service.dart';
import 'data/repositories/album_repository.dart';
import 'domain/bloc/album/album_bloc.dart';  
import 'presentation/config/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provide the API client
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        // Provide the repository
        Provider<AlbumRepository>(
          create: (context) => AlbumRepository(
            context.read<ApiService>(),
          ),
        ),
        BlocProvider<AlbumBloc>(
          create: (context) => AlbumBloc(
            context.read<AlbumRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Albums BLoC',
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}