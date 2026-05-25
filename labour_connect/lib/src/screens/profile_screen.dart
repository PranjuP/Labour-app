import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database.dart';
import '../../services/auth.dart';
import '../../helper/helperfunctions.dart';
import '../../models/posting.dart';
import '../../widgets/posting_card.dart';

/// Shows the logged-in user's profile and their own postings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _db = DatabaseMethods();
  String? _uid;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = await HelperFunctions.getUserID();
    final name = await HelperFunctions.getUserName();
    final email = await HelperFunctions.getUserEmail();
    if (mounted) {
      setState(() {
        _uid = uid;
        _userName = name;
        _userEmail = email;
      });
    }
  }

  String get _initials {
    final name = _userName ?? '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (name.isNotEmpty) return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Profile card ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A4A2E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFF6EE89E),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A4A2E)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _userName ?? 'User',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                if (_userEmail != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _userEmail!,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── My postings ────────────────────────────────────────────────────
          const Text(
            'MY POSTINGS',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF888888),
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),

          if (_uid == null)
            const Center(child: CircularProgressIndicator())
          else
            StreamBuilder<QuerySnapshot>(
              stream: _db.getMyPostings(_uid!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.post_add_rounded,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text(
                          'No postings yet',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + below to create your first post',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                final postings = snapshot.data!.docs
                    .map((doc) => Posting.fromSnapshot(doc))
                    .toList();

                return Column(
                  children: postings
                      .map((p) => PostingCard(
                            posting: p,
                            showDeleteButton: true,
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete posting?'),
                                  content: const Text(
                                      'This will permanently remove your posting from the feed.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete',
                                            style: TextStyle(
                                                color: Colors.red))),
                                  ],
                                ),
                              );
                              if (confirm == true && p.id != null) {
                                await _db.deletePosting(p.id!);
                              }
                            },
                          ))
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
