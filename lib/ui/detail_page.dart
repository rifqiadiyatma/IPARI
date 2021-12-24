import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipari/widget/favorite_button.dart';
import 'dart:async';
import 'package:maps_launcher/maps_launcher.dart';

/*
  Credit this Screen
  Maps Launcher => https://pub.dev/packages/maps_launcher
  Cached Network Image => https://pub.dev/packages/cached_network_image
  Image Resources => https://unsplash.com/
  API => https://ipariwisata.000webhostapp.com/
*/

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.wisata}) : super(key: key);
  static const routeName = '/detail_wisata';

  final Wisata wisata;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late LatLng kordinatLatLng;
  late CameraPosition _detailPosition;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    kordinatLatLng = LatLng(double.parse(widget.wisata.latitude),
        double.parse(widget.wisata.longitude));
    _detailPosition = CameraPosition(target: kordinatLatLng, zoom: 14.476);
    _addMarker(kordinatLatLng);
  }

  Widget _map() {
    return SizedBox(
      height: 380,
      child: GoogleMap(
        initialCameraPosition: _detailPosition,
        mapType: MapType.normal,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  void _addMarker(LatLng position) async {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("position"),
          position: position,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.wisata.name,
                textAlign: TextAlign.start,
              ),
              centerTitle: true,
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      primaryColor,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Hero(
                  tag: widget.wisata.urlImage,
                  child: Image.network(
                    widget.wisata.urlImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Category Card
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  height: 48,
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.all(2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.wisata.category,
                        style: const TextStyle(color: secondaryColor),
                      ),
                    ),
                  ),
                ),

                //Deskripsi Title
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    'Description',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),

                //Deskripsi Isi
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    widget.wisata.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Maps Title
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    'Map',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            child: _map(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: Row(
                              // mainAxisAlignment: Axis.horizontal.start,
                              children: [
                                SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () => MapsLauncher.launchQuery(
                                        widget.wisata.name +
                                            ' ' +
                                            widget.wisata.province),
                                    child: const Icon(Icons.map),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        widget.wisata.province,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: FavoriteButton(wisata: widget.wisata),
        backgroundColor: primaryColor,
        onPressed: () {},
      ),
    );
  }
}
