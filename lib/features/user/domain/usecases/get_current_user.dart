import 'package:gezify/features/user/domain/entities/app_user.dart';
import 'package:gezify/features/user/domain/repository/user_repository.dart';

class GetCurrentUser {
  final UserRepository repository;

  GetCurrentUser(this.repository);

  Future<AppUsers?> call() async {
    return await repository.getCurrentUser();
  }
}
