import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/widgets/widget1.dart';

class doneScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context,AppStates state){},
      builder:(BuildContext context,AppStates state){
        var cubit=AppCubit.get(context);
        var tasks=AppCubit.get(context).Donetasks;

        if(tasks.length>0){return ListView.separated(

            itemBuilder: (context,index) => Tasksrow(cubit.Donetasks[index],context,cubit.database),
            separatorBuilder:(context,index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
            itemCount: cubit.Donetasks.length);}
        else{return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_rounded, color: Colors.black26,size: 100,),
              SizedBox(height: 0,),
              Text(
                "u didn't do any task",
                style: TextStyle(color: Colors.black26,fontSize: 30),
              )
            ],
          ),
        );}


      } ,

    );
  }
}


