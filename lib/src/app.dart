import 'package:nalbari_connect/src/imports/core_imports.dart';
import 'package:nalbari_connect/src/imports/packages_imports.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = _buildMaterialApp(context, ref);
    return ScreenUtilWrapper(child: current);
  }

  Widget _buildMaterialApp(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Nalbari Connect',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#4F46E5'),
      darkTheme: buildDarkTheme(primaryColorHex: '#4F46E5'),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(appRouterProvider),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        Widget current = child!;
        current = SkeletonWrapper(child: current);
        current = SessionListenerWrapper(child: current);
        return current;
      },
    );
  }
}
