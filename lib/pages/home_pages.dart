import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/heat_map.dart';
import '../data/workout_data.dart';
import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //Text Controller
  final newWorkoutNameController = TextEditingController();
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          // Save Butoon
          MaterialButton(
            onPressed: save,
            child: Text("Save"),
          ),

          // cancel Button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  // Go to Workout Page
  void GoToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          workoutName: workoutName,
        ),
      ),
    );
  }

  // save Workout
  void save() {
    // get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workoutData list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel workout
  void cancel() {
    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  //clear controller
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[250],
          appBar: AppBar(
            title: const Text("Workout Tracker"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              // HEAT MAP
              MyHeatMap(
                  datasets: value.heatMapDataSet,
                  startDateYYYYMMDD: value.getStartDate()),

              // WORKOUT LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(value.getWorkoutList()[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () =>
                        GoToWorkoutPage(value.getWorkoutList()[index].name),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
