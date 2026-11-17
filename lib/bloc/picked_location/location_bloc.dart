import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sevanta_delivery_partner/bloc/picked_location/location_event.dart';
import 'package:sevanta_delivery_partner/bloc/picked_location/location_state.dart';
import 'package:geocoding/geocoding.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
  }

  Future<void> _onFetchCurrentLocation(
    FetchCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationError('Location services are disabled.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationError('Location permissions are denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(LocationError('Location permissions are permanently denied.'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String fullAddress = '';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        fullAddress =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      }

      emit(
        LocationLoaded(
          latitude: position.latitude,
          longitude: position.longitude,
          address: fullAddress,
        ),
      );
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
