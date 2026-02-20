import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hardware_stock_sales/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/admin_provider.dart';

class AddCompanyScreen extends ConsumerStatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  ConsumerState<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends ConsumerState<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _ownerNameCtrl = TextEditingController();
  final _ownerPhoneCtrl = TextEditingController();
  final _ownerEmailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _ownerNameCtrl.dispose();
    _ownerPhoneCtrl.dispose();
    _ownerEmailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);
      try {
        await ref.read(companiesProvider.notifier).add({
          'name': _nameCtrl.text.trim(),
          'username': _usernameCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
          'owner': {
            'name': _ownerNameCtrl.text.trim(),
            'phone': _ownerPhoneCtrl.text.trim(),
            'email': _ownerEmailCtrl.text.trim(),
          },
          'password': _passwordCtrl.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Company registered successfully'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          // Extract specific error message from backend if possible
          String errorMessage = 'An error occurred';
          
          if (e.toString().contains('DioException')) {
             // Try to parse the response data if accessible (this depends on how the exception is exposed)
             // For now, we provide a more user-friendly generic message if we can't parse it deeply here,
             // but ideally we'd access e.response.data['message'] if available.
             // Since we only have 'e', we'll try to keep it clean.
             if (e.toString().contains('400')) {
                errorMessage = 'Invalid data provided. Please check all fields.';
             } else if (e.toString().contains('409')) {
                errorMessage = 'Company or email already exists.';
             } else {
                errorMessage = 'Server error. Please try again later.';
             }
             
             // If we can interpret the raw error string to find a backend message:
             final rawError = e.toString();
             if (rawError.contains('message:')) {
               final msgStart = rawError.indexOf('message:') + 8;
               int msgEnd = rawError.indexOf(',', msgStart);
               if (msgEnd == -1) {
                 msgEnd = rawError.indexOf('}', msgStart);
               }
               if (msgEnd != -1) {
                  errorMessage = rawError.substring(msgStart, msgEnd).trim();
               }
             }
          } else {
             errorMessage = e.toString().replaceAll('Exception:', '').trim();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                   const Icon(Icons.error_outline, color: Colors.white),
                   const SizedBox(width: 12),
                   Expanded(child: Text(errorMessage)),
                ],
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.addCompany),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: l10n.companyDetails),
                AppTextField(
                  controller: _usernameCtrl,
                  label: l10n.username,
                  prefixIcon: Icons.account_circle_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.errorRequired;
                    if (v.contains(' ')) return l10n.usernameError;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameCtrl,
                  label: l10n.labelCompanyName,
                  prefixIcon: Icons.business,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.errorRequired;
                    if (v.trim().length < 2) return 'Name too short';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _addressCtrl,
                  label: l10n.address,
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (v) => v?.trim().isEmpty ?? true ? l10n.errorRequired : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneCtrl,
                  label: l10n.labelPhone,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.errorRequired;
                    if (v.trim().length < 9) return 'Invalid phone'; 
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.ownerInfo),
                AppTextField(
                  controller: _ownerNameCtrl,
                  label: l10n.ownerName,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => v?.trim().isEmpty ?? true ? l10n.errorRequired : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _ownerPhoneCtrl,
                  label: l10n.mobileNumber,
                  prefixIcon: Icons.smartphone,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                     if (v == null || v.trim().isEmpty) return l10n.errorRequired;
                     return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _ownerEmailCtrl,
                  label: l10n.labelEmail,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.errorRequired;
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return l10n.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.securityCreds),
                AppTextField(
                  controller: _passwordCtrl,
                  label: l10n.password,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textHint,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? l10n.minPasswordLength : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordCtrl,
                  label: l10n.confirmPassword,
                  prefixIcon: Icons.lock_reset,
                  obscureText: _obscureConfirmPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textHint,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (v) {
                    if (v?.isEmpty ?? true) return l10n.errorRequired;
                    if (v != _passwordCtrl.text) return l10n.passwordsDoNotMatch;
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            l10n.registerCompany,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
