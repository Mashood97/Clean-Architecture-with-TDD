// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_chopper_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$PostChopperService extends PostChopperService {
  _$PostChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PostChopperService;

  @override
  Future<Response<Map<dynamic, dynamic>>> getAllPosts() {
    final Uri $url = Uri.parse('posts');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Map<dynamic, dynamic>, Map<dynamic, dynamic>>($request);
  }
}
