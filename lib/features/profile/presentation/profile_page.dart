import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  String? _photoUrl;
  String? _selectedGender; // 'Male', 'Female', 'Other', or null

  late final ProfileBloc _bloc;
  final _imagePicker = sl<ImagePickerService>();
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _bloc = sl<ProfileBloc>()..add(const ProfileStarted());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _goalCtrl.dispose();
    _bloc.close();
    super.dispose();
  }

  void _fill(UserProfile p) {
    _nameCtrl.text = p.name;
    _ageCtrl.text = p.age == 0 ? '' : p.age.toString();
    _selectedGender = _normalizeGenderLabel(p.gender);
    _heightCtrl.text = p.height == 0 ? '' : p.height.toString();
    _weightCtrl.text = p.weight == 0 ? '' : p.weight.toString();
    _goalCtrl.text = p.goal;
    _photoUrl = p.photoUrl.isEmpty ? null : p.photoUrl;
  }

  String? _normalizeGenderLabel(String value) {
    final v = value.trim().toLowerCase();
    if (v.isEmpty || v == '-') return null;
    if (v == 'm' || v == 'male') return 'Male';
    if (v == 'f' || v == 'female') return 'Female';
    if (v == 'o' || v == 'other') return 'Other';
    if (v == 'n' || v == 'prefer not to say') return 'Prefer not to say';
    // Fallback to capitalized original
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _bloc,
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.saving) {
          if (!_isDialogVisible) {
            _isDialogVisible = true;
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            ).whenComplete(() => _isDialogVisible = false);
          }
          return;
        }

        // Dismiss loader if visible
        if (_isDialogVisible) {
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) navigator.pop();
          _isDialogVisible = false;
        }

        if (state.status == ProfileStatus.loaded && state.profile != null) {
          _fill(state.profile!);
        } else if (state.status == ProfileStatus.saved) {
          Fluttertoast.showToast(
            msg: 'Profile updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
          Navigator.of(context).maybePop();
        } else if (state.status == ProfileStatus.failure &&
            state.errorMessage != null) {
          Fluttertoast.showToast(
            msg: state.errorMessage!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      builder: (context, state) {
        final isBusy = state.status == ProfileStatus.saving;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppHeight.h20),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  (_photoUrl != null && _photoUrl!.isNotEmpty)
                                      ? FileImage(File(_photoUrl!))
                                      : null,
                              child: (_photoUrl == null || _photoUrl!.isEmpty)
                                  ? const Icon(Icons.person, size: 48)
                                  : null,
                            ),
                            Positioned(
                              right: -4,
                              bottom: -4,
                              child: Material(
                                color: Theme.of(context).colorScheme.surface,
                                shape: const CircleBorder(),
                                elevation: 2,
                                child: IconButton(
                                  icon: const Icon(Icons.photo_camera),
                                  tooltip: 'Change photo',
                                  onPressed: () async {
                                    final path =
                                        await _imagePicker.pickFromGallery();
                                    if (path != null) {
                                      setState(() => _photoUrl = path);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppHeight.h20),

                      // Name
                      CustomTextFormField(
                        label: 'Name',
                        controller: _nameCtrl,
                        hint: 'Your full name',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? '*Required'
                            : null,
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Gender
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Other'),
                        value: 'Other',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Prefer not to say'),
                        value: 'Prefer not to say',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Age
                      CustomTextFormField(
                        label: 'Age',
                        controller: _ageCtrl,
                        hint: 'e.g., 28',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Height
                      CustomTextFormField(
                        label: 'Height (cm)',
                        controller: _heightCtrl,
                        hint: 'e.g., 175',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Weight
                      CustomTextFormField(
                        label: 'Weight (kg)',
                        controller: _weightCtrl,
                        hint: 'e.g., 70.5',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      SizedBox(height: AppHeight.h10),

                      // Goal
                      CustomTextFormField(
                        label: 'Goal',
                        controller: _goalCtrl,
                        hint: 'e.g., Lose weight, Build muscle',
                        minLines: 2,
                        maxLines: 4,
                      ),

                      SizedBox(height: AppHeight.h20),
                      CustomButton(
                        onPressed: isBusy
                            ? () {}
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                final p =
                                    state.profile ?? UserProfile.empty('');
                                final updated = p.copyWith(
                                  name: _nameCtrl.text.trim(),
                                  age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
                                  gender: (_selectedGender ?? '').trim(),
                                  height: double.tryParse(
                                          _heightCtrl.text.trim()) ??
                                      0,
                                  weight: double.tryParse(
                                          _weightCtrl.text.trim()) ??
                                      0,
                                  goal: _goalCtrl.text.trim(),
                                  photoUrl: _photoUrl ?? '',
                                  lastUpdated: DateTime.now(),
                                );
                                _bloc.add(ProfileSaved(updated));
                              },
                        child: Text(
                          'Save Profile',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      SizedBox(height: AppHeight.h10),

                      if (state.status == ProfileStatus.failure &&
                          state.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            state.errorMessage!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      SizedBox(height: AppHeight.h20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
