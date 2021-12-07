import 'package:flutter/material.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/database_provider.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({Key? key, required this.wisata}) : super(key: key);

  final Wisata wisata;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(wisata.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;
            return isFavorited
                ? IconButton(
                    onPressed: () {
                      provider.removeFavorite(wisata.id);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      provider.addFavorite(wisata);
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                  );
          },
        );
      },
    );
  }
}
