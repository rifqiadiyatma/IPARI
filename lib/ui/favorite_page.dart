import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/database_provider.dart';
import 'package:ipari/ui/detail_page.dart';
import 'package:ipari/utils/result_state.dart';
import 'package:provider/provider.dart';

/*
  Credit this Screen
  Provider => https://pub.dev/packages/provider
  Cached Network Image => https://pub.dev/packages/cached_network_image
*/

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  static const routeName = '/favorite_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              _favHead(),
              const SizedBox(
                height: 24,
              ),
              _buildList()
              // _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favHead() {
    return Column(
      children: [
        Image.asset(
          'assets/Ilove.png',
          height: 100,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Your Favorite List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) {
        if (provider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return _buildWisataItem(context, provider.favorites[index]);
            },
          );
        } else {
          return Center(
            child: Text(
              provider.message,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        }
      },
    );
  }

  Widget _buildWisataItem(BuildContext context, Wisata wisata) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        leading: Hero(
          tag: wisata.urlImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: CachedNetworkImage(
              imageUrl: wisata.urlImage,
              placeholder: (context, url) => const SizedBox(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.dangerous_rounded),
              fit: BoxFit.fill,
              width: 100,
            ),
          ),
        ),
        title: Wrap(
          children: [
            Text(
              wisata.name.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Colors.black,
            ),
            Text(
              wisata.province,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, DetailPage.routeName, arguments: wisata);
        },
      ),
    );
  }
}
