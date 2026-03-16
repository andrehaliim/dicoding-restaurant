import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/providers/restaurant-provider.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';

@GenerateMocks([RestaurantProxy])
import 'restaurant_provider_test.mocks.dart';

void main() {
  late RestaurantProvider provider;
  late MockRestaurantProxy mockProxy;

  setUp(() {
    mockProxy = MockRestaurantProxy();
    provider = RestaurantProvider(apiService: mockProxy);
  });

  group('Restaurant Provider Test Scenarios', () {

    test('SKENARIO 1: Memastikan state awal provider harus didefinisikan.', () {
      expect(provider.isLoading, false);
      expect(provider.restaurants, []);
      expect(provider.error, null);
    });

    test('SKENARIO 2: Memastikan harus mengembalikan daftar restoran ketika pengambilan data API berhasil.', () async {
      final mockResponse = [
        RestaurantListModel(id: "1", name: "Test Resto", city: "Bdg", rating: 4.5, pictureId: "1", description: "desc")
      ];
      when(mockProxy.getRestaurantList(any)).thenAnswer((_) async => mockResponse);

      await provider.fetchRestaurants(null);

      expect(provider.isLoading, false);
      expect(provider.restaurants.isNotEmpty, true);
      expect(provider.restaurants[0].name, "Test Resto");
    });

    test('SKENARIO 3: Memastikan harus mengembalikan kesalahan ketika pengambilan data API gagal.', () async {
      when(mockProxy.getRestaurantList(any)).thenThrow(Exception('No Internet'));

      await provider.fetchRestaurants(null);

      expect(provider.isLoading, false);
      expect(provider.restaurants, []);
      expect(provider.error != null, true);
      expect(provider.error, contains('Exception: No Internet'));
    });
  });
}