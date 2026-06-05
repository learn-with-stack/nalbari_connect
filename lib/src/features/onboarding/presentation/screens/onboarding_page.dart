import 'package:nalbari_connect/src/imports/imports.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(child: SvgPicture.asset(AppAssets.logo, width: 92.w, height: 92.w)),
              SizedBox(height: 28.h),
              Text(
                'onboarding.title'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12.h),
              Text(
                'onboarding.subtitle'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant, height: 1.45),
              ),
              SizedBox(height: 28.h),
              _LanguageSelector(),
              SizedBox(height: 16.h),
              _PermissionNote(),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text('onboarding.start'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('onboarding.language'.tr(), style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _LanguageChip(label: 'English', locale: const Locale('en')),
            _LanguageChip(label: 'অসমীয়া', locale: const Locale('as')),
            _LanguageChip(label: 'हिन्दी', locale: const Locale('hi')),
          ],
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.label, required this.locale});

  final String label;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final selected = context.locale.languageCode == locale.languageCode;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => context.setLocale(locale),
    );
  }
}

class _PermissionNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: AppBorders.card,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, color: cs.primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('onboarding.location_title'.tr(), style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),
                  Text('onboarding.location_subtitle'.tr(), style: context.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
