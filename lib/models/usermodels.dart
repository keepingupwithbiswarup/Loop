// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserSchema {
  String userId;
  String name;
  String profileName;
  String email;
  String password;
  String dob;
  String profileImage;
  String backgroundImage;
  String gender;
  DateTime date;
  String countryCode;
  String contactNumber;
  int followers;
  int following;
  String bio;

  UserSchema({
    required this.userId,
    required this.name,
    required this.profileName,
    required this.email,
    required this.password,
    required this.dob,
    required this.profileImage,
    required this.backgroundImage,
    required this.gender,
    required this.date,
    required this.countryCode,
    required this.contactNumber,
    required this.followers,
    required this.following,
    required this.bio,
  });

  UserSchema copyWith({
    String? userId,
    String? name,
    String? profileName,
    String? email,
    String? password,
    String? dob,
    String? profileImage,
    String? backgroundImage,
    String? gender,
    DateTime? date,
    String? countryCode,
    String? contactNumber,
    int? followers,
    int? following,
    String? bio,
  }) {
    return UserSchema(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      profileName: profileName ?? this.profileName,
      email: email ?? this.email,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      profileImage: profileImage ?? this.profileImage,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      gender: gender ?? this.gender,
      date: date ?? this.date,
      countryCode: countryCode ?? this.countryCode,
      contactNumber: contactNumber ?? this.contactNumber,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'profileName': profileName,
      'email': email,
      'password': password,
      'dob': dob,
      'profileImage': profileImage,
      'backgroundImage': backgroundImage,
      'gender': gender,
      'date': date.millisecondsSinceEpoch,
      'countryCode': countryCode,
      'contactNumber': contactNumber,
      'followers': followers,
      'following': following,
      'bio': bio,
    };
  }

  factory UserSchema.fromMap(Map<String, dynamic> map) {
    return UserSchema(
      userId: map['userId'] as String,
      name: map['name'] as String,
      profileName: map['profileName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      dob: map['dob'] as String,
      profileImage: map['profileImage'] as String,
      backgroundImage: map['backgroundImage'] as String,
      gender: map['gender'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      countryCode: map['countryCode'] as String,
      contactNumber: map['contactNumber'] as String,
      followers: map['followers'] as int,
      following: map['following'] as int,
      bio: map['bio'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSchema.fromJson(String source) =>
      UserSchema.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserSchema(userId: $userId, name: $name, profileName: $profileName, email: $email, password: $password, dob: $dob, profileImage: $profileImage, backgroundImage: $backgroundImage, gender: $gender, date: $date, countryCode: $countryCode, contactNumber: $contactNumber, followers: $followers, following: $following, bio: $bio)';
  }

  @override
  bool operator ==(covariant UserSchema other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.name == name &&
        other.profileName == profileName &&
        other.email == email &&
        other.password == password &&
        other.dob == dob &&
        other.profileImage == profileImage &&
        other.backgroundImage == backgroundImage &&
        other.gender == gender &&
        other.date == date &&
        other.countryCode == countryCode &&
        other.followers == followers &&
        other.following == following &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        profileName.hashCode ^
        email.hashCode ^
        password.hashCode ^
        dob.hashCode ^
        profileImage.hashCode ^
        backgroundImage.hashCode ^
        gender.hashCode ^
        date.hashCode ^
        countryCode.hashCode ^
        contactNumber.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        bio.hashCode;
  }
}
