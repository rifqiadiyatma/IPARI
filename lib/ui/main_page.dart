import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/wisata_provider.dart';
import 'package:ipari/ui/detail_page.dart';
import 'package:ipari/utils/result_state.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

/*
  Credit this Screen
  Cached Network Image => https://pub.dev/packages/cached_network_image
  Provider => https://pub.dev/packages/provider
  API => https://ipariwisata.000webhostapp.com/
  Image Resources => https://unsplash.com/
  Carousel Slider => https://pub.dev/packages/carousel_slider
*/

class MainPage extends StatelessWidget {
  static const routeName = '/main_page';
  const MainPage({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearch(),
            const SizedBox(height: 10),
            _imgCarousel(),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'List Wisata',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
              crossAxisCount: 2,
            ),
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
            border: Border.all(color: primaryColor),
          ),
          child: Form(
            child: TextFormField(
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: "Mau Pergi Kemana Hari Ini?",
                hintStyle: TextStyle(color: primaryColor),
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
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
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 2.0,
          color: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Hero(
                  tag: wisata.urlImage,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
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
                      height: 110,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  wisata.name.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Text(
                  wisata.province,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CarouselSlider _imgCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
      ),
      items: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1559964365-c42b96fa3ddd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=725&q=80',
                ),
                fit: BoxFit.fill),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1519112232436-9923c6ba3d26?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
                ),
                fit: BoxFit.fill),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1610601403310-7626f825bef5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
                ),
                fit: BoxFit.fill),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1551523891-ef1cebdca797?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=725&q=80',
                ),
                fit: BoxFit.fill),
          ),
        ),
      ],
    );
  }
}
