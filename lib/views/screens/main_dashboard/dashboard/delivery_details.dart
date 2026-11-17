import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sevanta_delivery_partner/service/live_location_service.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';

class DeliveryDetails extends StatefulWidget {
  const DeliveryDetails({super.key});

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  static const LatLng _myPosition = LatLng(11.3276757, 77.6983319);
  static const LatLng _storePosition = LatLng(11.31898, 77.67515);
  static const LatLng _customerPosition = LatLng(11.358657, 77.754244);

  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final double _minSize = 0.25;
  final double _maxSize = 0.68;

  StreamSubscription<Position>? _positionStreamSubscription;
  final ValueNotifier<LatLng?> currentLatLongNotifier = ValueNotifier(
    _myPosition,
  );
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    updateMarkers(latLong: _myPosition);
    loadCustomMarkers();

    _startTrackingLocation();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startTrackingLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            currentLatLongNotifier.value = LatLng(
              position.latitude,
              position.longitude,
            );
            debugPrint(
              "Live Location: ${position.latitude}, ${position.longitude}",
            );
            loadingNotifier.value = false;

            updateMarkers(
              latLong: LatLng(position.latitude, position.longitude),
            );
            _getPolylinePoints();
          },
          onError: (error) {
            debugPrint("Location fetching : $error");
          },
        );
  }

  Future<void> _getPolylinePoints() async {
    try {
      final points = await getRoutePoints(_storePosition, _customerPosition);

      if (!mounted || points.isEmpty) return;

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('delivery_route_glow'),
            points: points,
            color: AppColors.primaryOrange.withValues(alpha: 0.28),
            width: 3,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          ),

          Polyline(
            polylineId: const PolylineId('delivery_route'),
            points: points,
            color: AppColors.primaryOrange,
            width: 3,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            geodesic: false,
          ),
        };
      });

      _fitMapToPolyline(points);
    } catch (e) {
      debugPrint('Route error: $e');
    }
  }

  Future<void> _fitMapToPolyline(List<LatLng> points) async {
    if (points.isEmpty || !_mapController.isCompleted) return;
    try {
      final controller = await _mapController.future;
      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (final p in points) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 65));
    } catch (e) {
      debugPrint('Camera fit error: $e');
    }
  }

  BitmapDescriptor? myIcon;
  BitmapDescriptor? storeIcon;
  BitmapDescriptor? customerIcon;

  Future<void> loadCustomMarkers() async {
    myIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(70, 48)),
      AppImages.deliveryBikeP,
    );

    storeIcon = BitmapDescriptor.defaultMarker;

    customerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(70, 48)),
      AppImages.deliveryBikeP,
    );
  }

  void updateMarkers({required LatLng latLong}) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('store'),
          position: _storePosition,
          icon: storeIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Store Location'),
        ),

        Marker(
          markerId: const MarkerId('customer'),
          position: _customerPosition,
          icon: customerIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Customer Location'),
        ),

        Marker(
          markerId: const MarkerId('initial'),
          position: latLong,
          icon: myIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Initial Location'),
        ),
      };
    });
  }

  void _expandSheet() {
    if (!_sheetController.isAttached) return;

    if (_sheetController.size >= _maxSize - 0.01) {
      _sheetController.animateTo(
        _minSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _sheetController.animateTo(
        _maxSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _moveCamera(LatLng position) async {
    if (!_mapController.isCompleted) return;

    final controller = await _mapController.future;

    await controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: ValueListenableBuilder(
        valueListenable: loadingNotifier,
        builder: (context, value, child) {
          if (value) return CustomLoadingIndicator();
          return Stack(
            children: [
              Positioned.fill(
                child: ValueListenableBuilder(
                  valueListenable: currentLatLongNotifier,
                  builder: (context, value, child) {
                    if (value == null) return CustomLoadingIndicator();
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: currentLatLongNotifier.value!,
                        zoom: 14.0,
                      ),
                      markers: _markers,
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      mapToolbarEnabled: false,
                      mapType: MapType.terrain,
                      polylines: _polylines,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_mapController.isCompleted) {
                          _mapController.complete(controller);
                        }
                        if (_polylines.isNotEmpty) {
                          _fitMapToPolyline(_polylines.first.points);
                        }
                      },
                    );
                  },
                ),
              ),

              AnimatedBuilder(
                animation: _sheetController,
                builder: (context, child) {
                  final screenHeight = MediaQuery.of(context).size.height;

                  final sheetSize = _sheetController.isAttached
                      ? _sheetController.size
                      : _minSize;

                  return Positioned(
                    right: 15,
                    bottom: (screenHeight * sheetSize) + 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'current_location',
                          backgroundColor: Colors.white,
                          elevation: 3,
                          onPressed: () async {
                            Position position =
                                await Geolocator.getCurrentPosition(
                                  locationSettings: const LocationSettings(
                                    accuracy: LocationAccuracy.high,
                                  ),
                                );
                            _moveCamera(
                              LatLng(position.latitude, position.longitude),
                            );
                          },
                          child: Icon(
                            Icons.my_location_rounded,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        FloatingActionButton.small(
                          heroTag: 'expand_sheet',
                          backgroundColor: Colors.white,
                          elevation: 3,
                          onPressed: _expandSheet,
                          child: Icon(
                            sheetSize >= _maxSize - 0.01
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: _minSize,
                minChildSize: _minSize,
                maxChildSize: _maxSize,
                snap: true,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                      return Container(
                        padding: EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Column(
                            children: [
                              Container(
                                width: 45,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              const SizedBox(height: 20),

                              _OrderReferenceCard(),
                              const SizedBox(height: 16),

                              _PartnerProfileCard(),

                              const SizedBox(height: 16),

                              _OrderDetailsCard(),

                              const SizedBox(height: 15),

                              ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    SizedBox(width: 8),
                                    BodyTextColors(
                                      title: 'Complete Delivery',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.2,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderReferenceCard extends StatelessWidget {
  const _OrderReferenceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(AppImages.deliveryBikeP, fit: BoxFit.cover),
          ),

          Container(
            height: 60,
            width: 1.5,
            margin: EdgeInsets.symmetric(horizontal: 15),
            color: AppColors.primaryOrange.withValues(alpha: .1),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BodyTextHint(
                  title: 'Order Reference',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 10),
                HeaderTextBlack(
                  title: '#ORD10245',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: 1.5,
            margin: EdgeInsets.symmetric(horizontal: 15),
            color: AppColors.primaryOrange.withValues(alpha: .1),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.successText,
                      size: 13,
                    ),
                    SizedBox(width: 4),
                    BodyTextColors(
                      title: 'On the Way',
                      color: AppColors.successText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BodyTextHint(
                    title: 'Arriving in ',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),

                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(width: 3),
                  HeaderTextBlack(
                    title: '15 min',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartnerProfileCard extends StatelessWidget {
  const _PartnerProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF1F6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryOrange, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFE8ECF4),
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF249D4A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderTextBlack(
                  title: 'Rohit Sharma',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                BodyTextHint(
                  title: 'Delivery Partner',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.primaryOrange,
                        size: 15,
                      ),
                      SizedBox(width: 3),
                      HeaderTextBlack(
                        title: '4.8',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: 3),
                      BodyTextHint(
                        title: '(532 Ratings)',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/597/597177.png",
                        color: AppColors.white,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  HeaderTextBlack(
                    title: 'Call',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              const SizedBox(width: 14),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderGrey,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/9458/9458241.png",
                        color: AppColors.textColor,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  HeaderTextBlack(
                    title: 'Massage',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDFC8), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.alt_route_rounded,
                color: AppColors.textColor,
                size: 18,
              ),
              SizedBox(width: 8),
              BodyTextColors(
                title: 'Order Details',
                fontSize: 15,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColors.primaryOrange,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              HeaderTextBlack(
                                title: 'Fresh Mart',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 1),
                              BodyTextHint(
                                title: '24, Anna Nagar, Chennai',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 2,
                        bottom: 2,
                      ),
                      child: CustomPaint(
                        size: const Size(2, 22),
                        painter: _DottedLinePainter(),
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.home_rounded,
                            color: AppColors.textColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              HeaderTextBlack(
                                title: 'Arjun Kumar',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 1),
                              BodyTextHint(
                                title: '18, MG Road, Chennai',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 70, color: const Color(0xFFFFDEC9)),

              const SizedBox(width: 14),

              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primaryOrange,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            HeaderTextBlack(
                              title: '4.5 KM',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            BodyTextHint(
                              title: 'Distance',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.primaryOrange,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            HeaderTextBlack(
                              title: '15 min',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            BodyTextHint(
                              title: 'Est. Time',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB0B9C7)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
