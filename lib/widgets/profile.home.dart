import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_fitness_app/model/profile.dart';
import 'package:my_fitness_app/utils/calories.dart';

class ProfileDialog extends StatefulWidget {
  ProfileDialog({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController ageFieldController = TextEditingController();
  final TextEditingController weightFieldController = TextEditingController();
  final TextEditingController heightFieldController = TextEditingController();
  ActivityLevel selectedActivityLevel = CalorieCalculator.activityLevels.first;
  final genders = ['male', 'female'];
  String selectedGender = 'male';

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  Future<bool> saveProfile() async {
    bool validationResult = widget.formKey.currentState!.validate();
    if (validationResult) {
      Box<Profile> profileBox = Hive.box('profileBox');
      Profile? existingUser = profileBox.get('user');
      // print('''
      //           name: ${widget.nameFieldController.text},
      //           gender: ${widget.selectedGender},
      //           age: ${int.parse(widget.ageFieldController.text)},
      //           height: ${double.parse(widget.heightFieldController.text)},
      //           weight: ${double.parse(widget.weightFieldController.text)},
      //           activityLevel: ${widget.selectedActivityLevel.coefficient}: ${widget.selectedActivityLevel.description}
      //           ''');
      if (existingUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully Created User.'),
          backgroundColor: Colors.green,
        ));
        await profileBox.put(
            'user',
            Profile(
                name: widget.nameFieldController.text,
                gender: widget.selectedGender,
                age: int.parse(widget.ageFieldController.text),
                height: double.parse(widget.heightFieldController.text),
                weight: double.parse(widget.weightFieldController.text),
                activityLevel: widget.selectedActivityLevel));
      } else {
        existingUser.name = widget.nameFieldController.text;
        existingUser.age = int.parse(widget.ageFieldController.text);
        existingUser.gender = widget.selectedGender;
        existingUser.height = double.parse(widget.heightFieldController.text);
        existingUser.weight = double.parse(widget.weightFieldController.text);
        existingUser.activityLevel = widget.selectedActivityLevel;

        existingUser.recalculate();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully Updated User.'),
          backgroundColor: Colors.green,
        ));
        await existingUser.save();
      }
    }
    return validationResult;
  }

  @override
  void initState() {
    Box<Profile> profileBox = Hive.box('profileBox');
    Profile? existingUser = profileBox.get('user');
    if (existingUser != null) {
      widget.nameFieldController.text = existingUser.name;
      widget.ageFieldController.text = existingUser.age.toString();
      widget.selectedGender = existingUser.gender;
      widget.heightFieldController.text = existingUser.height.toString();
      widget.weightFieldController.text = existingUser.weight.toString();
      widget.selectedActivityLevel = existingUser.activityLevel;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Profile'),
      backgroundColor: Colors.green[50],
      content: Form(
        key: widget.formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name:'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "name cannot be empty.";
                  }
                  return null;
                },
                controller: widget.nameFieldController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age:'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Value can't be empty.";
                  }
                  if (int.tryParse(value) is! int) {
                    return "Value must be a number.";
                  }
                  return null;
                },
                controller: widget.ageFieldController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Height (cm):'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Value can't be empty.";
                  }
                  if (double.tryParse(value) is! double) {
                    return "Value must be a number.";
                  }
                  return null;
                },
                controller: widget.heightFieldController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Weight (kg):'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Value can't be empty.";
                  }
                  if (double.tryParse(value) is! double) {
                    return "Value must be a number.";
                  }
                  return null;
                },
                controller: widget.weightFieldController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Gender'),
                    RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'male',
                        groupValue: widget.selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            widget.selectedGender = value ?? 'male';
                          });
                        }),
                    RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'female',
                        groupValue: widget.selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            widget.selectedGender = value ?? 'female';
                          });
                        }),
                  ],
                ),
              ),
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return DropdownMenu(
                  width: constraints.maxWidth,
                  label: const Text('Activity Level:'),
                  initialSelection: widget.selectedActivityLevel.coefficient,
                  onSelected: (double? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      widget.selectedActivityLevel =
                          CalorieCalculator.activityLevels.firstWhere(
                              (element) => element.coefficient == value);
                    });
                  },
                  dropdownMenuEntries: CalorieCalculator.activityLevels
                      .map<DropdownMenuEntry<double>>(
                          (ActivityLevel activityLevel) {
                    return DropdownMenuEntry<double>(
                        value: activityLevel.coefficient,
                        label: activityLevel.description);
                  }).toList(),
                );
              })
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () async {
              if (await saveProfile()) Navigator.of(context).pop();
            },
            child: const Text('Save')),
      ],
    );
  }
}
