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

/// Sign-in.
///
/// Navigation on success is *not* handled here: [authStateProvider] updates
/// as soon as Supabase confirms the session, and the profile tab reacts to
/// it on its own — this screen only needs to pop.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final result = await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _email.text.trim(), password: _password.text);

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

    return AuthShell(
      title: 'Bon retour',
      lead: 'Connectez-vous pour retrouver votre liste sur tous vos appareils.',
      onBack: () => context.pop(),
      footer: AuthFooterLink(
        prompt: 'Pas encore de compte ?',
        action: "S'inscrire",
        onTap: () => context.push(AppRoutes.signUp),
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
                    icon: Icons.mail_outline_rounded,
                    controller: _email,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                  ),
                  PasswordFieldRow(
                    controller: _password,
                    hint: 'Mot de passe',
                    autofillHints: const [AutofillHints.password],
                    validator: Validators.password,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.showToast(
                    'Bientôt disponible',
                    icon: Icons.info_outline_rounded,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Text(
                      'Mot de passe oublié ?',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.tokens.brand,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: 'Se connecter',
                loadingLabel: 'Connexion…',
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
