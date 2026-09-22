import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ResumeRenderer extends StatelessWidget {
  final Resume resume;
  final double scale;

  const ResumeRenderer({super.key, required this.resume, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final isCompact = resume.templateId == 'ats_compact';

    return Transform.scale(
      scale: scale,
      alignment: Alignment.topCenter,
      child: Container(
        width: 794, // Standard A4 width in px at 96 DPI
        constraints: const BoxConstraints(
          minHeight: 1123,
        ), // Standard A4 height
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 36 : 48,
          vertical: isCompact ? 36 : 48,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildTemplateContent(context),
      ),
    );
  }

  Widget _buildTemplateContent(BuildContext context) {
    switch (resume.templateId) {
      case 'ats_harvard':
        return _buildHarvardTemplate();
      case 'ats_tech_minimal':
        return _buildTechMinimalTemplate();
      case 'ats_modern_clean':
        return _buildModernCleanTemplate();
      case 'ats_executive':
        return _buildExecutiveTemplate();
      case 'ats_data_fintech':
        return _buildDataFintechTemplate();
      case 'ats_compact':
        return _buildCompactTemplate();
      case 'ats_stanford':
        return _buildStanfordTemplate();
      case 'ats_professional':
        return _buildProfessionalTemplate();
      case 'ats_fresher':
        return _buildFresherTemplate();
      case 'ats_experienced':
        return _buildExperiencedTemplate();
      case 'ats_classic':
      default:
        return _buildClassicTemplate();
    }
  }

  // ==========================================
  // 1. ATS Classic Template
  // ==========================================
  Widget _buildClassicTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                (resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'FULL NAME')
                    .toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
              if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  resume.personalInfo.professionalTitle,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              _buildContactLine(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: Colors.black87, thickness: 1.2),
        const SizedBox(height: 12),

        if (resume.summary.isNotEmpty) ...[
          _buildClassicSectionHeading('PROFESSIONAL SUMMARY'),
          const SizedBox(height: 6),
          Text(
            resume.summary,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildClassicSectionHeading('WORK EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildClassicSectionHeading('EDUCATION'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildClassicSectionHeading('SKILLS & EXPERTISE'),
          const SizedBox(height: 6),
          Text(
            resume.skills.map((s) => s.name).join(' • '),
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildClassicSectionHeading('KEY PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.certifications.isNotEmpty) ...[
          _buildClassicSectionHeading('CERTIFICATIONS'),
          const SizedBox(height: 6),
          ...resume.certifications.map((cert) => _buildCertItem(cert)),
          const SizedBox(height: 12),
        ],

        if (resume.languages.isNotEmpty) ...[
          _buildClassicSectionHeading('LANGUAGES'),
          const SizedBox(height: 6),
          Text(
            resume.languages
                .map((l) => '${l.language} (${l.proficiency})')
                .join(', '),
            style: const TextStyle(fontSize: 10, color: Colors.black87),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // 2. Harvard Ivy League ATS Template (Gold Standard)
  // ==========================================
  Widget _buildHarvardTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Centered Header with strict academic serif
        Center(
          child: Column(
            children: [
              Text(
                (resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'FIRSTNAME LASTNAME')
                    .toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              _buildContactLine(separator: ' • '),
              if (resume.personalInfo.linkedinUrl != null &&
                  resume.personalInfo.linkedinUrl!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  '${resume.personalInfo.linkedinUrl!}${resume.personalInfo.githubUrl != null && resume.personalInfo.githubUrl!.isNotEmpty ? ' • ${resume.personalInfo.githubUrl!}' : ''}',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontFamily: 'serif',
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Education First (Harvard Standard)
        if (resume.educations.isNotEmpty) ...[
          _buildHarvardSectionHeading('EDUCATION'),
          const SizedBox(height: 6),
          ...resume.educations.map((edu) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          edu.institution.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          edu.location.isNotEmpty ? edu.location : '',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${edu.degree}${edu.gradeOrCgpa.isNotEmpty ? ' (GPA: ${edu.gradeOrCgpa})' : ''}',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${edu.startDate} – ${edu.endDate}',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 9.5,
                            color: Color(0xFF444444),
                          ),
                        ),
                      ],
                    ),
                    if (edu.description != null &&
                        edu.description!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        edu.description!,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 9.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              )),
          const SizedBox(height: 10),
        ],

        // Experience
        if (resume.experiences.isNotEmpty) ...[
          _buildHarvardSectionHeading('EXPERIENCE'),
          const SizedBox(height: 6),
          ...resume.experiences.map((exp) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exp.company.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          exp.location.isNotEmpty ? exp.location : '',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exp.jobTitle,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${exp.startDate} – ${exp.isCurrentlyWorking ? 'Present' : exp.endDate}',
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 9.5,
                            color: Color(0xFF444444),
                          ),
                        ),
                      ],
                    ),
                    if (exp.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      ..._buildBulletPoints(exp.description, isSerif: true),
                    ],
                  ],
                ),
              )),
          const SizedBox(height: 10),
        ],

        // Projects
        if (resume.projects.isNotEmpty) ...[
          _buildHarvardSectionHeading('PROJECTS & LEADERSHIP'),
          const SizedBox(height: 6),
          ...resume.projects.map((proj) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          proj.projectName,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (proj.startDate != null)
                          Text(
                            '${proj.startDate} – ${proj.endDate ?? 'Present'}',
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 9.5,
                              color: Color(0xFF444444),
                            ),
                          ),
                      ],
                    ),
                    if (proj.technologies.isNotEmpty)
                      Text(
                        'Technologies: ${proj.technologies}',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 9.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF333333),
                        ),
                      ),
                    if (proj.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      ..._buildBulletPoints(proj.description, isSerif: true),
                    ],
                  ],
                ),
              )),
          const SizedBox(height: 10),
        ],

        // Skills & Interests
        if (resume.skills.isNotEmpty || resume.languages.isNotEmpty) ...[
          _buildHarvardSectionHeading('SKILLS & INTERESTS'),
          const SizedBox(height: 6),
          if (resume.skills.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Technical Skills: ',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    resume.skills.map((s) => s.name).join(', '),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 10,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          if (resume.languages.isNotEmpty) ...[
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Languages: ',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    resume.languages
                        .map((l) => '${l.language} (${l.proficiency})')
                        .join(', '),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildHarvardSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1.2, color: Colors.black),
      ],
    );
  }

  // ==========================================
  // 3. Tech Minimalist ATS Template (Silicon Valley Standard)
  // ==========================================
  Widget _buildTechMinimalTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left-Aligned Modern Tech Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'DEVELOPER NAME',
                    style: const TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      resume.personalInfo.professionalTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (resume.personalInfo.email.isNotEmpty)
                  Text(
                    resume.personalInfo.email,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF334155),
                    ),
                  ),
                if (resume.personalInfo.phone.isNotEmpty)
                  Text(
                    resume.personalInfo.phone,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF334155),
                    ),
                  ),
                if (resume.personalInfo.githubUrl != null &&
                    resume.personalInfo.githubUrl!.isNotEmpty)
                  Text(
                    resume.personalInfo.githubUrl!,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF2563EB),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(height: 2, color: const Color(0xFF0F172A)),
        const SizedBox(height: 12),

        // Technical Skills Matrix First
        if (resume.skills.isNotEmpty) ...[
          _buildTechSectionHeading('TECHNICAL SKILLS'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Core Competencies: ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        resume.skills.map((s) => s.name).join(' • '),
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.4,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Work Experience
        if (resume.experiences.isNotEmpty) ...[
          _buildTechSectionHeading('WORK EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        // Projects
        if (resume.projects.isNotEmpty) ...[
          _buildTechSectionHeading('KEY ENGINEERING PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        // Education
        if (resume.educations.isNotEmpty) ...[
          _buildTechSectionHeading('EDUCATION'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        // Certifications
        if (resume.certifications.isNotEmpty) ...[
          _buildTechSectionHeading('CERTIFICATIONS & BADGES'),
          const SizedBox(height: 6),
          ...resume.certifications.map((cert) => _buildCertItem(cert)),
        ],
      ],
    );
  }

  Widget _buildTechSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 12, color: const Color(0xFF2563EB)),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: const Color(0xFFE2E8F0)),
      ],
    );
  }

  // ==========================================
  // 4. Executive Leadership ATS Template
  // ==========================================
  Widget _buildExecutiveTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Executive Header
        Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E293B), width: 2.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (resume.personalInfo.fullName.isNotEmpty
                            ? resume.personalInfo.fullName
                            : 'EXECUTIVE CANDIDATE')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      resume.personalInfo.professionalTitle.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildContactLine(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Executive Profile Box
        if (resume.summary.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
              border: const Border(
                left: BorderSide(color: Color(0xFF0F172A), width: 3.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXECUTIVE PROFILE & VALUE PROPOSITION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resume.summary,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Core Competencies Grid
        if (resume.skills.isNotEmpty) ...[
          _buildExecutiveSectionHeading('CORE LEADERSHIP COMPETENCIES'),
          const SizedBox(height: 6),
          Text(
            resume.skills.map((s) => s.name).join(' | '),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Experience
        if (resume.experiences.isNotEmpty) ...[
          _buildExecutiveSectionHeading('EXECUTIVE & PROFESSIONAL EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        // Education
        if (resume.educations.isNotEmpty) ...[
          _buildExecutiveSectionHeading('EDUCATION & CREDENTIALS'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
        ],
      ],
    );
  }

  Widget _buildExecutiveSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1.5, color: const Color(0xFF0F172A)),
      ],
    );
  }

  // ==========================================
  // 5. Compact 1-Page High-Density ATS Template
  // ==========================================
  Widget _buildCompactTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                (resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'FULL NAME')
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              _buildContactLine(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.black87, thickness: 1, height: 8),
        const SizedBox(height: 6),

        if (resume.summary.isNotEmpty) ...[
          _buildCompactSectionHeading('SUMMARY'),
          const SizedBox(height: 3),
          Text(
            resume.summary,
            style: const TextStyle(
              fontSize: 9.5,
              height: 1.35,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildCompactSectionHeading('EXPERIENCE'),
          const SizedBox(height: 5),
          ...resume.experiences.map((exp) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${exp.jobTitle} — ${exp.company}',
                          style: const TextStyle(
                            fontSize: 9.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${exp.startDate}–${exp.isCurrentlyWorking ? 'Present' : exp.endDate}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    if (exp.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        exp.description,
                        style: const TextStyle(
                          fontSize: 9,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              )),
          const SizedBox(height: 6),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildCompactSectionHeading('EDUCATION'),
          const SizedBox(height: 4),
          ...resume.educations.map((edu) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${edu.degree}, ${edu.institution}',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${edu.startDate}–${edu.endDate}',
                      style: const TextStyle(fontSize: 9, color: Colors.black54),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 6),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildCompactSectionHeading('SKILLS'),
          const SizedBox(height: 3),
          Text(
            resume.skills.map((s) => s.name).join(' • '),
            style: const TextStyle(
              fontSize: 9.5,
              height: 1.35,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildCompactSectionHeading('PROJECTS'),
          const SizedBox(height: 4),
          ...resume.projects.map((proj) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${proj.projectName}${proj.technologies.isNotEmpty ? ' (${proj.technologies})' : ''}',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (proj.description.isNotEmpty)
                      Text(
                        proj.description,
                        style: const TextStyle(
                          fontSize: 9,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                      ),
                  ],
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildCompactSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 1),
        Container(height: 0.8, color: Colors.black54),
      ],
    );
  }

  // ==========================================
  // 6. ATS Professional Template
  // ==========================================
  Widget _buildProfessionalTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'FULL NAME',
                    style: const TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E3A8A), // Navy accent
                    ),
                  ),
                  if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      resume.personalInfo.professionalTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (resume.personalInfo.email.isNotEmpty)
                  Text(
                    resume.personalInfo.email,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Colors.black87,
                    ),
                  ),
                if (resume.personalInfo.phone.isNotEmpty)
                  Text(
                    resume.personalInfo.phone,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Colors.black87,
                    ),
                  ),
                if (resume.personalInfo.location.isNotEmpty)
                  Text(
                    resume.personalInfo.location,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Colors.black87,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(height: 2, color: const Color(0xFF1E3A8A)),
        const SizedBox(height: 14),

        if (resume.summary.isNotEmpty) ...[
          _buildProfessionalSectionHeading('EXECUTIVE SUMMARY'),
          const SizedBox(height: 6),
          Text(
            resume.summary,
            style: const TextStyle(
              fontSize: 10,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildProfessionalSectionHeading('PROFESSIONAL EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildProfessionalSectionHeading(
            'CORE COMPETENCIES & TECHNICAL SKILLS',
          ),
          const SizedBox(height: 6),
          Text(
            resume.skills.map((s) => s.name).join(' | '),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildProfessionalSectionHeading('PROJECT PORTFOLIO'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildProfessionalSectionHeading('EDUCATION & CREDENTIALS'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
        ],
      ],
    );
  }

  // ==========================================
  // 7. ATS Fresher Template
  // ==========================================
  Widget _buildFresherTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                resume.personalInfo.fullName.isNotEmpty
                    ? resume.personalInfo.fullName
                    : 'FULL NAME',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              _buildContactLine(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: Colors.black87, thickness: 1),
        const SizedBox(height: 10),

        if (resume.summary.isNotEmpty) ...[
          _buildClassicSectionHeading('CAREER OBJECTIVE'),
          const SizedBox(height: 6),
          Text(
            resume.summary,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildClassicSectionHeading('EDUCATION'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildClassicSectionHeading('TECHNICAL SKILLS'),
          const SizedBox(height: 6),
          Text(
            resume.skills.map((s) => s.name).join(' • '),
            style: const TextStyle(
              fontSize: 10,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildClassicSectionHeading('ACADEMIC & PERSONAL PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildClassicSectionHeading('INTERNSHIPS & EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
        ],
      ],
    );
  }

  // ==========================================
  // 8. Modern Clean Minimalist ATS Template
  // ==========================================
  Widget _buildModernCleanTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (resume.personalInfo.fullName.isNotEmpty
                            ? resume.personalInfo.fullName
                            : 'FULL NAME')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      resume.personalInfo.professionalTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488), // Slate Teal Accent
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildContactLine(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 1.5,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF64748B)],
            ),
          ),
        ),
        const SizedBox(height: 12),

        if (resume.summary.isNotEmpty) ...[
          _buildModernSectionHeading('PROFESSIONAL PROFILE', const Color(0xFF0D9488)),
          const SizedBox(height: 6),
          Text(
            resume.summary,
            style: const TextStyle(
              fontSize: 10,
              height: 1.45,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildModernSectionHeading('SKILLS & EXPERTISE', const Color(0xFF0D9488)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: resume.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
                ),
                child: Text(
                  skill.name,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildModernSectionHeading('WORK EXPERIENCE', const Color(0xFF0D9488)),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildModernSectionHeading('KEY PROJECTS', const Color(0xFF0D9488)),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildModernSectionHeading('EDUCATION', const Color(0xFF0D9488)),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        if (resume.certifications.isNotEmpty) ...[
          _buildModernSectionHeading('CERTIFICATIONS', const Color(0xFF0D9488)),
          const SizedBox(height: 6),
          ...resume.certifications.map((cert) => _buildCertItem(cert)),
        ],
      ],
    );
  }

  Widget _buildModernSectionHeading(String title, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 11, color: accentColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: const Color(0xFFE2E8F0)),
      ],
    );
  }

  // ==========================================
  // 9. Quant, Data & FinTech ATS Template
  // ==========================================
  Widget _buildDataFintechTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                (resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'QUANTITATIVE ANALYST')
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Color(0xFF0F172A),
                ),
              ),
              if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  resume.personalInfo.professionalTitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Color(0xFF1E40AF),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              _buildContactLine(separator: ' • '),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1.5, color: const Color(0xFF1E40AF)),
        const SizedBox(height: 10),

        if (resume.summary.isNotEmpty) ...[
          _buildFintechSectionHeading('EXECUTIVE SUMMARY & QUANTITATIVE PROFILE'),
          const SizedBox(height: 5),
          Text(
            resume.summary,
            style: const TextStyle(fontSize: 10, height: 1.4, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildFintechSectionHeading('TECHNICAL & QUANTITATIVE COMPETENCIES'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stack & Tools: ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                Expanded(
                  child: Text(
                    resume.skills.map((s) => s.name).join(' | '),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildFintechSectionHeading('QUANTITATIVE & INDUSTRY EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildFintechSectionHeading('ANALYTICAL & FINANCIAL MODELING PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildFintechSectionHeading('ACADEMIC BACKGROUND & QUANTITATIVE DEGREES'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        if (resume.certifications.isNotEmpty) ...[
          _buildFintechSectionHeading('PROFESSIONAL CERTIFICATIONS & LICENSES'),
          const SizedBox(height: 6),
          ...resume.certifications.map((cert) => _buildCertItem(cert)),
        ],
      ],
    );
  }

  Widget _buildFintechSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.9,
            color: Color(0xFF1E40AF),
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: const Color(0xFF1E40AF)),
      ],
    );
  }

  // ==========================================
  // 10. Stanford Academic & Research ATS Template
  // ==========================================
  Widget _buildStanfordTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                (resume.personalInfo.fullName.isNotEmpty
                        ? resume.personalInfo.fullName
                        : 'RESEARCH CANDIDATE')
                    .toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                  color: Color(0xFF8C1D40), // Stanford Cardinal Accent
                ),
              ),
              if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  resume.personalInfo.professionalTitle,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              _buildContactLine(separator: ' • '),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFF8C1D40), thickness: 1.5, height: 1.5),
        const SizedBox(height: 12),

        if (resume.summary.isNotEmpty) ...[
          _buildStanfordSectionHeading('RESEARCH STATEMENT & SCHOLARLY OBJECTIVES'),
          const SizedBox(height: 5),
          Text(
            resume.summary,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 10,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildStanfordSectionHeading('EDUCATION & ACADEMIC CREDENTIALS'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildStanfordSectionHeading('ACADEMIC & RESEARCH APPOINTMENTS'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildStanfordSectionHeading('PUBLICATIONS, PATENTS & RESEARCH INITIATIVES'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildStanfordSectionHeading('RESEARCH METHODOLOGIES & TECHNICAL SKILLS'),
          const SizedBox(height: 6),
          Text(
            resume.skills.map((s) => s.name).join(' • '),
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 10,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (resume.certifications.isNotEmpty) ...[
          _buildStanfordSectionHeading('HONORS, FELLOWSHIPS & CERTIFICATIONS'),
          const SizedBox(height: 6),
          ...resume.certifications.map((cert) => _buildCertItem(cert)),
        ],
      ],
    );
  }

  Widget _buildStanfordSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: Color(0xFF8C1D40),
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: const Color(0xFF8C1D40)),
      ],
    );
  }

  // ==========================================
  // 11. ATS Experienced & Career Progression Template
  // ==========================================
  Widget _buildExperiencedTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (resume.personalInfo.fullName.isNotEmpty
                            ? resume.personalInfo.fullName
                            : 'CANDIDATE NAME')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (resume.personalInfo.professionalTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      resume.personalInfo.professionalTitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4338CA),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildContactLine(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(height: 2, color: const Color(0xFF4338CA)),
        const SizedBox(height: 12),

        if (resume.summary.isNotEmpty) ...[
          _buildExperiencedSectionHeading('EXECUTIVE & PROFESSIONAL SUMMARY'),
          const SizedBox(height: 6),
          Text(
            resume.summary,
            style: const TextStyle(
              fontSize: 10,
              height: 1.45,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.skills.isNotEmpty) ...[
          _buildExperiencedSectionHeading('CORE LEADERSHIP & TECHNICAL COMPETENCIES'),
          const SizedBox(height: 6),
          Text(
            resume.skills.map((s) => s.name).join(' • '),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),
        ],

        if (resume.experiences.isNotEmpty) ...[
          _buildExperiencedSectionHeading('CHRONOLOGICAL CAREER PROGRESSION'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildExperiencedSectionHeading('KEY INITIATIVES & HIGH-IMPACT PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        if (resume.educations.isNotEmpty) ...[
          _buildExperiencedSectionHeading('EDUCATION & ACADEMIC BACKGROUND'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        if (resume.certifications.isNotEmpty) ...[
          _buildExperiencedSectionHeading('PROFESSIONAL CERTIFICATIONS'),
          const SizedBox(height: 6),
          ...resume.certifications.map((cert) => _buildCertItem(cert)),
        ],
      ],
    );
  }

  Widget _buildExperiencedSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Color(0xFF4338CA),
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1.2, color: const Color(0xFF4338CA)),
      ],
    );
  }

  // ==========================================
  // Shared Helper Widgets
  // ==========================================
  Widget _buildContactLine({String separator = ' | '}) {
    final items = <String>[];
    if (resume.personalInfo.location.isNotEmpty) {
      items.add(resume.personalInfo.location);
    }
    if (resume.personalInfo.phone.isNotEmpty) {
      items.add(resume.personalInfo.phone);
    }
    if (resume.personalInfo.email.isNotEmpty) {
      items.add(resume.personalInfo.email);
    }
    if (resume.personalInfo.linkedinUrl != null &&
        resume.personalInfo.linkedinUrl!.isNotEmpty) {
      items.add(resume.personalInfo.linkedinUrl!);
    }
    if (resume.personalInfo.githubUrl != null &&
        resume.personalInfo.githubUrl!.isNotEmpty) {
      items.add(resume.personalInfo.githubUrl!);
    }

    return Text(
      items.join(separator),
      style: const TextStyle(fontSize: 9.5, color: Color(0xFF444444)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildClassicSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: Colors.black87),
      ],
    );
  }

  Widget _buildProfessionalSectionHeading(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1.5, color: const Color(0xFF1E3A8A)),
      ],
    );
  }

  Widget _buildClassicExperienceItem(dynamic exp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exp.jobTitle,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${exp.startDate} – ${exp.isCurrentlyWorking ? 'Present' : exp.endDate}',
                style: const TextStyle(fontSize: 9.5, color: Colors.black87),
              ),
            ],
          ),
          Text(
            '${exp.company}${exp.location.isNotEmpty ? ' • ${exp.location}' : ''}',
            style: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Color(0xFF333333),
            ),
          ),
          if (exp.description.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              exp.description,
              style: const TextStyle(
                fontSize: 9.5,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClassicEducationItem(dynamic edu) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                edu.degree,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${edu.startDate} – ${edu.endDate}',
                style: const TextStyle(fontSize: 9.5, color: Colors.black87),
              ),
            ],
          ),
          Text(
            '${edu.institution}${edu.location.isNotEmpty ? ' • ${edu.location}' : ''}${edu.gradeOrCgpa.isNotEmpty ? ' | GPA: ${edu.gradeOrCgpa}' : ''}',
            style: const TextStyle(
              fontSize: 9.5,
              fontStyle: FontStyle.italic,
              color: Color(0xFF333333),
            ),
          ),
          if (edu.description != null && edu.description!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              edu.description!,
              style: const TextStyle(fontSize: 9, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClassicProjectItem(dynamic proj) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                proj.projectName,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (proj.startDate != null)
                Text(
                  '${proj.startDate} – ${proj.endDate ?? 'Present'}',
                  style: const TextStyle(fontSize: 9.5, color: Colors.black87),
                ),
            ],
          ),
          if (proj.technologies.isNotEmpty)
            Text(
              'Technologies: ${proj.technologies}',
              style: const TextStyle(
                fontSize: 9.5,
                fontStyle: FontStyle.italic,
                color: Color(0xFF333333),
              ),
            ),
          if (proj.description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              proj.description,
              style: const TextStyle(
                fontSize: 9.5,
                height: 1.35,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCertItem(dynamic cert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${cert.name} — ${cert.issuingOrganization}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            cert.issueDate,
            style: const TextStyle(
              fontSize: 9.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBulletPoints(String text, {bool isSerif = false}) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    return lines.map((line) {
      final cleanLine = line.trim().startsWith('•') || line.trim().startsWith('-')
          ? line.trim().substring(1).trim()
          : line.trim();
      return Padding(
        padding: const EdgeInsets.only(bottom: 2.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• ',
              style: TextStyle(
                fontFamily: isSerif ? 'serif' : null,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Text(
                cleanLine,
                style: TextStyle(
                  fontFamily: isSerif ? 'serif' : null,
                  fontSize: 9.5,
                  height: 1.35,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
