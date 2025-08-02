import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';

class AllArtistsScreen extends StatefulWidget {
  const AllArtistsScreen({super.key});

  @override
  State<AllArtistsScreen> createState() => _AllArtistsScreenState();
}

class _AllArtistsScreenState extends State<AllArtistsScreen> {
  late Future<List<Artist>> _artistsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _artistsFuture = _dataService.getArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Artists')),
      body: FutureBuilder<List<Artist>>(
        future: _artistsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 80,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 12,
              itemBuilder: (context, index) => const ArtistCardSkeleton(),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No artists available',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final artists = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 80,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: artists.length,
            itemBuilder: (context, index) => ArtistCard(
              artist: artists[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArtistDetailScreen(artist: artists[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
