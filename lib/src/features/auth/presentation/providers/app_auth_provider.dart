import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nalbari_connect/src/features/auth/data/models/app_session.dart';
import 'package:nalbari_connect/src/services/secure_storage_service.dart';
import 'package:nalbari_connect/src/utils/logger.dart';

final appAuthProvider = StateNotifierProvider<AppAuthController, AppAuthState>((ref) {
  return AppAuthController();
});

class AppAuthController extends StateNotifier<AppAuthState> {
  AppAuthController() : super(const AppAuthState());

  static const _idKey = 'session.id';
  static const _phoneKey = 'session.phone';
  static const _nameKey = 'session.name';
  static const _roleKey = 'session.role';
  static const _tokenKey = 'session.token';
  static const _idProofKey = 'session.idProofLinked';

  Future<void> restoreSession() async {
    final storage = SecureStorageService.instance;
    final values = <String, String?>{};
    for (final key in [_idKey, _phoneKey, _nameKey, _roleKey, _tokenKey, _idProofKey]) {
      final result = await storage.read(key);
      result.fold((_) => values[key] = null, (value) => values[key] = value);
    }

    final user = AppSessionUser.fromStorage({
      'id': values[_idKey],
      'phone': values[_phoneKey],
      'name': values[_nameKey],
      'role': values[_roleKey],
      'token': values[_tokenKey],
      'idProofLinked': values[_idProofKey],
    });

    state = user == null
        ? const AppAuthState(status: AuthStatus.unauthenticated)
        : AppAuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true);
    AppLogger.info('[FAKE API] POST /auth/request-otp -> $phone');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      pendingPhone: phone,
      isLoading: false,
    );
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    final phone = state.pendingPhone;
    if (phone == null || otp.length != 6) return false;

    state = state.copyWith(isLoading: true);
    AppLogger.info('[FAKE API] POST /auth/verify-otp -> $phone');
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final normalizedPhone = phone.replaceAll(RegExp(r'\D'), '');
    final role = normalizedPhone == '9999999999' ? AppUserRole.admin : AppUserRole.citizen;
    final user = AppSessionUser(
      id: role == AppUserRole.admin ? 'admin-001' : 'citizen-001',
      phone: normalizedPhone,
      name: role == AppUserRole.admin ? 'Nalbari Office Admin' : 'Verified Resident',
      role: role,
      token: 'fake-jwt-token-$normalizedPhone',
      idProofLinked: false,
    );

    await _persist(user);
    AppLogger.success('[AUTH] Logged in as ${user.role.name}');
    state = AppAuthState(
      status: AuthStatus.authenticated,
      user: user,
      isLoading: false,
    );
    return true;
  }

  Future<void> markIdProofLinked() async {
    final user = state.user;
    if (user == null) return;
    final updated = user.copyWith(idProofLinked: true);
    await _persist(updated);
    state = state.copyWith(user: updated);
  }

  Future<void> logout() async {
    await SecureStorageService.instance.deleteAll();
    state = const AppAuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _persist(AppSessionUser user) async {
    final storage = SecureStorageService.instance;
    final data = user.toStorage();
    await storage.write(_idKey, data['id']!);
    await storage.write(_phoneKey, data['phone']!);
    await storage.write(_nameKey, data['name']!);
    await storage.write(_roleKey, data['role']!);
    await storage.write(_tokenKey, data['token']!);
    await storage.write(_idProofKey, data['idProofLinked']!);
  }
}
