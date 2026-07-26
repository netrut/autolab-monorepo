class ServiceCenterModel {
  final String id;
  final String name;
  final String phone;
  final String? description;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final double? rating;
  final bool? isVerified;
  final bool? isActive;
  final String? ownerUserId;
  final String category;
  final String? mapsLink;
  final double? latitude;
  final double? longitude;
  final List<String> vehicleTypes;
  final List<String> serviceTypes;
  final List<String> brandsServiced;
  final String? workingHours;
  final bool acceptsBookings;
  final String onboardingStatus;
  final ServiceCenterDetailsModel? details;

  const ServiceCenterModel({
    required this.id,
    required this.name,
    required this.phone,
    this.description,
    this.email,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.rating,
    this.isVerified,
    this.isActive,
    this.ownerUserId,
    this.category = 'service_center',
    this.mapsLink,
    this.latitude,
    this.longitude,
    this.vehicleTypes = const [],
    this.serviceTypes = const [],
    this.brandsServiced = const [],
    this.workingHours,
    this.acceptsBookings = true,
    this.onboardingStatus = 'draft',
    this.details,
  });

  factory ServiceCenterModel.fromJson(Map<String, dynamic> json) =>
      ServiceCenterModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone']?.toString() ?? '',
        description: json['description'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        pincode: json['pincode'] as String?,
        rating: double.tryParse(json['rating']?.toString() ?? ''),
        isVerified: json['is_verified'] as bool?,
        isActive: json['is_active'] as bool?,
        ownerUserId: json['owner_user_id'] as String?,
        category: json['category'] as String? ?? 'service_center',
        mapsLink: json['maps_link'] as String?,
        latitude: double.tryParse(json['latitude']?.toString() ?? ''),
        longitude: double.tryParse(json['longitude']?.toString() ?? ''),
        vehicleTypes: _toStringList(json['vehicle_types']),
        serviceTypes: _toStringList(json['service_types']),
        brandsServiced: _toStringList(json['brands_serviced']),
        workingHours: json['working_hours'] as String?,
        acceptsBookings: json['accepts_bookings'] as bool? ?? true,
        onboardingStatus: json['onboarding_status'] as String? ?? 'draft',
        details: json['details'] != null
            ? ServiceCenterDetailsModel.fromJson(
                json['details'] as Map<String, dynamic>)
            : null,
      );

  static List<String> _toStringList(dynamic v) {
    if (v == null) return [];
    if (v is List) return v.map((e) => e.toString()).toList();
    return [];
  }

  String get statusLabel {
    switch (onboardingStatus) {
      case 'submitted':     return 'Under Review';
      case 'under_review':  return 'Under Review';
      case 'verified':      return 'Verified';
      case 'rejected':      return 'Rejected';
      default:              return 'Draft';
    }
  }

  String get categoryLabel {
    switch (category) {
      case 'service_center':      return 'Service Centre';
      case 'decor_accessories':   return 'Decor & Accessories';
      case 'seller':              return 'Seller';
      default:                    return category;
    }
  }
}

class ServiceCenterDetailsModel {
  final String id;
  final String serviceCenterId;
  final String? tradeName;
  final String? businessType;
  final int? yearEstablished;
  final String? website;
  final String? logoUrl;
  final String? whatsappNumber;
  final String? gstNumber;
  final String? panNumber;
  final String? shopRegNumber;
  final String? tradeLicense;
  final String? msmeNumber;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final String? designation;
  final String? aadhaarLast4;
  final String? accountHolder;
  final String? bankName;
  final String? ifscCode;
  final String? upiId;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? verifiedAt;

  const ServiceCenterDetailsModel({
    required this.id,
    required this.serviceCenterId,
    this.tradeName,
    this.businessType,
    this.yearEstablished,
    this.website,
    this.logoUrl,
    this.whatsappNumber,
    this.gstNumber,
    this.panNumber,
    this.shopRegNumber,
    this.tradeLicense,
    this.msmeNumber,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.designation,
    this.aadhaarLast4,
    this.accountHolder,
    this.bankName,
    this.ifscCode,
    this.upiId,
    this.rejectionReason,
    this.submittedAt,
    this.verifiedAt,
  });

  factory ServiceCenterDetailsModel.fromJson(Map<String, dynamic> json) =>
      ServiceCenterDetailsModel(
        id: json['id'] as String,
        serviceCenterId: json['service_center_id'] as String,
        tradeName: json['trade_name'] as String?,
        businessType: json['business_type'] as String?,
        yearEstablished: json['year_established'] as int?,
        website: json['website'] as String?,
        logoUrl: json['logo_url'] as String?,
        whatsappNumber: json['whatsapp_number'] as String?,
        gstNumber: json['gst_number'] as String?,
        panNumber: json['pan_number'] as String?,
        shopRegNumber: json['shop_reg_number'] as String?,
        tradeLicense: json['trade_license'] as String?,
        msmeNumber: json['msme_number'] as String?,
        ownerName: json['owner_name'] as String?,
        ownerPhone: json['owner_phone'] as String?,
        ownerEmail: json['owner_email'] as String?,
        designation: json['designation'] as String?,
        aadhaarLast4: json['aadhaar_last4'] as String?,
        accountHolder: json['account_holder'] as String?,
        bankName: json['bank_name'] as String?,
        ifscCode: json['ifsc_code'] as String?,
        upiId: json['upi_id'] as String?,
        rejectionReason: json['rejection_reason'] as String?,
        submittedAt: json['submitted_at'] != null
            ? DateTime.tryParse(json['submitted_at'] as String)
            : null,
        verifiedAt: json['verified_at'] != null
            ? DateTime.tryParse(json['verified_at'] as String)
            : null,
      );
}
