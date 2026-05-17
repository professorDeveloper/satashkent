import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../bloc/edit_profile_bloc.dart';
import '../bloc/edit_profile_event.dart';
import '../bloc/edit_profile_state.dart';
import '../widgets/profile_avatar.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (_) => getIt<EditProfileBloc>(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final formKey = GlobalKey<FormState>();
  late final User? initialUser = getIt<HiveService>().getUser();
  late final TextEditingController nameCtrl =
      TextEditingController(text: initialUser?.name ?? '');
  late final TextEditingController loginCtrl =
      TextEditingController(text: initialUser?.login ?? '');
  late final TextEditingController emailCtrl =
      TextEditingController(text: initialUser?.email ?? '');
  late final TextEditingController phoneCtrl =
      TextEditingController(text: initialUser?.phone ?? '');

  @override
  void dispose() {
    nameCtrl.dispose();
    loginCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void flashSnack(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    context.read<EditProfileBloc>().add(
          EditProfileSubmitted(
            name: nameCtrl.text,
            login: loginCtrl.text,
            email: emailCtrl.text,
            phone: phoneCtrl.text,
          ),
        );
  }

  Future<void> pickAndUploadImage() async {
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 92,
      maxWidth: 1500,
    );
    if (picked == null) return;
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 92,
      maxWidth: 1024,
      maxHeight: 1024,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: AppColors.brand,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.brand,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Crop',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
    if (cropped == null || !mounted) return;
    final bytes = await cropped.readAsBytes();
    if (!mounted) return;
    context.read<EditProfileBloc>().add(EditProfileImagePicked(bytes));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (a, b) => a.messageNonce != b.messageNonce,
      listener: (context, state) {
        final err = state.errorMessage;
        final info = state.infoMessage;
        if (err != null && err.isNotEmpty) {
          flashSnack(err);
        } else if (info != null && info.isNotEmpty) {
          if (state.savedUser != null) {
            Navigator.of(context).pop(true);
          } else {
            flashSnack(info.tr());
            if (info == 'photoUpdated') {
              evictAvatarCache(state.imageUrl);
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('editProfile'.tr())),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                Center(
                  child: BlocSelector<EditProfileBloc, EditProfileState,
                      _AvatarSlice>(
                    selector: (s) =>
                        _AvatarSlice(s.imageUrl, s.uploading),
                    builder: (context, sel) => EditAvatar(
                      imageUrl: sel.url,
                      uploading: sel.uploading,
                      onTap: sel.uploading ? null : pickAndUploadImage,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileField(
                  controller: nameCtrl,
                  label: 'fullName'.tr(),
                  icon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.trim().length < 2)
                      ? 'nameTooShort'.tr()
                      : null,
                ),
                const SizedBox(height: 14),
                ProfileField(
                  controller: loginCtrl,
                  label: 'username'.tr(),
                  icon: Icons.alternate_email_rounded,
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'usernameTooShort'.tr()
                      : null,
                ),
                const SizedBox(height: 14),
                ProfileField(
                  controller: emailCtrl,
                  label: 'email'.tr(),
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                ProfileField(
                  controller: phoneCtrl,
                  label: 'phone'.tr(),
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                BlocSelector<EditProfileBloc, EditProfileState, bool>(
                  selector: (s) => s.saving,
                  builder: (context, saving) => FilledButton(
                    onPressed: saving ? null : submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.4,
                            ),
                          )
                        : Text('save'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> evictAvatarCache(String? url) async {
    if (url == null) return;
    await CachedNetworkImage.evictFromCache(url);
    final base = url.split('?').first;
    if (base != url) await CachedNetworkImage.evictFromCache(base);
  }

  Future<ImageSource?> showImageSourceSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        final muted = Theme.of(sheetContext)
            .colorScheme
            .onSurface
            .withValues(alpha: 0.55);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                ImageSourceTile(
                  icon: Icons.photo_camera_rounded,
                  title: 'cameraOption'.tr(),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(ImageSource.camera),
                ),
                ImageSourceTile(
                  icon: Icons.photo_library_rounded,
                  title: 'galleryOption'.tr(),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const ImageSourceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.brand.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.brand, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _AvatarSlice {
  final String? url;
  final bool uploading;
  const _AvatarSlice(this.url, this.uploading);

  @override
  bool operator ==(Object other) =>
      other is _AvatarSlice && other.url == url && other.uploading == uploading;

  @override
  int get hashCode => Object.hash(url, uploading);
}

class EditAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool uploading;
  final VoidCallback? onTap;
  const EditAvatar({
    super.key,
    required this.imageUrl,
    required this.uploading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Hero(
          tag: profileAvatarHeroTag,
          child: ProfileAvatar(
            image: imageUrl,
            size: 120,
            ring: 4,
            ringColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        if (uploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.4),
              ),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Material(
            shape: const CircleBorder(),
            color: AppColors.brand,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
