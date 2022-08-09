import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

import 'package:todo/widgets/widget1.dart';

class mainscreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titlecontraller = TextEditingController();
  var timecontraller = TextEditingController();
  var datecontraller = TextEditingController();



  @override
  Widget build(BuildContext context) {
  return BlocProvider
    (
    create: (BuildContext context)=> AppCubit()..creatDB(),
    child: BlocConsumer<AppCubit,AppStates>(
        listener:(BuildContext context,AppStates state){
          if(state is inserttodb){

            Navigator.pop(context);

          }
        },
        builder:(BuildContext context,AppStates state){

          var cubit=AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("Todo"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbuttomshown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDB(title: titlecontraller.text, time: timecontraller.text, date: datecontraller.text);
                    timecontraller.clear();
                    titlecontraller.clear();
                    datecontraller.clear();
                    // print(datecontraller.text);
                    // insertToDB(
                    //     title: titlecontraller.text,
                    //     date: datecontraller.text,
                    //     time: timecontraller.text).then((value) {
                    //   getdata(database).then((value)  {
                    //
                    //     tasks=value;
                    //
                    //     // setState(() {
                    //     // print(tasks);
                    //     // Navigator.pop(context);
                    //     // isbuttomshown = false;
                    //     // iconbut = Icons.edit_outlined;
                    //     // });
                    //     //
                    //
                    //   });
                    //
                    // });

                  }
                }

                else {
                  scaffoldKey.currentState.showBottomSheet((context) => Form(
                    key:formKey,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        textForm(
                            name: 'Title',
                            maxLength:20 ,
                            controller: titlecontraller,
                            prefixIcon: Icons.title_rounded,
                            texttype: TextInputType.text,
                            validator:(String value) {
                              if (value.isEmpty) {
                                return ('Title must not be empty');
                              }
                              return null;

                            }
                        ),

                        textForm(
                            name: 'time',
                            controller: timecontraller,
                            prefixIcon: Icons.watch_later_outlined,
                            texttype: TextInputType.datetime,
                            ontap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                timecontraller.text = value.format(context);
                              });
                            },validator: (String value) {
                          if (value.isEmpty) {
                            return ('Time must not be empty');
                          }
                          return null;
                        }),
                        textForm(
                            name: 'date',
                            controller: datecontraller,
                            prefixIcon: Icons.date_range,
                            texttype: TextInputType.datetime,
                            ontap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-06-21'))
                                  .then((value) {
                                datecontraller.text =
                                    DateFormat.yMMMd().format(value);
                              });
                            },validator: (String value) {
                          if (value.isEmpty) {
                            return ('Date must not be empty');
                          }
                          return null;
                        }),
                      ],
                    ),
                  )).closed.then((value) {
                    cubit.changebuttom(icon: Icons.edit_outlined, buttonstate: false);

                  } );
                  cubit.changebuttom(icon: Icons.add, buttonstate: true);

                }
              },
              child: Icon(cubit.iconbut),
            ),
            body: state is getfromdbloading ? Center(child: CircularProgressIndicator()):cubit.screens[cubit.current],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.blue,
              currentIndex: cubit.current,
              onTap: (index) {
               cubit.changeindex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_rounded), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },

    ),
  );
  }

}

