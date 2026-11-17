import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sevanta_delivery_partner/service/live_location_service.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
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

  /// Live Location Track Function
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
          // Glow halo for same UI style
          Polyline(
            polylineId: const PolylineId('delivery_route_glow'),
            points: points,
            color: AppColors.primaryOrange.withValues(alpha: 0.28),
            width: 3,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          ),
          // Main route line matching the orange UI
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
      // appBar: AppBar(
      //   title: const Text(
      //     'Live Tracking',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.black87),
      // ),
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
                              // Delivery Partner
                              _PartnerProfileCard(),

                              const SizedBox(height: 16),

                              // Order Details
                              _OrderDetailsCard(),

                              const SizedBox(height: 15),

                              // Delivery Progress
                              _DeliveryProgressButton(),

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

class _LocationActions extends StatelessWidget {
  final VoidCallback onPickupTap;
  final VoidCallback onDestinationTap;

  const _LocationActions({
    required this.onPickupTap,
    required this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPickupTap,
            icon: const Icon(Icons.my_location, size: 18),
            label: const Text('Pickup'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDestinationTap,
            icon: const Icon(Icons.location_on, size: 18),
            label: const Text('Destination'),
          ),
        ),
      ],
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
                const Text(
                  'Order Reference',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '#ORD10245',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    letterSpacing: -0.3,
                  ),
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
                    Text(
                      'On the Way',
                      style: TextStyle(
                        color: AppColors.successText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Arriving in ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrey,
                    ),
                  ),

                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '15 min',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
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

// ==========================================
// 4. DELIVERY PARTNER PROFILE CARD (STATELESS)
// ==========================================
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
          // Avatar with Orange Ring and Online Status Dot
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

          // Name, Title, and Rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rohit Sharma',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Delivery Partner',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                // Rating row
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
                        color: Color(0xFFF59E0B),
                        size: 15,
                      ),
                      SizedBox(width: 3),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        '(532 Ratings)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Call and Chat Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Call Button
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
                  Text(
                    'Call',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // Chat Button
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
                  Text(
                    'Massage',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
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

// ==========================================
// 5. ORDER DETAILS CARD (STATELESS)
// ==========================================
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
          // Header: Route icon + Order Details
          Row(
            children: const [
              Icon(
                Icons.alt_route_rounded,
                color: AppColors.textColor,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Content Row: Left (Stops) & Right (Stats)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Column: Pickup & Drop addresses
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pickup Stop
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
                              Text(
                                'Fresh Mart',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                '24, Anna Nagar, Chennai',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textGrey,
                                ),
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

                    // Drop Stop
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
                              Text(
                                'Arjun Kumar',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                '18, MG Road, Chennai',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Subtle Divider
              Container(width: 1, height: 70, color: const Color(0xFFFFDEC9)),

              const SizedBox(width: 14),

              // Right Column: Distance & Estimated Time Stats
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Distance
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
                            Text(
                              '4.5 KM',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textColor,
                              ),
                            ),
                            Text(
                              'Distance',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Estimated Time
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
                            Text(
                              '15 min',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textColor,
                              ),
                            ),
                            Text(
                              'Est. Time',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGrey,
                              ),
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

// ==========================================
// 6. NEED HELP? BUTTON (STATELESS)
// ==========================================
class _NeedHelpButton extends StatelessWidget {
  const _NeedHelpButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFEBDD),
          foregroundColor: AppColors.primaryOrange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Color(0xFFFFD4B8), width: 1.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.support_agent_rounded,
              color: AppColors.primaryOrange,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryProgressButton extends StatelessWidget {
  const _DeliveryProgressButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7A1A), Color(0xFFF15A24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF15A24).withValues(alpha: 0.32),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_rounded, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Complete Delivery',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorePinMarker extends StatelessWidget {
  const _StorePinMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Concentric glow ring
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFE6D5).withValues(alpha: 0.6),
          ),
        ),
        // Orange beacon pin
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.primaryOrange,
              size: 28,
            ),
            // Mini store building
            Container(
              width: 28,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primaryOrange, width: 1.5),
              ),
              child: const Icon(
                Icons.storefront,
                color: AppColors.primaryOrange,
                size: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MovingRiderMarker extends StatelessWidget {
  const _MovingRiderMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Radar pulse
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryOrange.withValues(alpha: 0.18),
          ),
        ),
        // Inner pulse ring
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryOrange.withValues(alpha: 0.3),
          ),
        ),
        // Scooter Icon
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: AppColors.primaryOrange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.moped_rounded, color: Colors.white, size: 16),
        ),
      ],
    );
  }
}

class _DestinationHomeMarker extends StatelessWidget {
  const _DestinationHomeMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Concentric soft blue radar rings
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B4E9B).withValues(alpha: 0.12),
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1B4E9B).withValues(alpha: 0.22),
          ),
        ),
        // Navy Blue Home Pin
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFF1B3B6F),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.home_rounded, color: Colors.white, size: 15),
        ),
      ],
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

class _DetailedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Map Road Network
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Diagonal and grid street lines
    canvas.drawLine(
      Offset(-10, size.height * 0.25),
      Offset(size.width + 10, size.height * 0.45),
      roadPaint,
    );
    canvas.drawLine(
      Offset(-10, size.height * 0.55),
      Offset(size.width + 10, size.height * 0.75),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, -10),
      Offset(size.width * 0.45, size.height + 10),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, -10),
      Offset(size.width * 0.85, size.height + 10),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.85),
      Offset(size.width, size.height * 0.85),
      minorRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.12),
      Offset(size.width, size.height * 0.12),
      minorRoadPaint,
    );

    // Green land/park patches
    final parkPaint = Paint()..color = const Color(0xFFD6F0E0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.68, size.height * 0.15, 42, 28),
        const Radius.circular(6),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.62, 36, 24),
        const Radius.circular(5),
      ),
      parkPaint,
    );

    // Pale blue water patch
    final waterPaint = Paint()..color = const Color(0xFFD8ECF8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.72, size.height * 0.48, 54, 40),
        const Radius.circular(8),
      ),
      waterPaint,
    );

    // 2. Smooth Continuous Orange Route Curve
    final routePath = Path();
    final start = Offset(size.width * 0.24, size.height * 0.26);
    final mid = Offset(size.width * 0.52, size.height * 0.48);
    final end = Offset(size.width * 0.78, size.height * 0.74);

    routePath.moveTo(start.dx, start.dy);
    routePath.cubicTo(
      size.width * 0.42,
      size.height * 0.28,
      size.width * 0.36,
      size.height * 0.46,
      mid.dx,
      mid.dy,
    );
    routePath.cubicTo(
      size.width * 0.62,
      size.height * 0.50,
      size.width * 0.68,
      size.height * 0.68,
      end.dx,
      end.dy,
    );

    // Route stroke
    final routePaint = Paint()
      ..color = AppColors.primaryOrange
      ..strokeWidth = 4.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
