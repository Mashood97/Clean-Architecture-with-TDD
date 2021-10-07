import 'package:flutter/material.dart';
import 'package:flutter_api_clean_architecture/features/post/presentation/pages/post_view.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';

import 'features/articles/presentation/pages/article_view.dart';
import 'features/articles/presentation/pages/single_article_view.dart';
import 'utils/dependency_Injector/di.dart' as di;
import 'utils/route/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: PageConstant.articles,
      home: PostView(),
      getPages: [
        GetPage(
          name: PageConstant.articles,
          page: () => ArticleView(),
        ),
        GetPage(
          name: PageConstant.articleById,
          page: () => SingleArticleView(),
        ),
      ],
    );
  }
}
