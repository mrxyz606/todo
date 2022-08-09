import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/screens/archieve.dart';
import 'package:todo/screens/done.dart';
import 'package:todo/screens/tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int current = 0;
  Database database;

  List screens = [taskScreen(), doneScreen(), archievedScreen()];
  List titles = ['TaskScreen', 'DoneScreen', 'ArchievedScreen'];
  List<Map> Newtasks = [];
  List<Map> Donetasks = [];
  List<Map> ArchivedTasks = [];
  void changeindex(int index) {
    current = index;
    emit(NavBar());
  }

  void creatDB() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      print('database created success');
      await database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('there is an error!!!!$error');
      });
    }, onOpen: (database) {
      getdata(database);

      print('database opened success');
    }).then((value) {
      database = value;
      emit(creatdb());
    });
  }

  insertToDB({@required title, @required time, @required date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted success!!');
        getdata(database);
        emit(inserttodb());
      }).catchError((error) {
        print('error!!!!$error');
      });
      return null;
    });
  }

  void getdata(database) {

    ArchivedTasks=[];

    Donetasks=[];

    Newtasks=[];
    emit(getfromdbloading());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element["status" ]== 'new')
          Newtasks.add(element);
        else if (element["status" ]== "done")
          Donetasks.add(element);
        else if (element["status" ]== "archived")
          ArchivedTasks.add(element);

      });
      emit(getfromdb());
    });
  }

  void updatedatabase({var status, int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ',
        ['$status', '$id']).then((value) {
      emit(updatedb());
    });
  }

  void deletdatabase({@required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(deletdb());
      getdata(database);
    });
  }

  void changebuttom({@required IconData icon, @required bool buttonstate}) {
    isbuttomshown = buttonstate;
    iconbut = icon;
    emit(changebuttonstate());
  }

  bool isbuttomshown = false;
  var iconbut = Icons.edit_outlined;
}
