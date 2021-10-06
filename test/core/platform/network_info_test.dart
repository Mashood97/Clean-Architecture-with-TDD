import 'package:flutter_api_clean_architecture/core/platform/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late final NetworkInfoImpl networkInfoImpl;
  late final MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
        internetConnectionChecker: mockInternetConnectionChecker);
  });

  group("IsConnected", () {
    test("Should forward the call to Internet connection checker.hasConnection",
        () async {
      //since we already created Future.value(true) as var then we dont need to set ThenAnswer(()) as async because
      //return type is already future.
      final tHasConnectionFuture = Future.value(true);

      //arrange
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer(
        (_) => tHasConnectionFuture,
      );

      //act

      final result = networkInfoImpl.isConnected;
      //assert

      verify(() => mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
