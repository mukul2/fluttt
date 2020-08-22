class LoginResponse {
  bool status;
  String message;
  String accessToken;
  UserInfo userInfo;

  LoginResponse({this.status, this.message, this.accessToken, this.userInfo});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accessToken = json['access_token'];
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
    return data;
  }
}

class UserInfo {
  int id;
  int status;
  int home_visits;
  String name;
  String designationTitle;
  int department;
  String userType;
  String photo;
  String password;
  String email;
  String phone;

  String createdAt;
  String updatedAt;

  UserInfo(
      {this.id,
        this.status,
        this.home_visits,
        this.name,
        this.designationTitle,
        this.department,
        this.userType,
        this.photo,
        this.password,
        this.email,
        this.phone,

        this.createdAt,
        this.updatedAt});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    home_visits = json['home_visits'];
    name = json['name'];
    designationTitle = json['designation_title'];
    department = json['department'];
    userType = json['user_type'];
    photo = json['photo'];
    password = json['password'];
    email = json['email'];
    phone = json['phone'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['home_visits'] = this.home_visits;
    data['name'] = this.name;
    data['designation_title'] = this.designationTitle;
    data['department'] = this.department;
    data['user_type'] = this.userType;
    data['photo'] = this.photo;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phone'] = this.phone;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}