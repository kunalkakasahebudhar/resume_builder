import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient? dioClient;

  ProfileRemoteDataSourceImpl({this.dioClient});

  // In-memory mock profile for Phase 1
  ProfileModel _mockProfile = const ProfileModel(
    id: 'usr_01HXYZ789',
    fullName: 'Alex Morgan',
    professionalTitle: 'Senior Full Stack & Flutter Developer',
    email: 'user@resumeforge.com',
    phone: '+1 (555) 234-5678',
    location: 'San Francisco, CA',
    linkedinUrl: 'https://linkedin.com/in/alexmorgan',
    githubUrl: 'https://github.com/alexmorgan',
    portfolioUrl: 'https://alexmorgan.dev',
    bio:
        'Passionate software engineer with 5+ years of experience crafting high-performance, scalable web and mobile applications.',
  );

  @override
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProfile;
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockProfile = profile;
    return _mockProfile;
  }
}
