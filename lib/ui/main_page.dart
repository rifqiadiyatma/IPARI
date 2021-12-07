import 'package:flutter/material.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/wisata_provider.dart';
import 'package:ipari/ui/detail_page.dart';
import 'package:ipari/utils/result_state.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/main_page';
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearch(),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<WisataProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.response.data.length,
            itemBuilder: (context, index) {
              var wisata = state.response.data[index];
              return _buildWisataItem(context, wisata);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.error) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                  'Unable to get data from internet, check your connection'),
            ),
          );
        } else {
          return const Center(
            child: Text('No data to displayed'),
          );
        }
      },
    );
  }

  Widget _buildSearch() {
    return Consumer<WisataProvider>(
      builder: (context, state, _) {
        return Container(
          height: 42,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.black26),
          ),
          child: Form(
            child: TextFormField(
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: "Mau Pergi Kemana Hari Ini?",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (query) {
                state.search(query);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWisataItem(BuildContext context, Wisata wisata) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, DetailPage.routeName, arguments: wisata),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: wisata.urlImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(wisata.urlImage,
                      fit: BoxFit.fill, height: 110),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  wisata.name.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  wisata.province,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
