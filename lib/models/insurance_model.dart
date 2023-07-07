import 'dart:convert';
import 'package:flutter/foundation.dart';

class Insurance {
  final String id;
  final String claimSuccessPercentage;
  final String companyName;
  final String coverageValue;
  final String description;
  final String insuranceName;
  final String launchDate;
  final String monthlyCost;
  final String otherDetails;
  final String publicKey;
  final String type;

  Insurance({
    required this.id,
    required this.claimSuccessPercentage,
    required this.companyName,
    required this.coverageValue,
    required this.description,
    required this.insuranceName,
    required this.launchDate,
    required this.monthlyCost,
    required this.otherDetails,
    required this.publicKey,
    required this.type,
  });

  factory Insurance.fromJson(Map<String, dynamic> json, {required String id}) {
    final data = json['data'][json.keys.first];
    return Insurance(
      id: json.keys.first,
      claimSuccessPercentage: data['claim_success_percentage'],
      companyName: data['company_name'],
      coverageValue: data['coverage_value'],
      description: data['description'],
      insuranceName: data['insurance_name'],
      launchDate: data['launch_date'],
      monthlyCost: data['monthly_cost'],
      otherDetails: data['other_details'],
      publicKey: data['public_key'],
      type: data['type'],
    );
  }
}