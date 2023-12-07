// import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/utils/calories.dart';

part 'profile.g.dart';

@HiveType(typeId: 1)
class Profile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String gender;

  @HiveField(2)
  double weight;

  @HiveField(3)
  double height;

  @HiveField(4)
  int age;

  @HiveField(5)
  ActivityLevel activityLevel = CalorieCalculator.activityLevels.first;
  // double? bmi;
  @HiveField(6)
  double? bmr;

  @HiveField(7)
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
