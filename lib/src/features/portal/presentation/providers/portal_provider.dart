import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void bookAppointment(AppointmentRequest appointment) {
    state = state.copyWith(appointments: [appointment, ...state.appointments]);
  }

  void submitComplaint(ComplaintRequest complaint) {
    state = state.copyWith(complaints: [complaint, ...state.complaints]);
  }

  void updateAppointmentStatus(String id, AppointmentStatus status) {
    state = state.copyWith(
      appointments: [
        for (final appointment in state.appointments)
          appointment.id == id ? appointment.copyWith(status: status) : appointment,
      ],
    );
  }

  void updateComplaintStatus(String id, ComplaintStatus status) {
    state = state.copyWith(
      complaints: [
        for (final complaint in state.complaints)
          complaint.id == id ? complaint.copyWith(status: status) : complaint,
      ],
    );
  }
}
