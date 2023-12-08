import 'package:my_fitness_app/model/profile.dart';

class CalorieCalculator {
  // Constants
  static const int caloriesPerKg = 7700;
  static final List<ActivityLevel> activityLevels = [
    ActivityLevel(
        coefficient: 1.2, description: 'Sedentary (little or no exercise)'),
    ActivityLevel(
        coefficient: 1.375,
        description: 'Lightly active (light exercise/sports 1-3 days a week)'),
    ActivityLevel(
        coefficient: 1.55,
        description:
            'Moderately active (moderate exercise/sports 3-5 days a week)'),
    ActivityLevel(
        coefficient: 1.725,
        description: 'Very active (hard exercise/sports 6-7 days a week)'),
    ActivityLevel(
        coefficient: 1.9,
        description:
            'Extra active (very hard exercise/sports & a physical job)'),
  ];

  // Calculate BMR (Harris-Benedict equation)
  static double calculateBMR(
      double weight, double height, int age, String gender) {
    if (gender == "male") {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  // Calculate daily calorie needs
  static double calculateDailyCalories(
      double bmr, ActivityLevel activityLevel) {
    return bmr * activityLevel.coefficient;
  }

  // Calculate calorie intake for weight loss
  static double calculateCaloriesForWeightLoss(
      double dailyCalories, double kgToLosePerWeek) {
    double weeklyDeficit = kgToLosePerWeek * caloriesPerKg;
    double dailyDeficit = weeklyDeficit / 7;
    return dailyCalories - dailyDeficit;
  }
}

// class ActivityLevel {
//   String description;
//   double coefficient;

//   ActivityLevel({required this.description, required this.coefficient});
// }
