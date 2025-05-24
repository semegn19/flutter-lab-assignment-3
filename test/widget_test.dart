import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:albums/main.dart';
import 'package:albums/data/providers/api_service.dart';
import 'package:albums/data/repositories/album_repository.dart';
import 'package:albums/domain/bloc/album/album_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Albums BLoC app smoke test', (WidgetTester tester) async {
    // Arrange providers with BLoC
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiService>(create: (_) => ApiService()),
          Provider<AlbumRepository>(
            create: (ctx) => AlbumRepository(ctx.read<ApiService>()),
          ),
          BlocProvider<AlbumBloc>( // Replace ViewModel with BLoC
            create: (ctx) => AlbumBloc(ctx.read<AlbumRepository>()),
          ),
        ],
        child: const MyApp(),
      ),
    );

    // Allow initial loading states
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(find.text('My Albums'), findsOneWidget);
  });
}