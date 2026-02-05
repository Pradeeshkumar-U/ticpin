import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class ArtistsPromotionPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ArtistsPromotionPage({required this.formKey, super.key});

  @override
  ArtistsPromotionPageState createState() => ArtistsPromotionPageState();
}

class ArtistsPromotionPageState extends State<ArtistsPromotionPage> {
  final _artistCtl = TextEditingController();
  final _hashtagCtl = TextEditingController();

  final _artistFocus = FocusNode();
  final _hashtagFocus = FocusNode();

  bool _isAddingArtist = false;
  bool _isAddingHashtag = false;

  bool _showArtistError = false;
  bool _showHashtagError = false;

  bool _initialized = false; // ✅ flag to prevent duplicate setup

  @override
  void initState() {
    super.initState();
    _artistCtl.addListener(_onArtistChange);
    _hashtagCtl.addListener(_onHashtagChange);

    _artistFocus.addListener(() {
      if (!_artistFocus.hasFocus && _artistCtl.text.trim().isNotEmpty) {
        _addArtist(context);
      }
    });
    _hashtagFocus.addListener(() {
      if (!_hashtagFocus.hasFocus && _hashtagCtl.text.trim().isNotEmpty) {
        _addHashtag(context);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final prov = context.read<EventFormProvider>();

      // ✅ Pre-fill from provider (only once)
      if (prov.artistLineup.isNotEmpty || prov.hashtags.isNotEmpty) {
        setState(() {});
      }

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _artistCtl.dispose();
    _hashtagCtl.dispose();
    _artistFocus.dispose();
    _hashtagFocus.dispose();
    super.dispose();
  }

  void _onArtistChange() {
    if (_artistCtl.text.trim().isNotEmpty) {
      setState(() => _showArtistError = false);
    }
  }

  void _onHashtagChange() {
    if (_hashtagCtl.text.trim().isNotEmpty) {
      setState(() => _showHashtagError = false);
    }
  }

  /// ✅ Called from AddEventPage via GlobalKey
  bool validateAndSave(BuildContext context) {
    final prov = context.read<EventFormProvider>();

    if (_artistCtl.text.trim().isNotEmpty) _addArtist(context);
    if (_hashtagCtl.text.trim().isNotEmpty) _addHashtag(context);

    setState(() {
      _showArtistError =
          prov.artistLineup.isEmpty && _artistCtl.text.trim().isEmpty;
      _showHashtagError =
          prov.hashtags.isEmpty && _hashtagCtl.text.trim().isEmpty;
    });

    return !(_showArtistError || _showHashtagError);
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('ARTISTS'),
            const SizedBox(height: 12),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child:
                  _isAddingArtist
                      ? Row(
                        key: const ValueKey('artistField'),
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _artistCtl,
                              focusNode: _artistFocus,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Enter artist name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _addArtist(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _addArtist(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E1E82),
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                        ],
                      )
                      : SizedBox(
                        key: const ValueKey('artistButton'),
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed:
                              () => setState(() => _isAddingArtist = true),
                          icon: const Icon(Icons.add, color: Color(0xFF1E1E82)),
                          label: const Text(
                            'Add Artist',
                            style: TextStyle(
                              color: Color(0xFF1E1E82),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1E1E82)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  prov.artistLineup
                      .map(
                        (a) => Chip(
                          label: Text(a),
                          onDeleted: () {
                            prov.removeArtist(a);
                            setState(() {});
                          },
                        ),
                      )
                      .toList(),
            ),
            if (_showArtistError &&
                prov.artistLineup.isEmpty &&
                _artistCtl.text.trim().isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Please add or enter at least one artist',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            const SizedBox(height: 24),
            _buildLabel('HASHTAGS'),
            const SizedBox(height: 12),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child:
                  _isAddingHashtag
                      ? Row(
                        key: const ValueKey('hashtagField'),
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _hashtagCtl,
                              focusNode: _hashtagFocus,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: '#hashtag',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _addHashtag(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _addHashtag(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E1E82),
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                        ],
                      )
                      : SizedBox(
                        key: const ValueKey('hashtagButton'),
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed:
                              () => setState(() => _isAddingHashtag = true),
                          icon: const Icon(Icons.add, color: Color(0xFF1E1E82)),
                          label: const Text(
                            'Add Hashtag',
                            style: TextStyle(
                              color: Color(0xFF1E1E82),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1E1E82)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  prov.hashtags
                      .map(
                        (h) => Chip(
                          label: Text(h),
                          onDeleted: () {
                            prov.removeHashtag(h);
                            setState(() {});
                          },
                        ),
                      )
                      .toList(),
            ),
            if (_showHashtagError &&
                prov.hashtags.isEmpty &&
                _hashtagCtl.text.trim().isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Please add or enter at least one hashtag',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            const SizedBox(height: 24),
            _buildLabel('SOCIAL LINKS'),
            const SizedBox(height: 12),
            _buildTextField(
              'Instagram',
              (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              (v) => prov.socialLinks['instagram'] = v,
              initialValue: prov.socialLinks['instagram'],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Facebook',
              (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              (v) => prov.socialLinks['facebook'] = v,
              initialValue: prov.socialLinks['facebook'],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'X',
              (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              (v) => prov.socialLinks['twitter'] = v,
              initialValue: prov.socialLinks['twitter'],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────

  void _addArtist(BuildContext context) {
    final prov = context.read<EventFormProvider>();
    final artist = _artistCtl.text.trim();
    if (artist.isNotEmpty && !prov.artistLineup.contains(artist)) {
      final capitalized = artist
          .split(' ')
          .where((w) => w.isNotEmpty)
          .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
          .join(' ');
      prov.addArtist(capitalized);
    }
    _artistCtl.clear();
    setState(() {
      _isAddingArtist = false;
      _showArtistError = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _addHashtag(BuildContext context) {
    final prov = context.read<EventFormProvider>();
    final hashtag = _hashtagCtl.text.trim();
    if (hashtag.isNotEmpty && !prov.hashtags.contains(hashtag)) {
      prov.addHashtag(hashtag.startsWith('#') ? hashtag : '#$hashtag');
    }
    _hashtagCtl.clear();
    setState(() {
      _isAddingHashtag = false;
      _showHashtagError = false;
    });
    FocusScope.of(context).unfocus();
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E82),
      letterSpacing: 1.2,
    ),
  );

  Widget _buildTextField(
    String label,
    String? Function(String?)? validator,
    Function(String) onChanged, {
    String? initialValue,
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      key: ValueKey(label), // ✅ to prevent state confusion on rebuilds
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
