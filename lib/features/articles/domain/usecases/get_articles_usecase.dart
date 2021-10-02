import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetArticlesUseCase extends UseCase<List<Article>, NoParams> {
  final ArticleRepository articleRepository;
  GetArticlesUseCase({required this.articleRepository});

  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) async{
    return await articleRepository.getAllArticles();
  }
}
