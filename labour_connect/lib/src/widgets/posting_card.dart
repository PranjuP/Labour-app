import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/posting.dart';

class PostingCard extends StatelessWidget {
  final Posting posting;
  final bool showDeleteButton;
  final VoidCallback? onDelete;

  const PostingCard({
    Key? key,
    required this.posting,
    this.showDeleteButton = false,
    this.onDelete,
  }) : super(key: key);

  // ── Helpers ────────────────────────────────────────────────────────────────

  Color get _typeColor =>
      posting.type == PostingType.company
          ? const Color(0xFF1565C0)
          : const Color(0xFF2E7D32);

  Color get _typeBg =>
      posting.type == PostingType.company
          ? const Color(0xFFE3F2FD)
          : const Color(0xFFE8F5E9);

  String get _typeLabel =>
      posting.type == PostingType.company ? 'Needs Workers' : 'Available';

  String get _initials {
    final name = posting.posterName ?? '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (name.isNotEmpty) return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
    return '??';
  }

  String get _timeAgo {
    if (posting.createdAt == null) return '';
    final diff = DateTime.now().difference(posting.createdAt!);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _makeCall(BuildContext context) async {
    final phone = posting.phone ?? '';
    if (phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open dialler')));
    }
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final phone = (posting.phone ?? '').replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/91$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    final email = posting.email ?? '';
    if (email.isEmpty) return;
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _typeBg,
                  child: Text(
                    _initials,
                    style: TextStyle(
                      color: _typeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        posting.posterName ?? '—',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      Text(
                        _timeAgo,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                // Type badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _typeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _typeLabel,
                    style: TextStyle(
                        color: _typeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (showDeleteButton) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.redAccent),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 10),

            // ── Work type ───────────────────────────────────────────────────
            Text(
              posting.workType ?? '—',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),

            // ── Urgent badge ────────────────────────────────────────────────
            if (posting.urgent)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '⚡ URGENT',
                  style: TextStyle(
                      color: Color(0xFFC62828),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5),
                ),
              ),

            const SizedBox(height: 8),

            // ── Detail chips ────────────────────────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _DetailChip(icon: Icons.location_on_outlined,
                    label: posting.location ?? '—'),
                _DetailChip(icon: Icons.schedule_outlined,
                    label: posting.duration ?? '—'),
                _DetailChip(icon: Icons.currency_rupee,
                    label: posting.wage ?? 'Negotiable'),
              ],
            ),

            // ── Notes ───────────────────────────────────────────────────────
            if ((posting.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                posting.notes!,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.5),
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // ── Contact buttons ─────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _ContactButton(
                    icon: Icons.phone,
                    label: posting.phone ?? 'Call',
                    color: const Color(0xFF1A4A2E),
                    textColor: Colors.white,
                    onTap: () => _makeCall(context),
                  ),
                ),
                const SizedBox(width: 8),
                _IconContactButton(
                  iconPath: 'whatsapp',
                  tooltip: 'WhatsApp',
                  icon: Icons.chat_outlined,
                  onTap: () => _openWhatsApp(context),
                ),
                if ((posting.email ?? '').isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _IconContactButton(
                    iconPath: 'email',
                    tooltip: 'Email',
                    icon: Icons.email_outlined,
                    onTap: () => _sendEmail(context),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small helper widgets ───────────────────────────────────────────────────────

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  const _ContactButton(
      {required this.icon,
      required this.label,
      required this.color,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        onPrimary: textColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        textStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _IconContactButton extends StatelessWidget {
  final String iconPath;
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  const _IconContactButton(
      {required this.iconPath,
      required this.tooltip,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade700),
        ),
      ),
    );
  }
}
