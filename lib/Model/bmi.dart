import '../Controller/sqlite_db.dart';

class BMI{
  static const String tableName = "bmi";
  String username, gender, status;
  double weight, height;

  BMI(this.username, this.gender, this.status, this.weight, this.height);

  BMI.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        gender = json['gender'] as String,
        status = json['bmi_status'] as String,
        weight = json['weight'] as dynamic,
        height = json['height'] as dynamic;

  Map<String, dynamic> toJson() =>
      {'username': username,
        'gender': gender,
        'bmi_status': status,
        'weight': weight,
        'height': height
      };

  Future<bool> save() async {
    await SQLiteDB().insert(tableName, toJson());

    if(await SQLiteDB().insert(tableName, toJson()) != 0){
      return true;
    }
    else{
      return false;
    }
  }

  static Future<BMI> getLastInserted() async {
    BMI bmi;
    Map<String, dynamic> lastBMI = await SQLiteDB().getLast(tableName);
    bmi = BMI.fromJson(lastBMI);
    return bmi;
  }
}