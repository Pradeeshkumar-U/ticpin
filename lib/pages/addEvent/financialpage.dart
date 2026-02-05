import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_partner/constants/size.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class FinancialPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const FinancialPage({required this.formKey, super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes().width * 0.05,
        vertical: 20,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('FINANCIAL DETAILS'),
            const SizedBox(height: 20),

            // BANK ACCOUNT NUMBER
            _buildTextField(
              'Bank Account Number',
              (v) => prov.updateField('bankAccount', v),
              initialValue: prov.bankAccount,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // IFSC CODE
            _buildTextField(
              'IFSC Code',
              (v) => prov.updateField('ifsc', v),
              initialValue: prov.ifsc,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // PAN OR GST NUMBER
            _buildTextField(
              'PAN / GST Number',
              (v) => prov.updateField('panOrGst', v),
              initialValue: prov.panOrGst,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 24),

            // ACCOUNT HOLDER NAME
            _buildTextField(
              'Account Holder Name',
              (v) => prov.updateField('accountHolder', v),
              initialValue: prov.accountHolder,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 24),

            // BANK NAME
            _buildTextField(
              'Bank Name',
              (v) => prov.updateField('bankName', v),
              initialValue: prov.bankName,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
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
    Function(String) onChanged, {
    String? initialValue,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
