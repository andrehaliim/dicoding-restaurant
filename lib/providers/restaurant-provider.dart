import 'package:flutter/material.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';

class RestaurantProvider extends ChangeNotifier {
  List<RestaurantListModel> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  List<RestaurantListModel> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRestaurants(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _restaurants = await RestaurantProxy().getRestaurantList(context);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}