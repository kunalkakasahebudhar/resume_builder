import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<Profile> updateProfile(Profile profile);
}
