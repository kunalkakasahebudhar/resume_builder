import 'package:frontend_userside/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend_userside/features/user/profile/data/models/profile_model.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);
    return await remoteDataSource.updateProfile(model);
  }
}
