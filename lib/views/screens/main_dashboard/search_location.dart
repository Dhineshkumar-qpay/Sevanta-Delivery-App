import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sevanta_delivery_partner/bloc/picked_location/location_bloc.dart';
import 'package:sevanta_delivery_partner/bloc/picked_location/location_event.dart';
import 'package:sevanta_delivery_partner/bloc/picked_location/location_state.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/enums.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_snackbar.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({super.key});

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  GoogleMapController? _mapController;

  LatLng? _currentLatLng;
  LatLng? _lastFetchedLatLng;

  String _selectedAddress = '';
  String _pincode = '';
  bool _hasValidAddress = false;
  bool _isGeocoding = false;

  Timer? _idleDebounce;
  int _geocodingRequestId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LocationBloc>().add(FetchCurrentLocationEvent());
      }
    });
  }

  @override
  void dispose() {
    _idleDebounce?.cancel();
    _geocodingRequestId++;
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Enter your Location',
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoaded) {
            final initialLocation = LatLng(state.latitude, state.longitude);
            _currentLatLng = initialLocation;
            _fetchAddress(initialLocation);
          }
        },
        builder: (context, state) {
          if (state is LocationInitial || state is LocationLoading) {
            return const CustomLoadingIndicator();
          }

          if (state is LocationError) {
            return CustomErrorTextWidget(message: state.message);
          }

          if (state is LocationLoaded) {
            final initialPosition = LatLng(state.latitude, state.longitude);

            return Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 18,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  compassEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(10, 22),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraMove: (position) => _currentLatLng = position.target,
                  onCameraIdle: _handleCameraIdle,
                ),

                IgnorePointer(
                  child: Transform.translate(
                    offset: const Offset(0, -25),
                    child: Icon(
                      Icons.location_pin,
                      size: 60,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 230,
                  right: 15,
                  child: FloatingActionButton.small(
                    heroTag: 'currentLocation',
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryOrange,
                    onPressed: _goToMyCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    top: false,
                    child: LocationPickContainer(
                      address: _selectedAddress,
                      isLoading: _isGeocoding,
                      onConfirm: _confirmLocation,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmLocation() {
    if (_currentLatLng == null || !_hasValidAddress || _isGeocoding) return;

    context.pop({
      'address': _selectedAddress,
      'pincode': _pincode,
      'latitude': _currentLatLng!.latitude,
      'longitude': _currentLatLng!.longitude,
    });
  }

  void _handleCameraIdle() {
    _idleDebounce?.cancel();
    _idleDebounce = Timer(const Duration(milliseconds: 500), () {
      final latLng = _currentLatLng;
      if (latLng != null && mounted) _fetchAddress(latLng);
    });
  }

  Future<void> _fetchAddress(LatLng latLng) async {
    if (_lastFetchedLatLng != null) {
      final distance = Geolocator.distanceBetween(
        _lastFetchedLatLng!.latitude,
        _lastFetchedLatLng!.longitude,
        latLng.latitude,
        latLng.longitude,
      );
      if (distance < 5) return;
    }

    final requestId = ++_geocodingRequestId;

    if (mounted) setState(() => _isGeocoding = true);

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (!mounted || requestId != _geocodingRequestId) return;

      final address = placemarks.isEmpty
          ? ''
          : _formatAddress(placemarks.first);
      setState(() {
        _lastFetchedLatLng = latLng;
        _hasValidAddress = address.isNotEmpty;
        _selectedAddress = address.isNotEmpty ? address : 'Address not found';
        _pincode = placemarks.first.postalCode ?? '';
        _isGeocoding = false;
      });
    } catch (e) {
      if (!mounted || requestId != _geocodingRequestId) return;
      setState(() {
        _hasValidAddress = false;
        _isGeocoding = false;
      });
      debugPrint('Reverse geocoding error: $e');
    }
  }

  String _formatAddress(Placemark place) {
    final parts = <String>[];
    for (final part in [
      place.street,
      place.locality,
      place.subLocality,
      place.country,
    ]) {
      final value = part?.trim();
      if (value != null && value.isNotEmpty && !parts.contains(value)) {
        parts.add(value);
      }
    }

    return parts.join(', ');
  }

  Future<void> _goToMyCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!mounted) return;
        CustomSnackBar.show(
          context: context,
          message: 'Please enable location services.',
          type: SnackBarType.error,
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        CustomSnackBar.show(
          context: context,
          message: 'Location permission is required.',
          type: SnackBarType.error,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (!mounted) return;

      final latLng = LatLng(position.latitude, position.longitude);
      _currentLatLng = latLng;

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 18),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Current location error: $e');
    }
  }
}

class LocationPickContainer extends StatelessWidget {
  const LocationPickContainer({
    super.key,
    required this.address,
    required this.isLoading,
    required this.onConfirm,
  });

  final String address;
  final bool isLoading;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final displayText = address.isNotEmpty
        ? address
        : isLoading
        ? 'Fetching address...'
        : 'Move the map to select your address';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/128/1946/1946770.png',
                height: 20,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Selected Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              if (isLoading)
                SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryOrange,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              title: 'Confirm & Proceed',
              onPressed: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
