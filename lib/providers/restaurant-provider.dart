import 'package:flutter/material.dart';
import 'package:restaurant/models/restaurant-detail-model.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';

class RestaurantProvider extends ChangeNotifier {
  List<RestaurantListModel> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  List<RestaurantListModel> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RestaurantDetailModel? _detail;
  bool _isDetailLoading = false;
  String? _detailError;

  RestaurantDetailModel? get detail => _detail;
  bool get isDetailLoading => _isDetailLoading;
  String? get detailError => _detailError;

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

  Future<void> fetchRestaurantDetail(String id) async {
    _isDetailLoading = true;
    notifyListeners();

    try {
      _detail = await RestaurantProxy().getRestaurantDetail(id);
    } catch (e) {
      _detailError = e.toString();
    }

    _isDetailLoading = false;
    notifyListeners();
  }
}