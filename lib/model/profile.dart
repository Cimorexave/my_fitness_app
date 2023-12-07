// import 'package:hive/hive.dart';
import 'package:my_fitness_app/utils/calories.dart';

class Profile {
  String name;
  String gender;
  double weight;
  double height;
  int age;
  ActivityLevel activityLevel = CalorieCalculator.activityLevels.first;
  // double? bmi;
  double? bmr;
  double? dailyCalories;

  Profile(
      {required this.name,
      required this.gender,
      required this.age,
      required this.weight,
      required this.height,
      required this.activityLevel}) {
    double calculatedBmr =
        CalorieCalculator.calculateBMR(weight, height, age, gender);
    bmr = calculatedBmr;
    dailyCalories =
        CalorieCalculator.calculateDailyCalories(calculatedBmr, activityLevel);
  }

  double calculateCaloriesForWeightLoss(
          double dailyCalories, double kgToLosePerWeek) =>
      CalorieCalculator.calculateCaloriesForWeightLoss(
          dailyCalories, kgToLosePerWeek);
}
