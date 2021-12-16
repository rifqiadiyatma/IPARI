import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/database_provider.dart';
import 'package:ipari/ui/detail_page.dart';
import 'package:ipari/utils/result_state.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  static const routeName = '/favorite_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 75,
          width: 150,
          child: Image.asset('assets/Logo Font.png'),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) {
        if (provider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
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
      margin: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        leading: Hero(
          tag: wisata.urlImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              wisata.urlImage,
              fit: BoxFit.cover,
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
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_outlined,
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
