import 'package:flutter/material.dart';
import 'package:todo/cubit/cubit.dart';

Widget textForm({
  @required name,
  @required TextEditingController controller,
  @required prefixIcon,
  @required TextInputType texttype,
  var maxLength,
  Function ontap,
  Function validator

}) =>
    TextFormField(
      maxLength:maxLength ,
      controller: controller,
      keyboardType: texttype,
      validator: validator,onTap: ontap,
      onChanged:(value){
        print(value);
      },
      decoration: InputDecoration(
          labelText: name, prefixIcon: Icon(prefixIcon)),

    );



Widget Tasksrow(Map model,context,database) =>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deletdatabase(id: model["id"]);
  },
  child:   Padding(

    padding: const EdgeInsets.all(11.0),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

      Container(
        width: 260,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          CircleAvatar(radius: 50.0,

            child:Text(model['time']),),
SizedBox(width: 20,),

          Expanded(

            child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(model['title'],

                    style: TextStyle(fontSize: 25)),

                Text(model['date'],

                  style: TextStyle(color: Colors.blue,fontSize: 20),),



              ],),

          )
        ],),
      ),


      Container(

        child: Row(children: [
          IconButton(

              onPressed: (){

                AppCubit.get(context).updatedatabase(id:model["id"] ,status: "done");

                AppCubit.get(context).getdata(database);



              }, icon: Icon(Icons.check_circle_outline,size: 35,color: Colors.teal,)),

          IconButton(onPressed: (){

            AppCubit.get(context).updatedatabase(id:model["id"] ,status: "archived");

            AppCubit.get(context).getdata(database);

          }, icon: Icon(Icons.archive_outlined,size: 35,color: Colors.black26,))      ],),
      )

    ],),

  ),
);