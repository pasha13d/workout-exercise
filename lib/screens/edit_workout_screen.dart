import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociallogin/blocs/workout_cubit.dart';
import 'package:sociallogin/helpers.dart';
import 'package:sociallogin/models/exercise.dart';
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
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: workoutEditing.workout!.exercises!.length,
              itemBuilder: (context, index){
                Exercise exercise = workoutEditing.workout!.exercises![index];
                return ListTile(
                  leading: Text(formatTime(exercise.prelude!, true)),
                  title: Text(exercise.title!),
                  trailing: Text(formatTime(exercise.duration!, true)),
                );
              },
            )
          );
        },
      ),
      onWillPop: ()=> BlocProvider.of<WorkoutCubit>(context).goHome(),
    );
  }
}
