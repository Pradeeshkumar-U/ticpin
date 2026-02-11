import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';
import 'package:path/path.dart' as path;

class ProfileSetupPage extends StatefulWidget {
  final bool
  isRequired; // If true, user must complete profile before proceeding

  const ProfileSetupPage({Key? key, this.isRequired = false}) : super(key: key);

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  bool isUploadingImage = false;
  String? phoneNumber;
  String? profilePicUrl;
  File? _selectedImage;
  Sizes size = Sizes();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    try {
      final userData = await _userService.getUserData();
      if (userData != null) {
        _nameController.text = userData.name ?? '';
        _emailController.text = userData.email ?? '';
        phoneNumber = userData.phoneNumber;
        profilePicUrl = userData.profilePicUrl;
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Show option to save immediately or wait
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image selected. Save profile to upload.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

    final ref = FirebaseStorage.instance.ref().child(
      'user_profile/${user.uid}/$fileName',
    );

    final task = ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final snapshot = await task;
    return snapshot.ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      String? uploadedImageUrl = profilePicUrl;

      if (_selectedImage != null) {
        setState(() => isUploadingImage = true);
        uploadedImageUrl = await _uploadImageToStorage(_selectedImage!);
        if (!mounted) return;
        setState(() => isUploadingImage = false);
      }

      await _userService.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        profilePicUrl: uploadedImageUrl,
      );

      _showSnackBar('Profile updated successfully', success: true);

      if (mounted) {
        Navigator.pop(context, widget.isRequired ? true : null);
      }
    } catch (e) {
      _showSnackBar('Failed to update profile');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:
          () async => !widget.isRequired && !isSaving && !isUploadingImage,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.isRequired ? 'Complete Your Profile' : 'Edit Profile',
            style: TextStyle(fontFamily: 'Regular'),
          ),
          leading:
              widget.isRequired
                  ? null
                  : IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
        ),
        body:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isRequired) ...[
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Please complete your profile before making a booking',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                        ],

                        // Profile Picture Section
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                        : (profilePicUrl != null
                                                ? NetworkImage(profilePicUrl!)
                                                : null)
                                            as ImageProvider?,
                                child:
                                    _selectedImage == null &&
                                            profilePicUrl == null
                                        ? Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey.shade400,
                                        )
                                        : null,
                              ),
                              if (isUploadingImage)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    // child: Center(
                                    //   child: CircularProgressIndicator(
                                    //     color: whiteColor,
                                    //     strokeWidth: 3,
                                    //   ),
                                    // ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: blackColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: whiteColor,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: _pickImage,
                            child: Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                fontFamily: 'Regular',
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Phone Number (Read-only)
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey),
                              SizedBox(width: 12),
                              Text(
                                phoneNumber ?? 'Not available',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Regular',
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.lock,
                                size: 16,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Name Field
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            hintStyle: TextStyle(fontFamily: 'Regular'),
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.trim().length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24),

                        // Email Field
                        Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(fontFamily: 'Regular'),
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 32),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                (isSaving || isUploadingImage)
                                    ? null
                                    : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blackColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                (isSaving || isUploadingImage)
                                    ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // SizedBox(
                                        //   height: 20,
                                        //   width: 20,
                                        //   child: CircularProgressIndicator(
                                        //     strokeWidth: 2,
                                        //     color: whiteColor,
                                        //   ),
                                        // ),
                                        // SizedBox(width: 12),
                                        Text(
                                          isUploadingImage
                                              ? 'Uploading Image...'
                                              : 'Saving...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Regular',
                                            color: whiteColor,
                                          ),
                                        ),
                                      ],
                                    )
                                    : Text(
                                      widget.isRequired
                                          ? 'Continue'
                                          : 'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: whiteColor,
                                      ),
                                    ),
                          ),
                        ),

                        if (!widget.isRequired) ...[
                          SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
