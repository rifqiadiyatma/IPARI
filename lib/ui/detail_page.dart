import 'package:flutter/material.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      child: Image.network(widget.wisata.urlImage),
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
                          child: IconButton(
                            icon: const Icon(
                              Icons.flight,
                              color: Colors.black,
                            ),
                            onPressed: () => MapsLauncher.launchCoordinates(
                                double.parse(widget.wisata.latitude),
                                double.parse(widget.wisata.longitude),
                                'Google Headquarters are here'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0),
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.wisata.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    // FavoriteButton(restaurant: restaurants),
                  ],
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
                  color: Colors.red[600],
                  margin: const EdgeInsets.all(4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.wisata.category,
                      style: const TextStyle(color: Colors.white),
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
