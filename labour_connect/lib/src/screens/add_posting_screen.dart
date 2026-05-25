import 'package:flutter/material.dart';
import '../../models/posting.dart';
import '../../services/database.dart';
import '../../helper/helperfunctions.dart';

/// Screen for creating a new posting.
/// The user first selects whether they are a company or a labourer,
/// then fills in the relevant details.
class AddPostingScreen extends StatefulWidget {
  const AddPostingScreen({Key? key}) : super(key: key);

  @override
  State<AddPostingScreen> createState() => _AddPostingScreenState();
}

class _AddPostingScreenState extends State<AddPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseMethods();

  PostingType _selectedType = PostingType.company;
  bool _isUrgent = false;
  bool _isLoading = false;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _workCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _wageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _workCtrl, _locationCtrl, _durationCtrl,
      _wageCtrl, _phoneCtrl, _emailCtrl, _notesCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final uid = await HelperFunctions.getUserID();

    final postingData = Posting(
      uid: uid,
      type: _selectedType,
      posterName: _nameCtrl.text.trim(),
      workType: _workCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      duration: _durationCtrl.text.trim(),
      wage: _wageCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
      urgent: _isUrgent,
      createdAt: DateTime.now(),
    ).toJson();

    await _db.addPosting(postingData);

    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Posted successfully! 🎉'),
        backgroundColor: Color(0xFF1A4A2E),
      ),
    );
    Navigator.of(context).pop();
  }

  // ── UI helpers ─────────────────────────────────────────────────────────────

  Widget _typeToggle() {
    return Row(
      children: PostingType.values.map((t) {
        final selected = _selectedType == t;
        final isCompany = t == PostingType.company;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: isCompany ? 6 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1A4A2E)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1A4A2E)
                      : Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isCompany ? Icons.business : Icons.construction,
                    color: selected ? Colors.white : Colors.grey.shade500,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompany ? '🏢 Company' : '👷 Labour',
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    isCompany ? 'Need workers' : 'I\'m available',
                    style: TextStyle(
                      color: selected
                          ? Colors.white70
                          : Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color(0xFF1A4A2E), width: 1.5),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333)),
        ),
      );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isCompany = _selectedType == PostingType.company;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A4A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Create Posting',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Type selector ────────────────────────────────────
                    _label('I am posting as:'),
                    _typeToggle(),

                    // ── Name ─────────────────────────────────────────────
                    _label(isCompany ? 'Company / Contractor name' : 'Your name'),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: _inputDecoration(
                        isCompany
                            ? 'e.g. Sharma Constructions'
                            : 'e.g. Ramesh Patil',
                        Icons.person_outline,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter a name'
                              : null,
                    ),

                    // ── Work type ─────────────────────────────────────────
                    _label('Work type / skill'),
                    TextFormField(
                      controller: _workCtrl,
                      decoration: _inputDecoration(
                        'e.g. Mason, Plumber, Electrician, Carpenter...',
                        Icons.build_outlined,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter work type'
                              : null,
                    ),

                    // ── Location ──────────────────────────────────────────
                    _label('Location'),
                    TextFormField(
                      controller: _locationCtrl,
                      decoration: _inputDecoration(
                        'e.g. Khopoli, Pune, Mumbai...',
                        Icons.location_on_outlined,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter location'
                              : null,
                    ),

                    // ── Duration ──────────────────────────────────────────
                    _label(isCompany ? 'Duration needed' : 'Availability period'),
                    TextFormField(
                      controller: _durationCtrl,
                      decoration: _inputDecoration(
                        isCompany
                            ? 'e.g. 3 days, 2 weeks, 1 month'
                            : 'e.g. Available from Monday, 2 weeks',
                        Icons.schedule_outlined,
                      ),
                    ),

                    // ── Wage ──────────────────────────────────────────────
                    _label(isCompany ? 'Wage offered (₹/day)' : 'Expected wage (₹/day)'),
                    TextFormField(
                      controller: _wageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        'e.g. 700 or Negotiable',
                        Icons.currency_rupee,
                      ),
                    ),

                    // ── Phone ─────────────────────────────────────────────
                    _label('Contact number *'),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        '+91 98765 43210',
                        Icons.phone_outlined,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Phone number is required'
                              : null,
                    ),

                    // ── Email ─────────────────────────────────────────────
                    _label('Email (optional)'),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        'example@gmail.com',
                        Icons.email_outlined,
                      ),
                    ),

                    // ── Notes ─────────────────────────────────────────────
                    _label('Additional details'),
                    TextFormField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        isCompany
                            ? 'Number of workers needed, tools provided, site address, food/accommodation...'
                            : 'Years of experience, tools available, willing to travel how far, languages...',
                        Icons.notes_outlined,
                      ),
                    ),

                    // ── Urgent toggle ─────────────────────────────────────
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: _isUrgent
                            ? const Color(0xFFFFEBEE)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isUrgent
                              ? const Color(0xFFEF9A9A)
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: SwitchListTile(
                        value: _isUrgent,
                        onChanged: (v) => setState(() => _isUrgent = v),
                        activeColor: const Color(0xFFC62828),
                        title: const Text(
                          '⚡ Mark as Urgent',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: Text(
                          'Urgent posts appear highlighted in the feed',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ),
                    ),

                    // ── Submit ────────────────────────────────────────────
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Post to Feed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A4A2E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
