import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Fetch data dari open API (JSONPlaceholder)
    final dioClient = dio.Dio(
      dio.BaseOptions(
        headers: {
          'User-Agent': 'Rem-App/1.0',
          'Accept': 'application/json',
        },
      ),
    );
    final response = await dioClient.get<List<dynamic>>(
      'https://jsonplaceholder.typicode.com/posts',
    );

    final posts = response.data!;
    final items = posts.take(10).map((post) {
      final postData = post as Map<String, dynamic>;
      return HomeItem(
        id: postData['id'].toString(),
        title: postData['title'] as String,
        subtitle: (postData['body'] as String).substring(0, 50),
        imageUrl: 'https://picsum.photos/200/200?random=${postData['id']}',
      );
    }).toList();

    final homeData = HomeData(
      title: 'Welcome to Rem',
      description: 'Explore the latest posts',
      items: items,
    );

    final successResponse = BaseResponse<HomeData>.success(
      data: homeData,
      message: 'Home data retrieved successfully',
    );

    return Response.json(
      body: successResponse.toJson((data) => data?.toJson() ?? {}),
    );
  } catch (e) {
    final errorResponse = BaseResponse<HomeData>.error(
      message: 'Failed to fetch home data: $e',
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: errorResponse.toJson((data) => data?.toJson()),
    );
  }
}
