import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociallogin/blocs/workout_cubit.dart';
import 'package:sociallogin/blocs/workouts_cubit.dart';
import 'package:sociallogin/helpers.dart';
import 'package:sociallogin/models/exercise.dart';
import 'package:sociallogin/models/workout.dart';
import 'package:sociallogin/screens/edit_exercise_screen.dart';
import 'package:sociallogin/states/workout_states.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocBuilder<WorkoutCubit, WorkoutStates>(
        builder: (context, state){
          WorkoutEditing workoutEditing = state as WorkoutEditing;
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: ((){
                  BlocProvider.of<WorkoutCubit>(context).goHome();
                }),
              ),
              title: InkWell(
                child: Text(workoutEditing.workout!.title!),
                onTap: ()=>showDialog(
                  context: context,
                  builder: (_){
                    final titleController = TextEditingController(text: workoutEditing.workout!.title);
                    return AlertDialog(
                      content: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Workout Title"
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: (){
                            if(titleController.text.isNotEmpty){
                              Navigator.pop(context);
                              Workout renamed = workoutEditing.workout!.copyWith(title: titleController.text);
                              /// Store data to bloc/cubit
                              BlocProvider.of<WorkoutsCubit>(context).saveWorkout(renamed, workoutEditing.index);
                              /// change the changed value everywhere it's used
                              BlocProvider.of<WorkoutCubit>(context).editWorkout(renamed, workoutEditing.index);
                            }
                          },
                          child: const Text("Rename"),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: workoutEditing.workout!.exercises!.length,
              itemBuilder: (context, index){
                Exercise exercise = workoutEditing.workout!.exercises![index];
                if(workoutEditing.exIndex == index){
                  return EditExerciseScreen(workout: workoutEditing.workout, index: workoutEditing.index, exIndex: workoutEditing.exIndex);
                } else {
                  return ListTile(
                    leading: Text(formatTime(exercise.prelude!, true)),
                    title: Text(exercise.title!),
                    trailing: Text(formatTime(exercise.duration!, true)),
                    onTap: ()=> BlocProvider.of<WorkoutCubit>(context)
                        .editExercise(index),
                  );
                }
              },
            )
          );
        },
      ),
      onWillPop: ()=> BlocProvider.of<WorkoutCubit>(context).goHome(),
    );
  }
}

