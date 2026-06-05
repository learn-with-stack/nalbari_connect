import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nalbari_connect/src/features/portal/data/models/portal_models.dart';
import 'package:nalbari_connect/src/features/portal/data/services/fake_portal_repository.dart';

final portalRepositoryProvider = Provider<FakePortalRepository>((ref) {
  return FakePortalRepository();
});

final newsProvider = FutureProvider<List<NewsItem>>((ref) {
  return ref.watch(portalRepositoryProvider).fetchNews();
});

final portalControllerProvider = StateNotifierProvider<PortalController, PortalState>((ref) {
  return PortalController(ref.watch(portalRepositoryProvider));
});

class PortalState {
  const PortalState({
    this.appointments = const [],
    this.complaints = const [],
    this.isLoading = true,
    this.error,
  });

  final List<AppointmentRequest> appointments;
  final List<ComplaintRequest> complaints;
  final bool isLoading;
  final String? error;

  PortalState copyWith({
    List<AppointmentRequest>? appointments,
    List<ComplaintRequest>? complaints,
    bool? isLoading,
    String? error,
  }) {
    return PortalState(
      appointments: appointments ?? this.appointments,
      complaints: complaints ?? this.complaints,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PortalController extends StateNotifier<PortalState> {
  PortalController(this._repository) : super(const PortalState()) {
    load();
  }

  final FakePortalRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    try {
      final appointments = await _repository.fetchAppointments();
      final complaints = await _repository.fetchComplaints();
      state = PortalState(
        appointments: appointments,
        complaints: complaints,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> bookAppointment(AppointmentRequest appointment) async {
    final created = await _repository.createAppointment(appointment);
    state = state.copyWith(appointments: [created, ...state.appointments]);
  }

  Future<void> submitComplaint(ComplaintRequest complaint) async {
    final created = await _repository.createComplaint(complaint);
    state = state.copyWith(complaints: [created, ...state.complaints]);
  }

  Future<void> updateAppointmentStatus(String id, AppointmentStatus status) async {
    AppointmentRequest? existing;
    for (final appointment in state.appointments) {
      if (appointment.id == id) {
        existing = appointment;
        break;
      }
    }
    if (existing == null) return;
    final updated = await _repository.updateAppointmentStatus(existing, status);
    state = state.copyWith(
      appointments: [
        for (final appointment in state.appointments)
          appointment.id == id ? updated : appointment,
      ],
    );
  }

  Future<void> updateComplaintStatus(String id, ComplaintStatus status) async {
    ComplaintRequest? existing;
    for (final complaint in state.complaints) {
      if (complaint.id == id) {
        existing = complaint;
        break;
      }
    }
    if (existing == null) return;
    final updated = await _repository.updateComplaintStatus(existing, status);
    state = state.copyWith(
      complaints: [
        for (final complaint in state.complaints)
          complaint.id == id ? updated : complaint,
      ],
    );
  }
}
