import 'package:nalbari_connect/src/features/auth/presentation/providers/app_auth_provider.dart';
import 'package:nalbari_connect/src/imports/imports.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '9876543210');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(appAuthProvider);
    final cs = context.theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: SvgPicture.asset(AppAssets.logo, width: 78.w, height: 78.w)),
                  SizedBox(height: 28.h),
                  Text('auth.welcome'.tr(), textAlign: TextAlign.center, style: context.textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: 6.h),
                  Text('app.name'.tr(), textAlign: TextAlign.center, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                  SizedBox(height: 12.h),
                  Text('auth.phone_title'.tr(), textAlign: TextAlign.center, style: context.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: 34.h),
                  AppTextField(
                    controller: _phoneController,
                    label: 'auth.phone_number'.tr(),
                    hint: 'auth.phone_hint'.tr(),
                    keyboardType: TextInputType.phone,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 10.w, top: 14.h),
                      child: Text('+91', style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    validator: (value) {
                      final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                      if (digits.length != 10) return 'Enter a valid 10-digit phone number';
                      return null;
                    },
                  ),
                  SizedBox(height: 18.h),
                  FilledButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!(_formKey.currentState?.validate() ?? false)) return;
                            final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
                            await ref.read(appAuthProvider.notifier).requestOtp(phone);
                            if (context.mounted) context.go(AppRoutes.verifyOtp);
                          },
                    child: auth.isLoading
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('auth.continue'.tr()),
                  ),
                  SizedBox(height: 12.h),
                  Text('auth.secured'.tr(), textAlign: TextAlign.center, style: context.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: 8.h),
                  Text('auth.demo_hint'.tr(), textAlign: TextAlign.center, style: context.textTheme.bodySmall?.copyWith(color: cs.primary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
