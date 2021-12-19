import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipari/widget/favorite_button.dart';
import 'dart:async';
import 'package:maps_launcher/maps_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.wisata}) : super(key: key);
  static const routeName = 'detail_wisata';

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
      height: 300,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => MapsLauncher.launchQuery(
            widget.wisata.name + ' ' + widget.wisata.province),
        child: const Icon(Icons.map),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: widget.wisata.urlImage,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.wisata.urlImage,
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
                        width: MediaQuery.of(context).size.width * 1,
                        height: 300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: FavoriteButton(wisata: widget.wisata),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0),
                margin: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.wisata.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Text(
                      widget.wisata.province,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                height: 50,
                child: Card(
                  color: primaryColor,
                  margin: const EdgeInsets.all(4.0),
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
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.wisata.description,
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 8.0),
              _map(),
            ],
          ),
        ),
      ),
    );
  }
}
