import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociallogin/models/workout.dart';
import 'package:sociallogin/states/workout_states.dart';

class WorkoutCubit extends Cubit<WorkoutStates>{
  WorkoutCubit():super(const WorkoutInitial());

  editWorkout(Workout workout, int index){
    return emit(WorkoutEditing(workout, index));
  }

  goHome(){
    emit(const WorkoutInitial());
  }
}