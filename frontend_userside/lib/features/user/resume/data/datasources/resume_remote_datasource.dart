import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/resume/data/models/resume_model.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/achievement.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/certification.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/language.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';

abstract class ResumeRemoteDataSource {
  Future<List<ResumeModel>> getResumes();
  Future<ResumeModel> getResumeById(String id);
  Future<ResumeModel> createResume({required String title, String? templateId});
  Future<ResumeModel> updateResume(ResumeModel resume);
  Future<void> deleteResume(String id);
  Future<ResumeModel> duplicateResume(String id);
  Future<ResumeModel> renameResume(String id, String newTitle);
}

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final DioClient? dioClient;

  ResumeRemoteDataSourceImpl({this.dioClient});

  // Mock initial resumes
  final List<ResumeModel> _mockResumes = [
    ResumeModel(
      id: 'res_001',
      title: 'Software Engineer Resume',
      templateId: 'ats_classic',
      status: ResumeStatus.completed,
      atsScore: 82,
      completionPercentage: 95,
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      personalInfo: const Profile(
        id: 'usr_01HXYZ789',
        fullName: 'Alex Morgan',
        professionalTitle: 'Senior Full Stack & Cloud Engineer',
        email: 'user@resumeforge.com',
        phone: '+1 (555) 234-5678',
        location: 'San Francisco, CA',
        linkedinUrl: 'https://linkedin.com/in/alexmorgan',
        githubUrl: 'https://github.com/alexmorgan',
        portfolioUrl: 'https://alexmorgan.dev',
      ),
      summary:
          'Versatile Senior Software Engineer with 6+ years of experience designing, scaling, and deploying mission-critical microservices and high-performance web applications. Proven track record in optimizing backend latency by 35% and mentoring junior engineers.',
      educations: const [
        Education(
          id: 'edu_1',
          degree: 'Bachelor of Science in Computer Science',
          institution: 'University of California, Berkeley',
          location: 'Berkeley, CA',
          startDate: 'Aug 2016',
          endDate: 'May 2020',
          gradeOrCgpa: '3.85 GPA',
          description:
              'Dean’s Honor List (4 semesters), Course Assistant for Data Structures and Algorithms.',
        ),
      ],
      skills: const [
        Skill(
          id: 'sk_1',
          name: 'Go / Golang',
          category: SkillCategory.programmingLanguage,
          level: 'Expert',
        ),
        Skill(
          id: 'sk_2',
          name: 'Dart / Flutter',
          category: SkillCategory.framework,
          level: 'Expert',
        ),
        Skill(
          id: 'sk_3',
          name: 'PostgreSQL',
          category: SkillCategory.database,
          level: 'Advanced',
        ),
        Skill(
          id: 'sk_4',
          name: 'Docker & Kubernetes',
          category: SkillCategory.tool,
          level: 'Advanced',
        ),
        Skill(
          id: 'sk_5',
          name: 'Redis',
          category: SkillCategory.database,
          level: 'Intermediate',
        ),
        Skill(
          id: 'sk_6',
          name: 'REST & gRPC APIs',
          category: SkillCategory.technical,
          level: 'Expert',
        ),
        Skill(
          id: 'sk_7',
          name: 'System Architecture',
          category: SkillCategory.technical,
          level: 'Advanced',
        ),
        Skill(
          id: 'sk_8',
          name: 'Team Leadership & Mentorship',
          category: SkillCategory.softSkill,
          level: 'Advanced',
        ),
      ],
      experiences: const [
        Experience(
          id: 'exp_1',
          jobTitle: 'Senior Software Engineer',
          company: 'CloudScale Technologies',
          location: 'San Francisco, CA',
          employmentType: 'Full-time',
          startDate: 'Jun 2022',
          endDate: 'Present',
          isCurrentlyWorking: true,
          description:
              '• Architected and developed high-throughput RESTful microservices using Go and Gin handling over 10M daily requests.\n• Reduced query latency by 40% via Redis distributed caching and database query optimization.\n• Led a squad of 6 engineers, standardizing CI/CD pipelines with GitHub Actions and Docker.',
        ),
        Experience(
          id: 'exp_2',
          jobTitle: 'Software Engineer',
          company: 'Nexus Software Labs',
          location: 'San Jose, CA',
          employmentType: 'Full-time',
          startDate: 'Jul 2020',
          endDate: 'May 2022',
          isCurrentlyWorking: false,
          description:
              '• Built responsive client portals with modern front-end frameworks and integrated secure OAuth2 authentication.\n• Implemented automated integration testing suites achieving 88% overall code coverage.',
        ),
      ],
      projects: const [
        Project(
          id: 'proj_1',
          projectName: 'ResumeForge Platform',
          role: 'Lead Architect',
          description:
              'Engineered a scalable ATS-optimized resume builder with live dynamic previews and real-time ATS scoring algorithms.',
          technologies: 'Flutter Web, Riverpod, Go, Gin, PostgreSQL',
          projectUrl: 'https://resumeforge.com',
          githubUrl: 'https://github.com/alexmorgan/resumeforge',
          startDate: 'Jan 2024',
          endDate: 'Present',
        ),
        Project(
          id: 'proj_2',
          projectName: 'MicroMetrics APM',
          role: 'Creator',
          description:
              'Open-source lightweight APM metrics agent capable of streaming distributed trace data with negligible CPU overhead.',
          technologies: 'Go, Prometheus, OpenTelemetry, Grafana',
          githubUrl: 'https://github.com/alexmorgan/micrometrics',
          startDate: 'Sep 2023',
          endDate: 'Dec 2023',
        ),
      ],
      certifications: const [
        Certification(
          id: 'cert_1',
          name: 'AWS Certified Solutions Architect – Associate',
          issuingOrganization: 'Amazon Web Services',
          issueDate: 'Mar 2023',
          expiryDate: 'Mar 2026',
          credentialId: 'AWS-CSA-884920',
        ),
      ],
      achievements: const [
        Achievement(
          id: 'ach_1',
          title: '1st Place Winner - Bay Area Tech Hackathon 2023',
          description:
              'Awarded top prize among 60 teams for developing an automated accessibility audit tool.',
          date: 'Nov 2023',
        ),
      ],
      languages: const [
        Language(id: 'lang_1', language: 'English', proficiency: 'Native'),
        Language(
          id: 'lang_2',
          language: 'Spanish',
          proficiency: 'Intermediate',
        ),
      ],
    ),
    ResumeModel(
      id: 'res_002',
      title: 'Flutter Developer Resume',
      templateId: 'ats_professional',
      status: ResumeStatus.draft,
      atsScore: 64,
      completionPercentage: 70,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      personalInfo: const Profile(
        id: 'usr_01HXYZ789',
        fullName: 'Alex Morgan',
        professionalTitle: 'Flutter & Mobile App Specialist',
        email: 'user@resumeforge.com',
        phone: '+1 (555) 234-5678',
        location: 'San Francisco, CA',
        linkedinUrl: 'https://linkedin.com/in/alexmorgan',
      ),
      summary:
          'Passionate Flutter Developer dedicated to crafting pixel-perfect, highly responsive cross-platform applications with clean state management.',
      educations: const [
        Education(
          id: 'edu_10',
          degree: 'B.S. in Computer Science',
          institution: 'UC Berkeley',
          location: 'Berkeley, CA',
          startDate: '2016',
          endDate: '2020',
          gradeOrCgpa: '3.85',
        ),
      ],
      skills: const [
        Skill(id: 'sk_10', name: 'Flutter', category: SkillCategory.framework),
        Skill(
          id: 'sk_11',
          name: 'Dart',
          category: SkillCategory.programmingLanguage,
        ),
        Skill(
          id: 'sk_12',
          name: 'Riverpod & Bloc',
          category: SkillCategory.framework,
        ),
        Skill(
          id: 'sk_13',
          name: 'REST APIs & Dio',
          category: SkillCategory.technical,
        ),
      ],
      experiences: const [
        Experience(
          id: 'exp_10',
          jobTitle: 'Flutter Developer',
          company: 'AppWave Studio',
          location: 'Remote',
          startDate: 'Jan 2022',
          endDate: 'Present',
          isCurrentlyWorking: true,
          description:
              'Developed and published cross-platform mobile apps on App Store and Google Play.',
        ),
      ],
      projects: const [
        Project(
          id: 'proj_10',
          projectName: 'Fitness Tracker App',
          description:
              'Built a sleek personal workout tracker with local persistence and interactive health charts.',
          technologies: 'Flutter, SQLite, Provider',
        ),
      ],
      certifications: const [],
      achievements: const [],
      languages: const [
        Language(id: 'lang_10', language: 'English', proficiency: 'Fluent'),
      ],
    ),
  ];

  @override
  Future<List<ResumeModel>> getResumes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockResumes);
  }

  @override
  Future<ResumeModel> getResumeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final resume = _mockResumes.firstWhere(
      (r) => r.id == id,
      orElse: () => _mockResumes.first,
    );
    return resume;
  }

  @override
  Future<ResumeModel> createResume({
    required String title,
    String? templateId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final newResume = ResumeModel(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim().isEmpty ? 'Untitled Resume' : title.trim(),
      templateId: templateId ?? 'ats_classic',
      status: ResumeStatus.draft,
      atsScore: 50,
      completionPercentage: 40,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      personalInfo: const Profile(
        id: 'usr_01HXYZ789',
        fullName: 'Alex Morgan',
        professionalTitle: 'Professional Title',
        email: 'user@resumeforge.com',
        phone: '+1 (555) 234-5678',
        location: 'City, Country',
      ),
      summary: '',
      educations: const [],
      skills: const [],
      experiences: const [],
      projects: const [],
      certifications: const [],
      achievements: const [],
      languages: const [],
    );
    _mockResumes.insert(0, newResume);
    return newResume;
  }

  @override
  Future<ResumeModel> updateResume(ResumeModel resume) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockResumes.indexWhere((r) => r.id == resume.id);
    final updated = resume.copyWith(updatedAt: DateTime.now()) as ResumeModel;
    if (index != -1) {
      _mockResumes[index] = updated;
    } else {
      _mockResumes.insert(0, updated);
    }
    return updated;
  }

  @override
  Future<void> deleteResume(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockResumes.removeWhere((r) => r.id == id);
  }

  @override
  Future<ResumeModel> duplicateResume(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final original = await getResumeById(id);
    final duplicate =
        original.copyWith(
              id: 'res_${DateTime.now().millisecondsSinceEpoch}',
              title: '${original.title} (Copy)',
              updatedAt: DateTime.now(),
              createdAt: DateTime.now(),
            )
            as ResumeModel;
    _mockResumes.insert(0, duplicate);
    return duplicate;
  }

  @override
  Future<ResumeModel> renameResume(String id, String newTitle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final original = await getResumeById(id);
    final updated =
        original.copyWith(
              title: newTitle.trim().isEmpty ? original.title : newTitle.trim(),
              updatedAt: DateTime.now(),
            )
            as ResumeModel;
    final index = _mockResumes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _mockResumes[index] = updated;
    }
    return updated;
  }
}
