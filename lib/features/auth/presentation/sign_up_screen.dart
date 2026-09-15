import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guesgo/app/router/app_routes.dart';
import 'package:guesgo/app/theme/theme.dart';
import 'package:guesgo/core/extensions/context_x.dart';
import 'package:guesgo/core/result/result.dart';
import 'package:guesgo/core/utils/validators.dart';
import 'package:guesgo/core/widgets/design_system.dart';
import 'package:guesgo/features/auth/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _terms = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_terms) {
      context.showToast(
        "Vous devez accepter les conditions d'utilisation.",
        tone: AppTone.warning,
        icon: Icons.info_outline_rounded,
      );
      return;
    }
    FocusScope.of(context).unfocus();

    final name = '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();
    final result = await ref
        .read(authControllerProvider.notifier)
        .signUp(
          email: _email.text.trim(),
          password: _password.text,
          name: name.isEmpty ? null : name,
        );

    if (!mounted) return;
    switch (result) {
      case Ok():
        context.pop();
      case Err(:final failure):
        context.showFailure(failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final t = context.tokens;
    final text = context.textTheme;

    return AuthShell(
      title: 'Créer un compte',
      lead: 'Retrouvez votre liste sur tous vos appareils, même hors-ligne.',
      onBack: () => context.pop(),
      footer: AuthFooterLink(
        prompt: 'Déjà un compte ?',
        action: 'Se connecter',
        onTap: () => context.push(AppRoutes.signIn),
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FieldGroup(
                children: [
                  FieldRow(
                    icon: Icons.badge_outlined,
                    controller: _lastName,
                    label: 'Nom',
                    hint: 'Entrez votre nom',
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.familyName],
                  ),
                  FieldRow(
                    icon: Icons.person_outline_rounded,
                    controller: _firstName,
                    label: 'Prénom',
                    hint: 'Entrez votre prénom',
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.givenName],
                  ),
                  FieldRow(
                    icon: Icons.mail_outline_rounded,
                    controller: _email,
                    label: 'Email',
                    hint: 'Entrez votre adresse email',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                  ),
                  PasswordFieldRow(
                    controller: _password,
                    label: 'Mot de passe',
                    hint: 'Au moins 6 caractères',
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: Validators.password,
                    onChanged: (_) => setState(() {}),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              PasswordStrengthMeter(password: _password.text),
              const SizedBox(height: AppSpacing.xl),
              AppCheckbox(
                value: _terms,
                onChanged: (v) => setState(() => _terms = v),
                label: Text(
                  "J'accepte les conditions d'utilisation.",
                  style: text.bodySmall?.copyWith(
                    color: t.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton.primary(
                label: 'Créer mon compte',
                loadingLabel: 'Création…',
                isLoading: isLoading,
                elevated: false,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
