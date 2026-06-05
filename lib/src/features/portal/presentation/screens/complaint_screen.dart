import 'package:nalbari_connect/src/features/auth/presentation/providers/app_auth_provider.dart';
import 'package:nalbari_connect/src/features/portal/data/models/portal_models.dart';
import 'package:nalbari_connect/src/features/portal/presentation/providers/portal_provider.dart';
import 'package:nalbari_connect/src/imports/imports.dart';

class ComplaintScreen extends ConsumerStatefulWidget {
  const ComplaintScreen({super.key});

  @override
  ConsumerState<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends ConsumerState<ComplaintScreen> {
  final _areaController = TextEditingController();
  final _detailsController = TextEditingController();
  AreaType _areaType = AreaType.ward;
  String? _mediaName;

  @override
  void dispose() {
    _areaController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(appAuthProvider);
    return Scaffold(
      appBar: AppBar(title: Text('complaint.title'.tr())),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Text('complaint.area_type'.tr(), style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          SizedBox(height: 10.h),
          SegmentedButton<AreaType>(
            segments: [
              ButtonSegment(value: AreaType.ward, label: Text('complaint.ward'.tr())),
              ButtonSegment(value: AreaType.panchayat, label: Text('complaint.panchayat'.tr())),
            ],
            selected: {_areaType},
            onSelectionChanged: (value) => setState(() => _areaType = value.first),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _areaController,
            label: _areaType == AreaType.ward ? 'complaint.ward_number'.tr() : 'complaint.panchayat_number'.tr(),
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.location_city_outlined),
          ),
          SizedBox(height: 18.h),
          AppTextField(
            controller: _detailsController,
            label: 'complaint.describe'.tr(),
            hint: 'complaint.describe_hint'.tr(),
            minLines: 5,
            maxLines: 7,
          ),
          SizedBox(height: 18.h),
          Text('complaint.media'.tr(), style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          SizedBox(height: 10.h),
          _ComplaintUploadBox(
            title: _mediaName ?? 'complaint.upload_media'.tr(),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['png', 'jpg', 'jpeg', 'mp4'],
              );
              if (result != null) setState(() => _mediaName = result.files.single.name);
            },
          ),
          SizedBox(height: 26.h),
          FilledButton(
            onPressed: () {
              ref.read(portalControllerProvider.notifier).submitComplaint(
                    ComplaintRequest(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      reporterName: auth.user?.name ?? 'Verified Resident',
                      areaType: _areaType,
                      areaNumber: _areaController.text.trim().isEmpty ? 'Not provided' : _areaController.text.trim(),
                      description: _detailsController.text.trim().isEmpty ? 'Local issue reported by citizen.' : _detailsController.text.trim(),
                      status: ComplaintStatus.newRequest,
                      priority: ComplaintPriority.medium,
                      createdAt: DateTime.now(),
                      mediaName: _mediaName,
                    ),
                  );
              context.showSuccessSnackBar('complaint.success'.tr());
              context.pop();
            },
            child: Text('complaint.submit'.tr()),
          ),
        ],
      ),
    );
  }
}

class _ComplaintUploadBox extends StatelessWidget {
  const _ComplaintUploadBox({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorders.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: AppBorders.card,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              Icon(Icons.perm_media_outlined, color: cs.primary, size: 34.sp),
              SizedBox(height: 8.h),
              Text(title, textAlign: TextAlign.center, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: 4.h),
              Text('PNG, JPG, MP4 up to 10MB each', textAlign: TextAlign.center, style: context.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
