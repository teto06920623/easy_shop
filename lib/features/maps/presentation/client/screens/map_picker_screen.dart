import 'package:easy_shop/core/helpers/location_helper.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerResult {
  final double latitude;
  final double longitude;
  final String address;

  MapPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  late LatLng _selectedLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedLocation = LatLng(widget.initialLat!, widget.initialLng!);
      setState(() => _isLoading = false);
      return;
    }

    final pos = await LocationHelper.getCurrentPosition();
    if (pos != null) {
      _selectedLocation = LatLng(pos.latitude, pos.longitude);
    } else {
      
      _selectedLocation = const LatLng(30.0444, 31.2357);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onConfirm() {
    Navigator.pop(
      context,
      MapPickerResult(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        address:
            'Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pick Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 15.0,
                    onPositionChanged: (camera, hasGesture) {
                      _selectedLocation = camera.center;
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.easy_shop',
                    ),
                  ],
                ),

                
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 35),
                    child: Icon(
                      Icons.location_pin,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.primary,
                    ),
                    onPressed: () async {
                      final pos = await LocationHelper.getCurrentPosition();
                      if (pos != null) {
                        final latLng = LatLng(pos.latitude, pos.longitude);
                        _selectedLocation = latLng;
                        _mapController.move(latLng, 15.0);
                      }
                    },
                  ),
                ),

                
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Drag the map to choose exact point',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          title: 'Confirm Location',
                          onPressed: _onConfirm,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
