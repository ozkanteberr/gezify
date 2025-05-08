import 'package:gezify/features/user/domain/entities/app_user.dart';

abstract class UserRepository {
  Future<AppUsers?> getCurrentUser();
}
