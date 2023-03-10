import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sociallogin/blocs/workout_cubit.dart';
import 'package:sociallogin/blocs/workouts_cubit.dart';
import 'package:sociallogin/screens/edit_workout_screen.dart';
import 'package:sociallogin/screens/home_page.dart';
import 'package:sociallogin/states/workout_states.dart';

/// 4:06:15

void main() async{
  // runApp(const WorkoutTime());
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(
          ()=> runApp(const WorkoutTime()),
    storage: storage
  );
  runApp(const WorkoutTime());
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Workouts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)),
        )
      ),
      // home: BlocProvider<WorkoutsCubit>(
      //   create: (BuildContext context) {
      //     WorkoutsCubit workoutsCubit = WorkoutsCubit();
      //     if(workoutsCubit.state.isEmpty){
      //       workoutsCubit.getWorkouts();
      //     }
      //     return workoutsCubit;
      //   },
      //   child: BlocBuilder<WorkoutsCubit, List<Workout>>(
      //     builder: (context, state) {
      //       return const HomePage();
      //     }
      //   ),
      // ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutsCubit>(
            create: (BuildContext context) {
              WorkoutsCubit workoutsCubit = WorkoutsCubit();
              if(workoutsCubit.state.isEmpty){
                workoutsCubit.getWorkouts();
              }
              return workoutsCubit;
            },
          ),
          BlocProvider<WorkoutCubit>(
            create: (BuildContext context)=> WorkoutCubit()
          ),
        ],
        child: BlocBuilder<WorkoutCubit, WorkoutStates>(
          builder: (context, state){
            if(state is WorkoutInitial){
              return const HomePage();
            } else if(state is WorkoutEditing){
              return const EditWorkoutScreen();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
