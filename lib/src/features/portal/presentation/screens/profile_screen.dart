import 'package:nalbari_connect/src/features/auth/presentation/providers/app_auth_provider.dart';
import 'package:nalbari_connect/src/features/portal/data/models/portal_models.dart';
import 'package:nalbari_connect/src/features/portal/presentation/providers/portal_provider.dart';
import 'package:nalbari_connect/src/imports/imports.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(appAuthProvider);
    final portal = ref.watch(portalControllerProvider);
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: Text('profile.title'.tr())),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Center(child: SvgPicture.asset(AppAssets.logo, width: 72.w, height: 72.w)),
          SizedBox(height: 12.h),
          Text(user?.name ?? 'User', textAlign: TextAlign.center, style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          Text('+91 ${user?.phone ?? ''}', textAlign: TextAlign.center, style: context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
          SizedBox(height: 22.h),
          _ProfileLink(icon: Icons.settings_outlined, label: 'profile.settings'.tr(), route: AppRoutes.settings),
          _ProfileLink(icon: Icons.info_outline, label: 'profile.about'.tr(), route: AppRoutes.about),
          _ProfileLink(icon: Icons.help_outline, label: 'profile.faq'.tr(), route: AppRoutes.faq),
          _ProfileLink(icon: Icons.privacy_tip_outlined, label: 'profile.privacy'.tr(), route: AppRoutes.privacy),
          SizedBox(height: 18.h),
          Text('profile.appointments'.tr(), style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          SizedBox(height: 8.h),
          for (final appointment in portal.appointments.take(4))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(appointment.reason),
              subtitle: Text('${appointment.time} - ${appointment.status.name}'),
              leading: const Icon(Icons.calendar_month_outlined),
            ),
          SizedBox(height: 12.h),
          Text('profile.complaints'.tr(), style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          SizedBox(height: 8.h),
          for (final complaint in portal.complaints.take(4))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${complaint.areaType == AreaType.ward ? 'Ward' : 'Panchayat'} ${complaint.areaNumber}'),
              subtitle: Text(complaint.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              leading: const Icon(Icons.report_problem_outlined),
            ),
        ],
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surface,
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(route),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Text('settings.language'.tr(), style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: [
              ChoiceChip(label: const Text('English'), selected: context.locale.languageCode == 'en', onSelected: (_) => context.setLocale(const Locale('en'))),
              ChoiceChip(label: const Text('অসমীয়া'), selected: context.locale.languageCode == 'as', onSelected: (_) => context.setLocale(const Locale('as'))),
              ChoiceChip(label: const Text('हिन्दी'), selected: context.locale.languageCode == 'hi', onSelected: (_) => context.setLocale(const Locale('hi'))),
            ],
          ),
          SizedBox(height: 18.h),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: Text('settings.notifications'.tr()),
            subtitle: const Text('Firebase notification placeholder for appointment and complaint updates'),
          ),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: Text('settings.dark_mode'.tr()),
          ),
          ListTile(
            leading: const Icon(Icons.verified_outlined),
            title: Text('settings.version'.tr()),
            subtitle: Text(dotenv.get('APP_VERSION_LABEL', fallback: '1.0.0')),
          ),
        ],
      ),
    );
  }
}

class StaticInfoScreen extends StatelessWidget {
  const StaticInfoScreen({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Text(title, style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          SizedBox(height: 12.h),
          Text(body, style: context.textTheme.bodyLarge?.copyWith(height: 1.55)),
        ],
      ),
    );
  }
}
