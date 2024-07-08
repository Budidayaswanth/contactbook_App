class ContactModel {
  final String? contactName;
  final String? emailId;
  final int? mobile;

  ContactModel({this.contactName, this.emailId, this.mobile});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactName: json['contactName'],
      emailId: json['emailId'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'emailId': emailId,
      'mobile': mobile,
    };
  }
}
