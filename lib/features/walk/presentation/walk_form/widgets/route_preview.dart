import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutePreview extends StatefulWidget {
  final String routeJson;
  final double height;

  const RoutePreview({super.key, required this.routeJson, this.height = 160});

  @override
  State<RoutePreview> createState() => _RoutePreviewState();
}

class _RoutePreviewState extends State<RoutePreview> {
  GoogleMapController? _controller;
  LatLng? _start;
  LatLng? _end;
  Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    try {
      final map = jsonDecode(widget.routeJson) as Map<String, dynamic>;
      final start = map['start'] as Map<String, dynamic>?;
      final end = map['end'] as Map<String, dynamic>?;
      if (start != null) {
        _start = LatLng(
            (start['lat'] as num).toDouble(), (start['lng'] as num).toDouble());
        _markers.add(Marker(
          markerId: const MarkerId('start'),
          position: _start!,
          infoWindow:
              InfoWindow(title: 'Start', snippet: start['name']?.toString()),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      }
      if (end != null) {
        _end = LatLng(
            (end['lat'] as num).toDouble(), (end['lng'] as num).toDouble());
        _markers.add(Marker(
          markerId: const MarkerId('end'),
          position: _end!,
          infoWindow:
              InfoWindow(title: 'End', snippet: end['name']?.toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }
      final points = <LatLng>[];
      if (_start != null) points.add(_start!);
      if (_end != null) points.add(_end!);
      if (points.length > 1) {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('preview'),
            points: points,
            color: Colors.blue,
            width: 4,
          )
        };
      }
    } catch (_) {
      // ignore parse errors
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback camera
    final camera = CameraPosition(
        target: _start ?? _end ?? const LatLng(51.5072, -0.1276), zoom: 12);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: widget.height,
        child: GoogleMap(
          initialCameraPosition: camera,
          markers: _markers,
          polylines: _polylines,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (c) async {
            _controller = c;
            await Future.delayed(const Duration(milliseconds: 200));
            if (_start != null && _end != null) {
              final bounds = _boundsFrom(_start!, _end!);
              _controller
                  ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 48));
            } else if (_start != null) {
              _controller
                  ?.animateCamera(CameraUpdate.newLatLngZoom(_start!, 14));
            } else if (_end != null) {
              _controller?.animateCamera(CameraUpdate.newLatLngZoom(_end!, 14));
            }
          },
          gestureRecognizers: const {},
        ),
      ),
    );
  }

  LatLngBounds _boundsFrom(LatLng a, LatLng b) {
    final southWest = LatLng(
      a.latitude < b.latitude ? a.latitude : b.latitude,
      a.longitude < b.longitude ? a.longitude : b.longitude,
    );
    final northEast = LatLng(
      a.latitude > b.latitude ? a.latitude : b.latitude,
      a.longitude > b.longitude ? a.longitude : b.longitude,
    );
    return LatLngBounds(southwest: southWest, northeast: northEast);
  }
}
