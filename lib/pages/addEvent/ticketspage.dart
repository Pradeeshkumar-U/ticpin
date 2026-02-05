import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_partner/constants/colors.dart';
import 'package:ticpin_partner/constants/size.dart';
import 'package:ticpin_partner/constants/ticketcategory.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class TicketsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const TicketsPage({required this.formKey, super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  String? ticketError;

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('TICKET CATEGORIES'),
            const SizedBox(height: 16),

            // ─── Tickets List ───────────────────────────────
            Expanded(
              child:
                  prov.tickets.isEmpty
                      ? Center(
                        child: Text(
                          'No tickets added yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                      : ListView.builder(
                        itemCount: prov.tickets.length,
                        itemBuilder: (ctx, i) {
                          final t = prov.tickets[i];
                          return Card(
                            color: Color(0xFF1E1E82),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8 - 1.5),
                            ),

                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: ListTile(
                                tileColor: whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8 + 1.5),
                                ),

                                // leading: Text(''),
                                contentPadding: EdgeInsets.only(
                                  right: Sizes().width * 0.01,
                                  left: Sizes().width * 0.04,
                                  top: Sizes().width * 0.01,
                                  bottom: Sizes().width * 0.01,
                                ),
                                // minLeadingWidth: Sizes().width * 0,
                                title: Text(
                                  '${t.type} - ₹${t.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Qty: ${t.quantity} | ${t.seatingType}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      prov.removeTicket(t);
                                      _validateTickets(prov);
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),

            if (ticketError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  ticketError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            const SizedBox(height: 12),

            // ─── Add Ticket Button ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final ticket = await showDialog<TicketCategory>(
                    context: context,
                    builder: (_) => const AddTicketDialog(),
                  );
                  if (ticket != null) {
                    setState(() {
                      prov.addTicket(ticket);
                      _validateTickets(prov);
                    });
                  }
                },
                icon: const Icon(Icons.add, color: whiteColor),
                label: const Text(
                  'Add Ticket Category',
                  style: TextStyle(color: whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E82),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateTickets(EventFormProvider prov) {
    if (prov.tickets.isEmpty) {
      setState(() => ticketError = 'At least one ticket category is required.');
    } else {
      setState(() => ticketError = null);
    }
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
}

class AddTicketDialog extends StatefulWidget {
  const AddTicketDialog({super.key});

  @override
  State<AddTicketDialog> createState() => _AddTicketDialogState();
}

class _AddTicketDialogState extends State<AddTicketDialog> {
  final _formKey = GlobalKey<FormState>();

  final _typeCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _qtyCtl = TextEditingController();
  final _inclusionCtl = TextEditingController();

  String seating = 'standing';
  DateTime? cutoff;
  final List<String> inclusions = [];
  bool _isAddingInclusion = false;

  bool _submitted = false; // ✅ Track whether Add button was pressed

  @override
  void dispose() {
    _typeCtl.dispose();
    _priceCtl.dispose();
    _qtyCtl.dispose();
    _inclusionCtl.dispose();
    super.dispose();
  }

  void _addInclusion() {
    final inclusion = _inclusionCtl.text.trim();
    if (inclusion.isNotEmpty) {
      setState(() {
        inclusions.add(inclusion);
        _inclusionCtl.clear();
        _isAddingInclusion = false;
      });
      FocusScope.of(context).unfocus();
    } else {
      setState(() => _isAddingInclusion = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Add Ticket Category',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Type ──────────────────────────────────────────────
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _typeCtl,
                decoration: InputDecoration(
                  labelText: 'Type (e.g., General, VIP)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // ─── Price ─────────────────────────────────────────────
              TextFormField(
                controller: _priceCtl,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final price = double.tryParse(v);
                  if (price == null || price <= 0) return 'Enter valid price';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ─── Quantity ──────────────────────────────────────────
              TextFormField(
                controller: _qtyCtl,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final qty = int.tryParse(v);
                  if (qty == null || qty <= 0) return 'Enter valid quantity';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ─── Seating Type ──────────────────────────────────────
              DropdownButtonFormField<String>(
                value: seating,
                decoration: InputDecoration(
                  labelText: 'Seating Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
                items: const [
                  DropdownMenuItem(value: 'standing', child: Text('Standing')),
                  DropdownMenuItem(value: 'sitting', child: Text('Sitting')),
                  DropdownMenuItem(value: 'map', child: Text('Map')),
                ],
                onChanged: (v) => setState(() => seating = v ?? 'standing'),
              ),
              const SizedBox(height: 12),

              // ─── Cutoff ────────────────────────────────────────────
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  cutoff == null
                      ? 'Gate opening\nDate & Time'
                      : 'Gate open: ${DateFormat('MMM dd, HH:mm').format(cutoff!)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) {
                        setState(() {
                          cutoff = DateTime(
                            d.year,
                            d.month,
                            d.day,
                            t.hour,
                            t.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ),
              if (_submitted && cutoff == null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Cutoff date/time required',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // ─── Add Inclusion Button/TextField ────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child:
                    _isAddingInclusion
                        ? Row(
                          key: const ValueKey('textfield'),
                          children: [
                            Expanded(
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _inclusionCtl,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: 'Enter inclusion',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: (_) => _addInclusion(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _addInclusion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1E82),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                        : SizedBox(
                          key: const ValueKey('button'),
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed:
                                () => setState(() => _isAddingInclusion = true),
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF1E1E82),
                            ),
                            label: const Text(
                              'Add Inclusion',
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

              // ─── Inclusion Chips ───────────────────────────────────
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    inclusions
                        .map(
                          (i) => Chip(
                            label: Text(i),
                            onDeleted:
                                () => setState(() => inclusions.remove(i)),
                          ),
                        )
                        .toList(),
              ),
              if (_submitted && inclusions.isEmpty)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'At least one inclusion required',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // ─── Actions ─────────────────────────────────────────────────
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF1E1E82)),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E82),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            setState(() => _submitted = true); // ✅ show red errors only now

            if (!_formKey.currentState!.validate()) return;
            if (cutoff == null || inclusions.isEmpty) return;

            final ticket = TicketCategory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: _typeCtl.text.trim(),
              price: double.tryParse(_priceCtl.text.trim()) ?? 0,
              quantity: int.tryParse(_qtyCtl.text.trim()) ?? 0,
              seatingType: seating,
              bookingCutoff: cutoff!,
              inclusions: List.from(inclusions),
            );

            Navigator.pop(context, ticket);
          },
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
