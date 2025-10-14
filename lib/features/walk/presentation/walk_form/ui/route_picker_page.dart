import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geolocator;

class RoutePickerPage extends StatefulWidget {
  const RoutePickerPage({super.key});

  @override
  State<RoutePickerPage> createState() => _RoutePickerPageState();
}

class _RoutePickerPageState extends State<RoutePickerPage> {
  GoogleMapController? _controller; // reserved for future camera controls
  final List<LatLng> _points = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final TextEditingController _startCtrl = TextEditingController();
  final TextEditingController _endCtrl = TextEditingController();
  final FocusNode _startFocus = FocusNode();
  final FocusNode _endFocus = FocusNode();
  String? _routeName;
  bool _editingStart = true; // true => edits start, false => edits end
  LatLng? _start;
  LatLng? _end;
  String? _startName;
  String? _endName;
  LatLng? _userLocation;
  bool _hasCenteredToUser = false;
  bool _myLocationEnabled = false;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(51.5072, -0.1276), // London
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _startFocus.addListener(() {
      if (_startFocus.hasFocus) setState(() => _editingStart = true);
    });
    _endFocus.addListener(() {
      if (_endFocus.hasFocus) setState(() => _editingStart = false);
    });
    _initCurrentLocation();
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    _startFocus.dispose();
    _endFocus.dispose();
    super.dispose();
  }

  Future<void> _initCurrentLocation() async {
    try {
      final serviceEnabled =
          await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Don't block UI; simply skip centering and keep default.
        return;
      }
      var permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
      }
      if (permission == geolocator.LocationPermission.denied ||
          permission == geolocator.LocationPermission.deniedForever) {
        // Permission denied, keep defaults.
        return;
      }

      final pos = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.best,
      );
      if (!mounted) return;
      setState(() {
        _userLocation = LatLng(pos.latitude, pos.longitude);
        _myLocationEnabled = true;
      });

      // Center camera if map ready
      if (_controller != null && !_hasCenteredToUser && _userLocation != null) {
        _controller!.animateCamera(
          CameraUpdate.newLatLngZoom(_userLocation!, 14),
        );
        _hasCenteredToUser = true;
      }
    } catch (_) {
      // Ignore errors; keep default camera.
    }
  }

  void _addPoint(LatLng latLng) {
    _setSelectedPoint(latLng);
  }

  void _setSelectedPoint(LatLng latLng) {
    setState(() {
      // First tap always sets start; after that, set whichever field is active
      if (_start == null || _editingStart) {
        _start = latLng;
        _startName = null; // will be filled by reverse geocode
      } else {
        _end = latLng;
        _endName = null;
      }
      _rebuildRoute();
    });
    _controller?.animateCamera(CameraUpdate.newLatLng(latLng));
    _reverseGeocodeIfNeeded(latLng);
  }

  void _rebuildRoute() {
    _markers.clear();
    if (_start != null) {
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: _start!,
        infoWindow: InfoWindow(title: 'Start', snippet: _startName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
    if (_end != null) {
      _markers.add(Marker(
        markerId: const MarkerId('end'),
        position: _end!,
        infoWindow: InfoWindow(title: 'End', snippet: _endName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
    _polylines.clear();
    _points
      ..clear()
      ..addAll([if (_start != null) _start!, if (_end != null) _end!]);
    if (_points.length > 1) {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: _points,
        color: Theme.of(context).colorScheme.primary,
        width: 4,
      ));
    }
  }

  Future<void> _reverseGeocodeIfNeeded(LatLng latLng) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final name = [p.name, p.locality, p.country]
            .where((e) => (e ?? '').isNotEmpty)
            .join(', ');
        if (!mounted) return;
        setState(() {
          if (_start != null && (_editingStart || _end == null)) {
            _startName = name;
            _startCtrl.text = name;
          } else if (_end != null) {
            _endName = name;
            _endCtrl.text = name;
          }
          // Only set a general routeName if not set yet
          _routeName ??= (_startName != null && _endName != null)
              ? '$_startName → $_endName'
              : name;
          _rebuildRoute();
        });
      }
    } catch (_) {
      // ignore failures silently; map still works
    }
  }

  void _clear() {
    setState(() {
      _points.clear();
      _polylines.clear();
      _markers.clear();
    });
  }

  void _save() {
    final data = {
      'name': _routeName ??
          ((_startName != null || _endName != null)
              ? '${_startName ?? 'Start'} → ${_endName ?? 'End'}'
              : 'Custom Route'),
      'start': _start == null
          ? null
          : {
              'lat': _start!.latitude,
              'lng': _start!.longitude,
              'name': _startName,
            },
      'end': _end == null
          ? null
          : {
              'lat': _end!.latitude,
              'lng': _end!.longitude,
              'name': _endName,
            },
      'points': _points
          .map((e) => {
                'lat': e.latitude,
                'lng': e.longitude,
              })
          .toList(),
    };
    Navigator.of(context).pop(jsonEncode(data));
  }

  Future<void> _onSearchStart(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final locations = await geocoding.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);
        _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 14));
        _editingStart = true;
        _setSelectedPoint(target);
        setState(() {
          _startName = query.trim();
          _startCtrl.text = _startName!;
          _routeName ??= (_startName != null && _endName != null)
              ? '$_startName → $_endName'
              : query.trim();
          _rebuildRoute();
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start location not found')),
      );
    }
  }

  Future<void> _onSearchEnd(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final locations = await geocoding.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);
        _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 14));
        _editingStart = false;
        _setSelectedPoint(target);
        setState(() {
          _endName = query.trim();
          _endCtrl.text = _endName!;
          _routeName ??= (_startName != null && _endName != null)
              ? '$_startName → $_endName'
              : query.trim();
          _rebuildRoute();
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End location not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Route'),
        actions: [
          IconButton(onPressed: _clear, icon: const Icon(Icons.clear)),
          IconButton(
            onPressed: (_start != null && _end != null) ? _save : null,
            icon: const Icon(Icons.check),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _startCtrl,
                  focusNode: _startFocus,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSearchStart,
                  decoration: InputDecoration(
                    hintText: 'Search start location',
                    filled: true,
                    fillColor: scheme.surface,
                    prefixIcon: Icon(Icons.place, color: scheme.primary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endCtrl,
                  focusNode: _endFocus,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSearchEnd,
                  decoration: InputDecoration(
                    hintText: 'Search end location',
                    filled: true,
                    fillColor: scheme.surface,
                    prefixIcon: Icon(Icons.flag, color: scheme.error),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCamera,
        onMapCreated: (c) async {
          _controller = c;
          // If we already have the user location, center once.
          if (_userLocation != null && !_hasCenteredToUser) {
            await Future.delayed(const Duration(milliseconds: 200));
            _controller!.animateCamera(
              CameraUpdate.newLatLngZoom(_userLocation!, 14),
            );
            _hasCenteredToUser = true;
          }
        },
        onTap: _addPoint,
        polylines: _polylines,
        markers: _markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: _myLocationEnabled,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          (_start == null && _end == null)
              ? 'Tap map or search to set Start and End.'
              : 'Start: ${_startName ?? _start?.toString() ?? '-'}  |  End: ${_endName ?? _end?.toString() ?? '-'}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
