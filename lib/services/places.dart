import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

class Places {
  Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      return response.body;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

class CountryList extends ISuspensionBean {
  final String name;
  final String tag;
  CountryList({required this.name, required this.tag});

  @override
  String getSuspensionTag() => tag;
}

class PlaceAutoCompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? pred;

  PlaceAutoCompleteResponse({this.status, this.pred});
  factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutoCompleteResponse(
      status: json['status'] as String?,
      pred:
          json['predictions'] != null
              ? (json['predictions'] as List)
                  .map(
                    (item) => AutocompletePrediction.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList()
              : null,
    );
  }

  static PlaceAutoCompleteResponse parseAutoCompleteResult(String res) {
    final parsed = json.decode(res) as Map<String, dynamic>;

    return PlaceAutoCompleteResponse.fromJson(parsed);
  }
}

class AutocompletePrediction {
  final String? description;
  final String? placeId;
  final StructuredFormatting? structuredFormatting;

  AutocompletePrediction({
    this.description,
    this.placeId,
    this.structuredFormatting,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      structuredFormatting:
          json['structured_formatting'] != null
              ? StructuredFormatting.fromJson(
                json['structured_formatting'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}

Future<void> openMapLink(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Opens in Google Maps / App
    );
  } else {
    print(  'Could not launch $url');
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}
