import 'package:flutter/material.dart';

enum AuditActionType {
  userBanned('User Banned', Icons.block_rounded, Color(0xFFEF4444)),
  userUnbanned('User Unbanned', Icons.check_circle_outline, Color(0xFF10B981)),
  userDeleted('User Deleted', Icons.delete_forever_rounded, Color(0xFFEF4444)),
  userImpersonated('User Impersonation', Icons.fingerprint_rounded, Color(0xFFD97706)),
  userPasswordReset('Password Reset Triggered', Icons.lock_reset_rounded, Color(0xFFF59E0B)),
  roleChanged('Role Changed', Icons.badge_outlined, Color(0xFF8B5CF6)),
  templateCreated('Template Created', Icons.add_box_outlined, Color(0xFF06B6D4)),
  templateUpdated('Template Updated', Icons.edit_note_rounded, Color(0xFF3B82F6)),
  templateDeleted('Template Deleted', Icons.delete_outline_rounded, Color(0xFFEF4444)),
  resumeQuarantined('Resume Quarantined', Icons.shield_outlined, Color(0xFFEF4444)),
  resumeRestored('Resume Restored', Icons.restore_rounded, Color(0xFF10B981)),
  resumeDeleted('Resume Deleted', Icons.delete_outline_rounded, Color(0xFFEF4444)),
  contentQuarantined('Content Quarantined', Icons.shield_outlined, Color(0xFFEF4444)),
  contentDismissed('Content Dismissed', Icons.check_circle_outline, Color(0xFF10B981)),
  shareLinkRevoked('Share Link Revoked', Icons.link_off_rounded, Color(0xFFEF4444)),
  aiConfigUpdated('AI Config Updated', Icons.psychology_rounded, Color(0xFF8B5CF6)),
  aiPromptEdited('AI Prompt Edited', Icons.psychology_rounded, Color(0xFF8B5CF6)),
  aiKillSwitchToggled('AI Kill Switch Toggled', Icons.power_settings_new_rounded, Color(0xFFDC2626)),
  atsRubricCalibrated('ATS Rubric Calibrated', Icons.tune_rounded, Color(0xFF10B981)),
  promoCodeCreated('Promo Code Created', Icons.local_offer_outlined, Color(0xFF10B981)),
  promoCodeUpdated('Promo Code Updated', Icons.edit_note_rounded, Color(0xFF3B82F6)),
  promoCodeDeleted('Promo Code Deleted', Icons.money_off_rounded, Color(0xFFEF4444)),
  subscriptionRefunded('Subscription Refunded', Icons.currency_rupee_rounded, Color(0xFFF59E0B)),
  featureFlagToggled('Feature Flag Toggled', Icons.toggle_on_outlined, Color(0xFF4F46E5)),
  maintenanceModeToggled('Maintenance Mode Toggled', Icons.construction_rounded, Color(0xFFDC2626)),
  platformSettingsUpdated('Platform Settings Updated', Icons.settings_rounded, Color(0xFF3B82F6)),
  announcementBroadcasted('Notification Broadcast', Icons.campaign_rounded, Color(0xFF06B6D4));

  final String label;
  final IconData icon;
  final Color color;
  const AuditActionType(this.label, this.icon, this.color);
}

typedef AuditAction = AuditActionType;

class AuditLog {
  final String id;
  final String actorId;
  final String actorName;
  final String actorEmail;
  final String actorRole;
  final AuditActionType actionType;
  final String targetEntity;
  final String targetId;
  final String description;
  final Map<String, dynamic>? beforeState;
  final Map<String, dynamic>? afterState;
  final String ipAddress;
  final DateTime timestamp;

  const AuditLog({
    required this.id,
    required this.actorId,
    required this.actorName,
    required this.actorEmail,
    required this.actorRole,
    required this.actionType,
    required this.targetEntity,
    required this.targetId,
    required this.description,
    this.beforeState,
    this.afterState,
    required this.ipAddress,
    required this.timestamp,
  });

  String get actor => actorName;
  AuditActionType get action => actionType;
  String get targetType => targetEntity;
  Map<String, dynamic>? get metadata => afterState ?? beforeState;
}
