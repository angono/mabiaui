import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlayerService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mabiaplay',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey.shade600,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      routes: {
        '/all-songs': (context) => const AllSongsScreen(),
        '/all-artists': (context) => const AllArtistsScreen(),
        '/all-albums': (context) => const AllAlbumsScreen(),
        '/artist-detail': (context) {
          final artist = ModalRoute.of(context)!.settings.arguments as Artist;
          return ArtistDetailScreen(artist: artist);
        },
        '/album-detail': (context) {
          final album = ModalRoute.of(context)!.settings.arguments as Album;
          return AlbumDetailScreen(album: album);
        },
        '/all-genres': (context) => const AllGenresScreen(),
        '/genre-detail': (context) {
          final genre = ModalRoute.of(context)!.settings.arguments as Genre;
          return GenreDetailScreen(genre: genre);
        },
      },
    );
  }
}
