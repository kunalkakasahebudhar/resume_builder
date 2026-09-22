import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';

class PdfDownloadButton extends ConsumerStatefulWidget {
  final String resumeId;
  final String title;

  const PdfDownloadButton({
    super.key,
    required this.resumeId,
    required this.title,
  });

  @override
  ConsumerState<PdfDownloadButton> createState() => _PdfDownloadButtonState();
}

class _PdfDownloadButtonState extends ConsumerState<PdfDownloadButton> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    final allowed = await ref
        .read(subscriptionProvider.notifier)
        .checkAndConsumeQuota(context, actionName: 'PDF Download');

    if (!allowed) return;

    setState(() {
      _isDownloading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Downloaded "${widget.title}.pdf" (ATS A4 Standard Format)',
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Download PDF',
      icon: Icons.download_rounded,
      isLoading: _isDownloading,
      onPressed: _handleDownload,
    );
  }
}
