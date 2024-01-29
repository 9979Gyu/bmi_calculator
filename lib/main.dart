import 'package:flutter/material.dart';

import 'Model/bmi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String gender = "Male", bmiStatus = "", displayText = "";
  double bmiValue = 0.0;
  BMI? getBMI;

  // TextEditingController
  TextEditingController fullnameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bmiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getBMI = await BMI.getLastInserted();

      if(getBMI != null){
        setState(() {
          gender = getBMI!.gender;
          fullnameController.text = getBMI!.username;
          heightController.text = getBMI!.height.toStringAsFixed(1);
          weightController.text = getBMI!.weight.toStringAsFixed(1);
          bmiController.text =
              calculateBMI(getBMI!.height, getBMI!.weight).toStringAsFixed(2);
          bmiStatus = setBMIStatus();
          displayText = "$gender. $bmiStatus";
        });
      }
    });
  }

  // function to calculate BMI
  double calculateBMI(double height, double weight){
    double heightToMeter = height / 100;
    return weight/(heightToMeter * heightToMeter);
  }

  String setBMIStatus(){
    double height = double.parse(heightController.text.trim());
    double weight = double.parse(weightController.text.trim());
    bmiValue = calculateBMI(height, weight);

    if(gender == "Male"){
      if(bmiValue < 18.5){
        return "Underweight. Careful during strong wind!";
      }
      else if(bmiValue >= 18.5 && bmiValue <= 24.9){
        return "That's ideal! Please maintain";
      }
      else if(bmiValue >= 25 && bmiValue <= 29.9){
        return "Overweight! Work out please";
      }
      else {
        //   bmiValue >=30
        return "Whoa Obese! Dangerous mate!";
      }
    }
    else{
      if(bmiValue < 16){
        return "Underweight. Careful during strong wind!";
      }
      else if(bmiValue >= 16 && bmiValue < 22){
        return "That's ideal! Please maintain";
      }
      else if(bmiValue >= 22 && bmiValue < 27){
        return "Overweight! Work out please";
      }
      else {
        //   bmiValue >=30
        return "Whoa Obese! Dangerous mate!";
      }
    }
  }

  Future<void> _addBMI() async {
    String username = fullnameController.text.trim();
    String height = heightController.text.trim();
    String weight = weightController.text.trim();

    bmiStatus = setBMIStatus();

    if(username != "" && height != "" && weight != "" &&
        bmiStatus != "" && gender != ""){
      BMI bmi = BMI(username, gender, bmiStatus,
          double.parse(weight), double.parse(height));

      if(await bmi.save()){
        getBMI = await BMI.getLastInserted();
        setState(() {
          bmiController.text =
              calculateBMI(
                  double.parse(height), double.parse(weight)
              ).toStringAsFixed(2);
          displayText = "$gender. $bmiStatus";
        });
      }
      else{
        print("Failed to save data");
      }
    }
    else{
      print("Please filled all fields");
    }
  }

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullnameController,
              decoration: InputDecoration(
                hintText: "Your Fullname",
              ),
            ),
            SizedBox(height: 8,),
            TextField(
              controller: heightController,
              decoration: InputDecoration(
                hintText: "height in cm; 170",
              ),
            ),
            SizedBox(height: 8,),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                hintText: "Weight in KG",
              ),
            ),
            SizedBox(height: 8,),
            TextField(
              controller: bmiController,
              decoration: InputDecoration(
                hintText: "BMI Value",
              ),
              readOnly: true,
              enabled: false,
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    value: checked,
                    title: Text("this"),
                    subtitle: Icon(Icons.add),
                    checkColor: Colors.black,
                    onChanged: (value) {
                      setState((){
                        checked = value!;
                      });
                    },
                  
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                      title: Text("Male"),
                      value: "Male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                      title: Text("Female"),
                      value: "Female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            ElevatedButton(
              onPressed: _addBMI,
              child: Text("Calculate BMI and Save"),
            ),
            SizedBox(height: 8,),
            Text(
              "$displayText",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),

            ),
          ],
        ),
      ),
    );
  }
}
