import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dioClient.get(BackendConfig.profile);
      final data = response.data as Map<String, dynamic>;
      return ProfileModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final response = await dioClient.put(
        BackendConfig.profile,
        data: profile.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      return ProfileModel.fromJson(data['data'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    }
  }
}
