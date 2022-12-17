import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociallogin/models/exercise.dart';
import 'package:sociallogin/models/workout.dart';

class WorkoutsCubit extends Cubit<List<Workout>>{
  WorkoutsCubit():super([]);

  getWorkouts() async {
    final List<Workout> workouts = [];
    
    final workoutsJson = jsonDecode(await rootBundle.loadString("assets/workouts.json"));
    for(var el in (workoutsJson as Iterable)){
      workouts.add(Workout.fromJson(el));
    }
    emit(workouts);
  }
  
  saveWorkout(Workout workout, int index){
    Workout newWorkout = Workout(title: workout.title, exercises: []);
    int exIndex = 0;
    int startTime = 0;
    
    for(var ex in workout.exercises!){
      newWorkout.exercises!.add(
        Exercise(
          title: ex.title,
          prelude: ex.prelude,
          duration: ex.duration,
          index: ex.index,
          startTime: ex.startTime
        ),
      );
      exIndex++;
      startTime += ex.prelude! + ex.duration!;
    }
    state[index] = newWorkout;
    print("...I've  ${state.length} states");
    ///... means get everything in the list
    emit([...state]);
  }
}