import 'package:flutter/material.dart';
import '../models/genre_model.dart';
import '../services/data_service.dart';
import '../widgets/genre_card.dart';
import '../widgets/genre_card_skeleton.dart';
import 'genre_detail_screen.dart';

class AllGenresScreen extends StatefulWidget {
  const AllGenresScreen({super.key});

  @override
  State<AllGenresScreen> createState() => _AllGenresScreenState();
}

class _AllGenresScreenState extends State<AllGenresScreen> {
  late Future<List<Genre>> _genresFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _genresFuture = _dataService.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Genres')),
      body: FutureBuilder<List<Genre>>(
        future: _genresFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final itemCount = isLoading ? 8 : (snapshot.data?.length ?? 0);

          if (!isLoading && (snapshot.hasError || itemCount == 0)) {
            return Center(
              child: Text(
                'No genres available',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (isLoading) {
                return const GenreCardSkeleton();
              }
              final genre = snapshot.data![index];
              return GenreCard(
                genre: genre,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenreDetailScreen(genre: genre),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
