import 'package:chopper/chopper.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements ChopperClient {}

void main() {
  late MockDioClient dioClient;
  late PostRemoteDataSourceRepoImpl remoteDataSourceRepoImpl;

  setUp(() {
    dioClient = MockDioClient();
  });
}
