import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import '../models/posting.dart';
import '../widgets/posting_card.dart';

/// The main feed screen. Shows all postings with filter tabs.
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseMethods _db = DatabaseMethods();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Returns the correct stream for each tab index
  Stream<QuerySnapshot> _streamForTab(int index) {
    switch (index) {
      case 1:
        return _db.getPostingsByType('company');
      case 2:
        return _db.getPostingsByType('labour');
      default:
        return _db.getAllPostings();
    }
  }

  Widget _buildList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded,
                    size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No postings yet',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 15)),
                const SizedBox(height: 6),
                Text('Be the first to post!',
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: 13)),
              ],
            ),
          );
        }

        final postings = snapshot.data!.docs
            .map((doc) => Posting.fromSnapshot(doc))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: postings.length,
          itemBuilder: (ctx, i) => PostingCard(posting: postings[i]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter tab bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1A4A2E),
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: const Color(0xFF1A4A2E),
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Need Workers'),
              Tab(text: 'Available'),
            ],
            onTap: (i) => setState(() {}),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(_db.getAllPostings()),
              _buildList(_db.getPostingsByType('company')),
              _buildList(_db.getPostingsByType('labour')),
            ],
          ),
        ),
      ],
    );
  }
}
