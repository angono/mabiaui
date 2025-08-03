import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:provider/provider.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  late Future<List<Song>> _songsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Songs', style: TextStyle(fontSize: 18)),
      ),
      body: FutureBuilder<List<Song>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final itemCount = isLoading ? 10 : (snapshot.data?.length ?? 0);

          if (!isLoading && (snapshot.hasError || itemCount == 0)) {
            return Center(
              child: Text(
                'No songs available',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1 / 1.4,
              mainAxisSpacing: 10, // Spacing between items
              crossAxisSpacing: 10, // Spacing between rows
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (isLoading) {
                return const MusicCardSkeleton();
              }
              final song = snapshot.data![index];
              return MusicCard(
                song: song,
                onTap: () {
                  final playerService = Provider.of<PlayerService>(
                    context,
                    listen: false,
                  );
                  playerService.playSong(song);
                },
              );
            },
          );
        },
      ),
    );
  }
}
