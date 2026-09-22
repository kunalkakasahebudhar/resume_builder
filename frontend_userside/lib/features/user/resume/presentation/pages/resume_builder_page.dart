import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/utils/responsive_utils.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/preview/presentation/widgets/resume_renderer.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/achievement_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/certification_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/education_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/experience_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/language_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/personal_information_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/project_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/resume_section_tile.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/skill_form.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/summary_form.dart';
import 'package:go_router/go_router.dart';

class ResumeBuilderPage extends ConsumerStatefulWidget {
  final String? resumeId;
  final String? initialSection;

  const ResumeBuilderPage({super.key, this.resumeId, this.initialSection});

  @override
  ConsumerState<ResumeBuilderPage> createState() => _ResumeBuilderPageState();
}

class _ResumeBuilderPageState extends ConsumerState<ResumeBuilderPage> {
  int _selectedSectionIndex = 0;
  bool _showPreviewOnMobile = false;
  double _previewScale = 0.72;

  final List<_SectionMeta> _sections = const [
    _SectionMeta(
      'Personal Information',
      Icons.person_outline_rounded,
      'personal-information',
    ),
    _SectionMeta('Professional Summary', Icons.subject_rounded, 'summary'),
    _SectionMeta('Education', Icons.school_outlined, 'education'),
    _SectionMeta('Skills & Expertise', Icons.psychology_outlined, 'skills'),
    _SectionMeta('Work Experience', Icons.work_outline_rounded, 'experience'),
    _SectionMeta('Projects', Icons.folder_open_rounded, 'projects'),
    _SectionMeta('Certifications', Icons.verified_outlined, 'certifications'),
    _SectionMeta('Achievements', Icons.emoji_events_outlined, 'achievements'),
    _SectionMeta('Languages', Icons.translate_rounded, 'languages'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.resumeId != null && widget.resumeId != 'new') {
        ref.read(activeResumeProvider.notifier).loadResume(widget.resumeId!);
      } else {
        // Create new or select first
        final resumes = ref.read(resumesListProvider).resumes;
        if (resumes.isNotEmpty) {
          ref.read(activeResumeProvider.notifier).setResume(resumes.first);
        }
      }

      if (widget.initialSection != null) {
        final idx = _sections.indexWhere(
          (s) => s.routeSlug == widget.initialSection,
        );
        if (idx != -1) {
          setState(() {
            _selectedSectionIndex = idx;
          });
        }
      }
    });
  }

  Widget _buildActiveSectionForm() {
    switch (_selectedSectionIndex) {
      case 0:
        return const PersonalInformationForm();
      case 1:
        return const SummaryForm();
      case 2:
        return const EducationForm();
      case 3:
        return const SkillForm();
      case 4:
        return const ExperienceForm();
      case 5:
        return const ProjectForm();
      case 6:
        return const CertificationForm();
      case 7:
        return const AchievementForm();
      case 8:
        return const LanguageForm();
      default:
        return const PersonalInformationForm();
    }
  }

  int _getItemCountForSection(int index) {
    final resume = ref.read(activeResumeProvider);
    if (resume == null) return 0;
    switch (index) {
      case 2:
        return resume.educations.length;
      case 3:
        return resume.skills.length;
      case 4:
        return resume.experiences.length;
      case 5:
        return resume.projects.length;
      case 6:
        return resume.certifications.length;
      case 7:
        return resume.achievements.length;
      case 8:
        return resume.languages.length;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resume = ref.watch(activeResumeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = ResponsiveUtils.isDesktop(context);

    if (resume == null) {
      return const UserLayout(
        currentRoute: '/resumes',
        child: AppLoader(message: 'Initializing Resume Builder...'),
      );
    }

    final isHighAts = resume.atsScore >= 80;
    final atsColor = isHighAts
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    return UserLayout(
      currentRoute: '/resumes',
      child: Column(
        children: [
          // Builder Top Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.15)
                      : const Color(0xFF0F172A).withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        tooltip: 'Back to Resumes',
                        onPressed: () => context.go('/resumes'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              resume.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    resume.templateId
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4F46E5),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: atsColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${resume.atsScore} ATS',
                                    style: TextStyle(
                                      color: atsColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isDesktop)
                          IconButton(
                            icon: Icon(
                              _showPreviewOnMobile
                                  ? Icons.edit_note_rounded
                                  : Icons.visibility_outlined,
                            ),
                            tooltip: _showPreviewOnMobile
                                ? 'Edit Form'
                                : 'Live Preview',
                            onPressed: () {
                              setState(() {
                                _showPreviewOnMobile = !_showPreviewOnMobile;
                              });
                            },
                          ),
                        const SizedBox(width: 6),
                        AppButton(
                          text: 'Templates',
                          type: ButtonType.outline,
                          icon: Icons.palette_outlined,
                          height: 36,
                          onPressed: () => context.push('/templates'),
                        ),
                        const SizedBox(width: 8),
                        AppButton(
                          text: 'ATS Analyzer',
                          type: ButtonType.outline,
                          icon: Icons.analytics_outlined,
                          height: 36,
                          onPressed: () => context.push('/ats'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/pdf'),
                          icon: const Icon(Icons.download_rounded, size: 16),
                          label: const Text('Export PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 0,
                            ),
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Two-Panel Layout
          Expanded(
            child: isDesktop
                ? Row(
                    children: [
                      // LEFT PANEL: Sections Navigation & Active Form
                      Expanded(
                        flex: 6,
                        child: Row(
                          children: [
                            // Section navigation rail
                            Container(
                              width: 230,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFF8FAFC),
                                border: Border(
                                  right: BorderSide(
                                    color: isDark
                                        ? const Color(0xFF1F2937)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 10,
                                ),
                                itemCount: _sections.length,
                                itemBuilder: (context, index) {
                                  final sec = _sections[index];
                                  return ResumeSectionTile(
                                    icon: sec.icon,
                                    title: sec.title,
                                    itemCount: _getItemCountForSection(index),
                                    isSelected: _selectedSectionIndex == index,
                                    onTap: () {
                                      setState(() {
                                        _selectedSectionIndex = index;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            // Form Editor Area
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  children: [
                                    _buildActiveSectionForm(),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (_selectedSectionIndex > 0)
                                          AppButton(
                                            text: 'Previous Section',
                                            type: ButtonType.outline,
                                            icon: Icons.chevron_left_rounded,
                                            onPressed: () {
                                              setState(() {
                                                _selectedSectionIndex--;
                                              });
                                            },
                                          )
                                        else
                                          const SizedBox.shrink(),
                                        if (_selectedSectionIndex <
                                            _sections.length - 1)
                                          AppButton(
                                            text: 'Next Section',
                                            icon: Icons.chevron_right_rounded,
                                            onPressed: () {
                                              setState(() {
                                                _selectedSectionIndex++;
                                              });
                                            },
                                          )
                                        else
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                context.push('/preview'),
                                            icon: const Icon(
                                              Icons.visibility_outlined,
                                              size: 16,
                                            ),
                                            label: const Text('Preview Resume'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF4F46E5,
                                              ),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              textStyle: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // RIGHT PANEL: Live ATS Preview with Zoom Controls
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF090D16)
                                : const Color(0xFFE2E8F0),
                            border: Border(
                              left: BorderSide(
                                color: isDark
                                    ? const Color(0xFF1F2937)
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Preview Floating Control Bar
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(
                                          0xFF111827,
                                        ).withValues(alpha: 0.9)
                                      : Colors.white.withValues(alpha: 0.9),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF1F2937)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.preview_rounded,
                                          size: 16,
                                          color: Color(0xFF4F46E5),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Live ATS A4 Sheet',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_rounded,
                                            size: 18,
                                          ),
                                          tooltip: 'Zoom Out',
                                          onPressed: () {
                                            if (_previewScale > 0.5) {
                                              setState(() {
                                                _previewScale -= 0.05;
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                          '${(_previewScale * 100).toInt()}%',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            size: 18,
                                          ),
                                          tooltip: 'Zoom In',
                                          onPressed: () {
                                            if (_previewScale < 1.0) {
                                              setState(() {
                                                _previewScale += 0.05;
                                              });
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.refresh_rounded,
                                            size: 18,
                                          ),
                                          tooltip: 'Reset Zoom (72%)',
                                          onPressed: () {
                                            setState(() {
                                              _previewScale = 0.72;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Live Page Viewer
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: ResumeRenderer(
                                      resume: resume,
                                      scale: _previewScale,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _showPreviewOnMobile
                ? Container(
                    color: isDark
                        ? const Color(0xFF090D16)
                        : const Color(0xFFE2E8F0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: ResumeRenderer(resume: resume, scale: 0.55),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Section Horizontal Selector
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _sections.asMap().entries.map((e) {
                              final isSelected = _selectedSectionIndex == e.key;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(e.value.title),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() {
                                        _selectedSectionIndex = e.key;
                                      });
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildActiveSectionForm(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionMeta {
  final String title;
  final IconData icon;
  final String routeSlug;

  const _SectionMeta(this.title, this.icon, this.routeSlug);
}
