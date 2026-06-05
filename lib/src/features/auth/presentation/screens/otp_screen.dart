import 'package:nalbari_connect/src/features/auth/presentation/providers/app_auth_provider.dart';
import 'package:nalbari_connect/src/imports/imports.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(appAuthProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              Text('auth.otp_title'.tr(), style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              SizedBox(height: 8.h),
              Text('auth.otp_subtitle'.tr(), style: context.textTheme.bodyMedium?.copyWith(color: context.theme.colorScheme.onSurfaceVariant)),
              SizedBox(height: 28.h),
              AppTextField(
                controller: _otpController,
                label: 'auth.otp'.tr(),
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.password_outlined),
              ),
              SizedBox(height: 18.h),
              FilledButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        final ok = await ref.read(appAuthProvider.notifier).verifyOtp(_otpController.text.trim());
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
                        }
                      },
                child: auth.isLoading
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('auth.verify'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
