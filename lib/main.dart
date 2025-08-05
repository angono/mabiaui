import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayerService()),
        Provider(create: (context) => DataService()),
      ],
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
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954), // Spotify-style green
          brightness: Brightness.dark,
          primary: const Color(0xFF1DB954),
          secondary: const Color(0xFF1DB954),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF181818),
          selectedItemColor: const Color(0xFF1DB954),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey.shade300,
          ),
          bodyMedium: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        // cardTheme: CardTheme(
        //   color: const Color(0xFF282828),
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        // ),
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
