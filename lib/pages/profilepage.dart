// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ticpin_play/constants/colors.dart';
// import 'package:ticpin_play/constants/size.dart';
// import 'package:ticpin_play/pages/login/loginpage.dart';
// import 'package:ticpin_play/pages/temppage.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   bool visi = true;
//   final wid = Sizes().width;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: visi
//           ? AppBar(
//               elevation: 0,
//               surfaceTintColor: whiteColor,
//               backgroundColor: whiteColor,
//               title: Text(
//                 "Profile",
//                 style: TextStyle(
//                   fontFamily: 'Regular',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               leading: IconButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 icon: Icon(Icons.arrow_back),
//               ),
//             )
//           : null,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   SizedBox(width: 10),
//                   CircleAvatar(
//                     radius: wid * 0.1,
//                     backgroundColor: Colors.black,
//                   ),
//                   SizedBox(width: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Update Name",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 19,
//                           fontFamily: 'Regular',
//                         ),
//                       ),
//                       Text("Number", style: TextStyle(fontFamily: 'Regular')),
//                     ],
//                   ),
//                   Spacer(),
//                   IconButton(
//                     onPressed: () {
//                       //   Edit profile page
//                     },
//                     icon: Icon(Icons.edit_outlined),
//                   ),
//                   SizedBox(width: 20),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Text(
//                 "All Bookings",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//               SizedBox(height: 20),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     SizedBox(width: 5),
//                     all_booking(
//                       "Table bookings",
//                       Icon(Icons.table_bar_rounded, color: Colors.black54),
//                       Temppage(),
//                       wid,
//                     ),
//                     SizedBox(width: 20),
//                     all_booking(
//                       "Movie tickets",
//                       Icon(Icons.movie_rounded, color: Colors.black54),
//                       Temppage(),
//                       wid,
//                     ),
//                     SizedBox(width: 20),
//                     all_booking(
//                       "Event tickets",
//                       Icon(CupertinoIcons.tickets_fill, color: Colors.black54),
//                       Temppage(),
//                       wid,
//                     ),
//                     SizedBox(width: 10),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 "Vouchers",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26, width: 1.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       horizon_cont(
//                         "Collected Vouchers",
//                         Icon(CupertinoIcons.ticket_fill, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                       // horizon_cont("", Icon(Icons.card_giftcard), Temppage()),
//                     ],
//                   ),
//                 ),
//               ),
//               // SizedBox(height: 30),
//               // Text(
//               //   "Payments",
//               //   style: TextStyle(
//               //     fontWeight: FontWeight.bold,
//               //     fontSize: 20,
//               //     fontFamily: 'Regular',
//               //   ),
//               // ),
//               // SizedBox(height: 20),
//               // Container(
//               //   decoration: BoxDecoration(
//               //     border: Border.all(color: Colors.grey, width: 0.5),
//               //     borderRadius: BorderRadius.circular(20),
//               //   ),
//               //   child: Column(
//               //     children: [
//               //       horizon_cont(
//               //         "Dining transactions",
//               //         Icon(Icons.receipt_long),
//               //         Temppage(),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               SizedBox(height: 30),
//               Text(
//                 "Manage",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26, width: 1.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       horizon_cont(
//                         "Your Reviews",
//                         Icon(Icons.rate_review_rounded, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                       Container(
//                         height: 1.5,
//                         color: Colors.black26,
//                         width: wid * 0.8,
//                       ),
//                       horizon_cont(
//                         "TicList",
//                         Icon(
//                           Icons.local_fire_department_rounded,
//                           color: Colors.black54,
//                         ),
//                         Temppage(),
//                         wid,
//                       ),
//                       Container(
//                         height: 1.5,
//                         color: Colors.black26,
//                         width: wid * 0.8,
//                       ),
//                       horizon_cont(
//                         "Movie Remainders",
//                         Icon(
//                           Icons.notifications_active_rounded,
//                           color: Colors.black54,
//                         ),
//                         Temppage(),
//                         wid,
//                       ),
//                       // Container(
//                       //   height: 1.5,
//                       //   color: Colors.black26,
//                       //   width: wid * 0.8,
//                       // ),
//                       // horizon_cont(
//                       //   "Payment Settings",
//                       //   Icon(Icons.wallet, color: Colors.black54),
//                       //   Temppage(),
//                       //   wid,
//                       // ),
//                       Container(
//                         height: 1.5,
//                         color: Colors.black26,
//                         width: wid * 0.8,
//                       ),
//                       horizon_cont(
//                         "Appearance",
//                         Icon(Icons.color_lens_rounded, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 "Support",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26, width: 1.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       horizon_cont(
//                         "Frequently Asked Questions",
//                         Icon(Icons.help_rounded, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                       Container(
//                         height: 1.5,
//                         color: Colors.black26,
//                         width: wid * 0.8,
//                       ),
//                       horizon_cont(
//                         "Chat with us",
//                         Icon(
//                           Icons.question_answer_rounded,
//                           color: Colors.black54,
//                         ),
//                         Temppage(),
//                         wid,
//                       ),
//                       Container(
//                         height: 1.5,
//                         color: Colors.black26,
//                         width: wid * 0.8,
//                       ),
//                       horizon_cont(
//                         "Share feedback",
//                         Icon(Icons.feedback_rounded, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 "More",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26, width: 1.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       horizon_cont(
//                         "Log out",
//                         Icon(Icons.logout_rounded, color: Colors.black54),
//                         Loginpage(),
//                         wid,
//                       ),
//                       // Container(
//                       //   height: 1.5,
//                       //   color: Colors.black26,
//                       //   width: wid * 0.8,
//                       // ),
//                       // horizon_cont(
//                       //   "Chat with us",
//                       //   Icon(
//                       //     Icons.question_answer_rounded,
//                       //     color: Colors.black54,
//                       //   ),
//                       //   Temppage(),
//                       //   wid,
//                       // ),
//                       // Container(
//                       //   height: 1.5,
//                       //   color: Colors.black26,
//                       //   width: wid * 0.8,
//                       // ),
//                       // horizon_cont(
//                       //   "Share feedback",
//                       //   Icon(Icons.feedback_rounded, color: Colors.black54),
//                       //   Temppage(),
//                       //   wid,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: Sizes().height * 0.06),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:ticpin_play/constants/model.dart';
import 'package:ticpin_play/constants/size.dart';
import 'package:ticpin_play/pages/login/loginpage.dart';
import 'package:ticpin_play/services/adminservice.dart';

class TurfPartnerAdminProfilePage extends StatefulWidget {
  const TurfPartnerAdminProfilePage({super.key});

  @override
  State<TurfPartnerAdminProfilePage> createState() =>
      _TurfPartnerAdminProfilePageState();
}

class _TurfPartnerAdminProfilePageState
    extends State<TurfPartnerAdminProfilePage> {
  final TurfPartnerAdminService _adminService = TurfPartnerAdminService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isEditing = false;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Bank details controllers
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  // Address controllers
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _branchController.dispose();
    _upiController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final file = File(image.path);
      final userId = _auth.currentUser!.uid;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('turf_admin')
          .child('$userId.jpg');

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      await _adminService.updateProfile(profilePicUrl: downloadUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile picture updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile(TurfPartnerAdminModel adminData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Update basic profile
      await _adminService.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      // Update business info
      if (_businessNameController.text.isNotEmpty) {
        final businessInfo = BusinessInfo(
          businessName: _businessNameController.text.trim(),
          businessType: _businessTypeController.text.trim(),
          gstNumber: _gstController.text.trim(),
          panNumber: _panController.text.trim(),
          website: _websiteController.text.trim(),
          description: _descriptionController.text.trim(),
          registeredAddress: Address(
            street: _streetController.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            postalCode: _postalCodeController.text.trim(),
            country: _countryController.text.trim(),
          ),
        );
        await _adminService.updateBusinessInfo(businessInfo);
      }

      // Update bank details
      if (_accountNumberController.text.isNotEmpty) {
        final bankDetails = BankDetails(
          accountHolderName: _accountHolderController.text.trim(),
          accountNumber: _accountNumberController.text.trim(),
          ifscCode: _ifscController.text.trim(),
          bankName: _bankNameController.text.trim(),
          branchName: _branchController.text.trim(),
          upiId: _upiController.text.trim(),
        );
        await _adminService.updateBankDetails(bankDetails);
      }

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadData(TurfPartnerAdminModel adminData) {
    _nameController.text = adminData.name ?? '';
    _emailController.text = adminData.email ?? '';

    if (adminData.businessInfo != null) {
      _businessNameController.text = adminData.businessInfo!.businessName ?? '';
      _businessTypeController.text = adminData.businessInfo!.businessType ?? '';
      _gstController.text = adminData.businessInfo!.gstNumber ?? '';
      _panController.text = adminData.businessInfo!.panNumber ?? '';
      _websiteController.text = adminData.businessInfo!.website ?? '';
      _descriptionController.text = adminData.businessInfo!.description ?? '';

      if (adminData.businessInfo!.registeredAddress != null) {
        _streetController.text =
            adminData.businessInfo!.registeredAddress!.street ?? '';
        _cityController.text =
            adminData.businessInfo!.registeredAddress!.city ?? '';
        _stateController.text =
            adminData.businessInfo!.registeredAddress!.state ?? '';
        _postalCodeController.text =
            adminData.businessInfo!.registeredAddress!.postalCode ?? '';
        _countryController.text =
            adminData.businessInfo!.registeredAddress!.country ?? '';
      }
    }

    if (adminData.bankDetails != null) {
      _accountHolderController.text =
          adminData.bankDetails!.accountHolderName ?? '';
      _accountNumberController.text =
          adminData.bankDetails!.accountNumber ?? '';
      _ifscController.text = adminData.bankDetails!.ifscCode ?? '';
      _bankNameController.text = adminData.bankDetails!.bankName ?? '';
      _branchController.text = adminData.bankDetails!.branchName ?? '';
      _upiController.text = adminData.bankDetails!.upiId ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile', style: TextStyle(fontFamily: 'Regular')),
        backgroundColor: Color(0xFF1E1E82),
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
            ),
        ],
      ),
      body: StreamBuilder<TurfPartnerAdminModel?>(
        stream: _adminService.getAdminDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final adminData = snapshot.data!;

          // Load data when switching to edit mode
          if (_isEditing && _nameController.text.isEmpty) {
            _loadData(adminData);
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture Section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: adminData.profilePicUrl != null
                                ? NetworkImage(adminData.profilePicUrl!)
                                : null,
                            child: adminData.profilePicUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey.shade600,
                                  )
                                : null,
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickAndUploadImage,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xFF1E1E82),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Status Badge
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(adminData.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(adminData.status),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Basic Information
                    _buildSectionTitle('Basic Information'),
                    SizedBox(height: 8),
                    _buildInfoCard([
                      _buildInfoRow(
                        'Phone Number',
                        adminData.phoneNumber,
                        Icons.phone,
                        isEditable: false,
                      ),
                      if (_isEditing)
                        _buildTextField('Name', _nameController, Icons.person)
                      else
                        _buildInfoRow(
                          'Name',
                          adminData.name ?? 'Not set',
                          Icons.person,
                        ),
                      if (_isEditing)
                        _buildTextField('Email', _emailController, Icons.email)
                      else
                        _buildInfoRow(
                          'Email',
                          adminData.email ?? 'Not set',
                          Icons.email,
                        ),
                      _buildInfoRow(
                        'Member Since',
                        DateFormat('MMM dd, yyyy').format(adminData.createdAt),
                        Icons.calendar_today,
                        isEditable: false,
                      ),
                    ]),

                    SizedBox(height: 24),

                    // Business Information
                    _buildSectionTitle('Business Information'),
                    SizedBox(height: 8),
                    _buildInfoCard([
                      if (_isEditing) ...[
                        _buildTextField(
                          'Business Name',
                          _businessNameController,
                          Icons.business,
                        ),
                        _buildTextField(
                          'Business Type',
                          _businessTypeController,
                          Icons.category,
                        ),
                        _buildTextField(
                          'GST Number',
                          _gstController,
                          Icons.numbers,
                        ),
                        _buildTextField(
                          'PAN Number',
                          _panController,
                          Icons.credit_card,
                        ),
                        _buildTextField(
                          'Website',
                          _websiteController,
                          Icons.language,
                        ),
                        _buildTextField(
                          'Description',
                          _descriptionController,
                          Icons.description,
                          maxLines: 3,
                        ),
                      ] else ...[
                        _buildInfoRow(
                          'Business Name',
                          adminData.businessInfo?.businessName ?? 'Not set',
                          Icons.business,
                        ),
                        _buildInfoRow(
                          'Business Type',
                          adminData.businessInfo?.businessType ?? 'Not set',
                          Icons.category,
                        ),
                        _buildInfoRow(
                          'GST Number',
                          adminData.businessInfo?.gstNumber ?? 'Not set',
                          Icons.numbers,
                        ),
                        _buildInfoRow(
                          'PAN Number',
                          adminData.businessInfo?.panNumber ?? 'Not set',
                          Icons.credit_card,
                        ),
                      ],
                    ]),

                    SizedBox(height: 24),

                    // Business Address
                    if (_isEditing ||
                        adminData.businessInfo?.registeredAddress != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Business Address'),
                          SizedBox(height: 8),
                          _buildInfoCard([
                            if (_isEditing) ...[
                              _buildTextField(
                                'Street',
                                _streetController,
                                Icons.location_on,
                              ),
                              _buildTextField(
                                'City',
                                _cityController,
                                Icons.location_city,
                              ),
                              _buildTextField(
                                'State',
                                _stateController,
                                Icons.map,
                              ),
                              _buildTextField(
                                'Postal Code',
                                _postalCodeController,
                                Icons.pin,
                              ),
                              _buildTextField(
                                'Country',
                                _countryController,
                                Icons.flag,
                              ),
                            ] else ...[
                              _buildInfoRow(
                                'Street',
                                adminData
                                        .businessInfo
                                        ?.registeredAddress
                                        ?.street ??
                                    'Not set',
                                Icons.location_on,
                              ),
                              _buildInfoRow(
                                'City',
                                adminData
                                        .businessInfo
                                        ?.registeredAddress
                                        ?.city ??
                                    'Not set',
                                Icons.location_city,
                              ),
                              _buildInfoRow(
                                'State',
                                adminData
                                        .businessInfo
                                        ?.registeredAddress
                                        ?.state ??
                                    'Not set',
                                Icons.map,
                              ),
                            ],
                          ]),
                          SizedBox(height: 24),
                        ],
                      ),

                    // Bank Details
                    _buildSectionTitle('Bank Details'),
                    SizedBox(height: 8),
                    _buildInfoCard([
                      if (_isEditing) ...[
                        _buildTextField(
                          'Account Holder Name',
                          _accountHolderController,
                          Icons.person_outline,
                        ),
                        _buildTextField(
                          'Account Number',
                          _accountNumberController,
                          Icons.account_balance,
                        ),
                        _buildTextField(
                          'IFSC Code',
                          _ifscController,
                          Icons.code,
                        ),
                        _buildTextField(
                          'Bank Name',
                          _bankNameController,
                          Icons.account_balance,
                        ),
                        _buildTextField(
                          'Branch',
                          _branchController,
                          Icons.location_city,
                        ),
                        _buildTextField(
                          'UPI ID',
                          _upiController,
                          Icons.payment,
                        ),
                      ] else ...[
                        _buildInfoRow(
                          'Account Holder',
                          adminData.bankDetails?.accountHolderName ?? 'Not set',
                          Icons.person_outline,
                        ),
                        _buildInfoRow(
                          'Account Number',
                          _maskAccountNumber(
                            adminData.bankDetails?.accountNumber,
                          ),
                          Icons.account_balance,
                        ),
                        _buildInfoRow(
                          'IFSC Code',
                          adminData.bankDetails?.ifscCode ?? 'Not set',
                          Icons.code,
                        ),
                        _buildInfoRow(
                          'Bank Name',
                          adminData.bankDetails?.bankName ?? 'Not set',
                          Icons.account_balance,
                        ),
                        if (adminData.bankDetails?.isVerified ?? false)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Bank details verified',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ]),

                    SizedBox(height: 24),

                    // Statistics
                    if (!_isEditing) _buildSectionTitle('Statistics'),
                    if (!_isEditing) SizedBox(height: 8),
                    if (!_isEditing)
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatCard(
                            'Total Turfs',
                            '${adminData.stats.totalTurfs}',
                            Icons.sports_soccer,
                            Colors.blue,
                          ),
                          _buildStatCard(
                            'Total Bookings',
                            '${adminData.stats.totalBookings}',
                            Icons.event_note,
                            Colors.green,
                          ),
                          _buildStatCard(
                            'Total Revenue',
                            '₹${NumberFormat('#,##,###').format(adminData.stats.totalRevenue)}',
                            Icons.currency_rupee,
                            Colors.orange,
                          ),
                          _buildStatCard(
                            'Avg Rating',
                            '${adminData.stats.averageRating.toStringAsFixed(1)}',
                            Icons.star,
                            Colors.amber,
                          ),
                        ],
                      ),

                    if (!_isEditing) SizedBox(height: 24),

                    // Logout Button
                    if (!_isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Logout'),
                                content: Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _auth.signOut();
                              Get.offAll(() => Loginpage());
                            }
                          },
                          icon: Icon(Icons.logout, color: Colors.red),
                          label: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Regular',
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                    SizedBox(height: 100),
                  ],
                ),
              ),

              // Save Button
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: ElevatedButton(
                        onPressed: () => _saveProfile(adminData),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E1E82),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Loading Overlay
              if (_isLoading)
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Regular',
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    bool isEditable = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: 'Regular',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontFamily: 'Regular'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontFamily: 'Regular'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Regular'),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: Sizes().height * 0.001),
            Expanded(
              child: Text(
                ' $value',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Regular',
                ),
              ),
            ),
            SizedBox(height: Sizes().height * 0.005),
            Expanded(
              child: Text(
                ' $label',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontFamily: 'Regular',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.isEmpty) return 'Not set';
    if (accountNumber.length <= 4) return accountNumber;
    return '****${accountNumber.substring(accountNumber.length - 4)}';
  }

  Color _getStatusColor(AdminStatus status) {
    switch (status) {
      case AdminStatus.approved:
        return Colors.green;
      case AdminStatus.pending:
        return Colors.orange;
      case AdminStatus.rejected:
        return Colors.red;
      case AdminStatus.suspended:
        return Colors.red.shade700;
      case AdminStatus.inactive:
        return Colors.grey;
    }
  }

  String _getStatusText(AdminStatus status) {
    switch (status) {
      case AdminStatus.approved:
        return 'Approved';
      case AdminStatus.pending:
        return 'Pending Approval';
      case AdminStatus.rejected:
        return 'Rejected';
      case AdminStatus.suspended:
        return 'Suspended';
      case AdminStatus.inactive:
        return 'Inactive';
    }
  }
}
