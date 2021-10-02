import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetSingleArticleUseCase extends UseCase<Article, Params> {
  final ArticleRepository articleRepository;
  GetSingleArticleUseCase({required this.articleRepository});

  @override
  Future<Either<Failure, Article>> call(Params params) async {
    return await articleRepository.getAllArticleById(params.articleId);
  }
}

class Params extends Equatable {
  final int articleId;

  const Params({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
