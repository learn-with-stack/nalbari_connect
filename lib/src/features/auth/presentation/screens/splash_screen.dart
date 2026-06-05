import 'package:nalbari_connect/src/features/auth/presentation/providers/app_auth_provider.dart';
import 'package:nalbari_connect/src/imports/imports.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(appAuthProvider.notifier).restoreSession();
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.logo, width: 76.w, height: 76.w),
            SizedBox(height: 18.h),
            Text(
              'app.name'.tr(),
              style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: 26.w,
              height: 26.w,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}
