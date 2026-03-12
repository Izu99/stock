import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/models/company.dart';
import '../providers/admin_provider.dart';
import '../../data/repositories/company_repository.dart';

class AddCompanyScreen extends ConsumerStatefulWidget {
  final Company? company;
  const AddCompanyScreen({super.key, this.company});

  @override
  ConsumerState<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends ConsumerState<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _ownerNameCtrl;
  late final TextEditingController _ownerPhoneCtrl;
  late final TextEditingController _ownerEmailCtrl;
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isProcessing = false;

  // Availability states
  String? _phoneError;
  String? _emailError;
  String? _usernameError;
  bool _isCheckingPhone = false;
  bool _isCheckingEmail = false;
  bool _isCheckingUsername = false;

  bool get _isEditing => widget.company != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.company?.name);
    _usernameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController(text: widget.company?.phone);
    _addressCtrl = TextEditingController(text: widget.company?.address);
    _ownerNameCtrl = TextEditingController(text: widget.company?.owner.name);
    _ownerPhoneCtrl = TextEditingController(text: widget.company?.owner.phone);
    _ownerEmailCtrl = TextEditingController(text: widget.company?.owner.email);

    if (!_isEditing) {
      _phoneCtrl.addListener(_onPhoneChanged);
      _ownerEmailCtrl.addListener(_onEmailChanged);
      _usernameCtrl.addListener(_onUsernameChanged);
    }
  }

  Timer? _phoneTimer;
  Timer? _emailTimer;
  Timer? _usernameTimer;

  void _onPhoneChanged() {
    if (_phoneCtrl.text.length < 9) return;
    _phoneTimer?.cancel();
    _phoneTimer = Timer(
      const Duration(milliseconds: 800),
      () => _checkAvailability('companyPhone', _phoneCtrl.text),
    );
  }

  void _onEmailChanged() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_ownerEmailCtrl.text)) return;
    _emailTimer?.cancel();
    _emailTimer = Timer(
      const Duration(milliseconds: 800),
      () => _checkAvailability('ownerEmail', _ownerEmailCtrl.text),
    );
  }

  void _onUsernameChanged() {
    if (_usernameCtrl.text.length < 3) return;
    _usernameTimer?.cancel();
    _usernameTimer = Timer(
      const Duration(milliseconds: 800),
      () => _checkAvailability('username', _usernameCtrl.text),
    );
  }

  Future<void> _checkAvailability(String type, String value) async {
    if (_isEditing) return;

    setState(() {
      if (type == 'companyPhone') _isCheckingPhone = true;
      if (type == 'ownerEmail') _isCheckingEmail = true;
      if (type == 'username') _isCheckingUsername = true;
    });

    try {
      final isAvailable = await ref
          .read(companyRepositoryProvider)
          .checkAvailability(type, value);

      if (mounted) {
        setState(() {
          if (type == 'companyPhone') {
            _phoneError = isAvailable
                ? null
                : 'This phone number is already registered';
            _isCheckingPhone = false;
          }
          if (type == 'ownerEmail') {
            _emailError = isAvailable ? null : 'This email is already in use';
            _isCheckingEmail = false;
          }
          if (type == 'username') {
            _usernameError = isAvailable
                ? null
                : 'This username is already taken';
            _isCheckingUsername = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (type == 'companyPhone') _isCheckingPhone = false;
          if (type == 'ownerEmail') _isCheckingEmail = false;
          if (type == 'username') _isCheckingUsername = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _phoneTimer?.cancel();
    _emailTimer?.cancel();
    _usernameTimer?.cancel();
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
        final data = {
          'name': _nameCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
          'owner': {
            'name': _ownerNameCtrl.text.trim(),
            'phone': _ownerPhoneCtrl.text.trim(),
            'email': _ownerEmailCtrl.text.trim(),
          },
        };

        debugPrint('--- Submitting Company Data ---');
        debugPrint('Data: $data');

        if (_isEditing) {
          debugPrint('Mode: EDIT, ID: ${widget.company!.id}');
          await ref
              .read(companiesProvider.notifier)
              .updateCompany(widget.company!.id, data);
        } else {
          debugPrint('Mode: ADD');
          data['username'] = _usernameCtrl.text.trim();
          data['password'] = _passwordCtrl.text.trim();
          await ref.read(companiesProvider.notifier).add(data);
        }

        debugPrint('Submission Successful');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'Company updated successfully'
                    : 'Company registered successfully',
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } catch (e) {
        debugPrint('--- Submission Failed ---');
        debugPrint('Error: $e');

        if (mounted) {
          String errorMessage = 'An error occurred';

          if (e is DioException) {
            debugPrint('Dio Error Details: ${e.response?.data}');
            errorMessage =
                e.response?.data?['message'] ?? e.message ?? 'Server error';
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
        title: Text(_isEditing ? 'Edit Company' : l10n.addCompany),
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
                if (!_isEditing) ...[
                  AppTextField(
                    controller: _usernameCtrl,
                    label: l10n.username,
                    prefixIcon: Icons.account_circle_outlined,
                    suffix: _isCheckingUsername
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return l10n.errorRequired;
                      if (v.contains(' ')) return l10n.usernameError;
                      return _usernameError;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                AppTextField(
                  controller: _nameCtrl,
                  label: l10n.labelCompanyName,
                  prefixIcon: Icons.business,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return l10n.errorRequired;
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
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? l10n.errorRequired : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneCtrl,
                  label: l10n.labelPhone,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  suffix: _isCheckingPhone
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return l10n.errorRequired;
                    if (v.trim().length < 9) return 'Invalid phone';
                    return _phoneError;
                  },
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.ownerInfo),
                AppTextField(
                  controller: _ownerNameCtrl,
                  label: l10n.ownerName,
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? l10n.errorRequired : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _ownerPhoneCtrl,
                  label: l10n.mobileNumber,
                  prefixIcon: Icons.smartphone,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return l10n.errorRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _ownerEmailCtrl,
                  label: l10n.labelEmail,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  suffix: _isCheckingEmail
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return l10n.errorRequired;
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(v)) return l10n.invalidEmail;
                    return _emailError;
                  },
                ),
                const SizedBox(height: 32),

                if (!_isEditing) ...[
                  SectionHeader(title: l10n.securityCreds),
                  AppTextField(
                    controller: _passwordCtrl,
                    label: l10n.password,
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textHint,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) => v == null || v.length < 6
                        ? l10n.minPasswordLength
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirmPasswordCtrl,
                    label: l10n.confirmPassword,
                    prefixIcon: Icons.lock_reset,
                    obscureText: _obscureConfirmPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textHint,
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    validator: (v) {
                      if (v?.isEmpty ?? true) return l10n.errorRequired;
                      if (v != _passwordCtrl.text)
                        return l10n.passwordsDoNotMatch;
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                ],

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
                            _isEditing
                                ? 'Update Company'
                                : l10n.registerCompany,
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
