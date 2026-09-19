import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ResumeRenderer extends StatelessWidget {
  final Resume resume;
  final double scale;

  const ResumeRenderer({super.key, required this.resume, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.topCenter,
      child: Container(
        width: 794, // Standard A4 width in px at 96 DPI
        constraints: const BoxConstraints(
          minHeight: 1123,
        ), // Standard A4 height
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
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

  // 1. ATS Classic Template
  Widget _buildClassicTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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

        // Summary
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

        // Experience
        if (resume.experiences.isNotEmpty) ...[
          _buildClassicSectionHeading('WORK EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        // Education
        if (resume.educations.isNotEmpty) ...[
          _buildClassicSectionHeading('EDUCATION'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        // Skills
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

        // Projects
        if (resume.projects.isNotEmpty) ...[
          _buildClassicSectionHeading('KEY PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        // Certifications
        if (resume.certifications.isNotEmpty) ...[
          _buildClassicSectionHeading('CERTIFICATIONS'),
          const SizedBox(height: 6),
          ...resume.certifications.map(
            (cert) => Padding(
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
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Languages
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

  // 2. ATS Professional Template
  Widget _buildProfessionalTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern Clean Header
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
                if (resume.personalInfo.linkedinUrl != null &&
                    resume.personalInfo.linkedinUrl!.isNotEmpty)
                  Text(
                    resume.personalInfo.linkedinUrl!,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF2563EB),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(height: 2, color: const Color(0xFF1E3A8A)),
        const SizedBox(height: 14),

        // Summary
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

        // Experience
        if (resume.experiences.isNotEmpty) ...[
          _buildProfessionalSectionHeading('PROFESSIONAL EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
          const SizedBox(height: 12),
        ],

        // Skills
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

        // Projects
        if (resume.projects.isNotEmpty) ...[
          _buildProfessionalSectionHeading('PROJECT PORTFOLIO'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        // Education
        if (resume.educations.isNotEmpty) ...[
          _buildProfessionalSectionHeading('EDUCATION & CREDENTIALS'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
        ],
      ],
    );
  }

  // 3. ATS Fresher Template
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

        // Objective
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

        // Education First for Freshers
        if (resume.educations.isNotEmpty) ...[
          _buildClassicSectionHeading('EDUCATION'),
          const SizedBox(height: 8),
          ...resume.educations.map((edu) => _buildClassicEducationItem(edu)),
          const SizedBox(height: 12),
        ],

        // Technical Skills
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

        // Academic Projects
        if (resume.projects.isNotEmpty) ...[
          _buildClassicSectionHeading('ACADEMIC & PERSONAL PROJECTS'),
          const SizedBox(height: 8),
          ...resume.projects.map((proj) => _buildClassicProjectItem(proj)),
          const SizedBox(height: 12),
        ],

        // Experience / Internships
        if (resume.experiences.isNotEmpty) ...[
          _buildClassicSectionHeading('INTERNSHIPS & EXPERIENCE'),
          const SizedBox(height: 8),
          ...resume.experiences.map((exp) => _buildClassicExperienceItem(exp)),
        ],
      ],
    );
  }

  // 4. ATS Experienced Template
  Widget _buildExperiencedTemplate() {
    return _buildClassicTemplate(); // Standard clean format with emphasized outcomes
  }

  Widget _buildContactLine() {
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
      items.join(' | '),
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
}
