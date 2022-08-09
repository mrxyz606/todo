import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/widgets/widget1.dart';

class taskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        var tasks = AppCubit.get(context).Newtasks;

        if (tasks.length > 0) {
          return ListView.separated(
              itemBuilder: (context, index) =>
                  Tasksrow(cubit.Newtasks[index], context, cubit.database),
              separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey,
                  ),
              itemCount: cubit.Newtasks.length);
        } else {
          return Center(
            child: Column(
mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.menu_rounded, color: Colors.black26,size: 100,),
                SizedBox(height: 0,),
                Text(
                  "Add some tasks",
                  style: TextStyle(color: Colors.black26,fontSize: 30),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
