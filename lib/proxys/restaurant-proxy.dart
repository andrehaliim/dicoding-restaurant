import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/constants.dart';
import 'package:restaurant/helpers/proxy-log-helper.dart';
import 'package:restaurant/models/proxy-log-model.dart';
import 'package:restaurant/models/restaurant-detail-model.dart';
import 'package:restaurant/models/restaurant-list-model.dart';

class RestaurantProxy {
  Future<List<RestaurantListModel>> getRestaurantList([BuildContext? context]) async {
    String url = '$baseUrl/list';

    try {
      var response = await http.get(Uri.parse(url));

      ProxyLogger.log(
        ProxyLogModel(
          url: url,
          params: null,
          statusCode: response.statusCode,
          response: response.body,
          time: DateTime.now(),
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurantsJson = data['restaurants'];

        return restaurantsJson.map((json) => RestaurantListModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      debugPrint('Error fetching restaurants: $e');
      rethrow;
    }
  }

  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    String url = '$baseUrl/detail/$id';

    var response = await http.get(Uri.parse(url));

    ProxyLogger.log(
      ProxyLogModel(
        url: url,
        params: {"id": id},
        statusCode: response.statusCode,
        response: response.body,
        time: DateTime.now(),
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RestaurantDetailModel.fromJson(data['restaurant']);
    } else {
      throw Exception('Failed to fetch detail: ${response.statusCode}');
    }
  }

  Future<List<RestaurantListModel>> searchRestaurant(String query) async {
    String url = '$baseUrl/search?q=$query';

    var response = await http.get(Uri.parse(url));

    ProxyLogger.log(
      ProxyLogModel(
        url: url,
        params: {"q": query},
        statusCode: response.statusCode,
        response: response.body,
        time: DateTime.now(),
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> restaurantsJson = data['restaurants'];

      return restaurantsJson.map((json) => RestaurantListModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search restaurants: ${response.statusCode}');
    }
  }

  Future<List<CustomerReview>> sendReview(BuildContext context, String id, String name, String review) async {
    String url = '$baseUrl/review';

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({"id": id, "name": name, "review": review});

    try {
      var response = await http.post(Uri.parse(url), headers: headers, body: body);

      ProxyLogger.log(
        ProxyLogModel(
          url: url,
          params: {"id": id, "name": name, "review": review},
          statusCode: response.statusCode,
          response: response.body,
          time: DateTime.now(),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> reviewsJson = data['customerReviews'];

        return reviewsJson.map((json) => CustomerReview.fromJson(json)).toList().reversed.toList();
      } else {
        throw Exception('Failed to post review: ${response.statusCode}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      debugPrint('Error sending review: $e');
      rethrow;
    }
  }
}
