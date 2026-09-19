import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';

class PdfDownloadButton extends StatefulWidget {
  final String resumeId;
  final String title;

  const PdfDownloadButton({
    super.key,
    required this.resumeId,
    required this.title,
  });

  @override
  State<PdfDownloadButton> createState() => _PdfDownloadButtonState();
}

class _PdfDownloadButtonState extends State<PdfDownloadButton> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    setState(() {
      _isDownloading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Downloading ${widget.title}.pdf... (ATS A4 Standard Format)',
          ),
          backgroundColor: Colors.green,
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
