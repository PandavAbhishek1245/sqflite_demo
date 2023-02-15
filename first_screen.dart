import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_demo/first_screen_controller.dart';
import 'package:sqflite_demo/todo_model.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List items = List.generate(10, (index) => index);
  final _formkey=GlobalKey<FormState>();

  var firstscreenController = Get.put(FirstScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQFLITE"),
      ),

      body: Obx(() => ListView.separated(
        // itemCount: items.length,
        itemCount: firstscreenController.todoList.length,
        itemBuilder: (context,index){
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.7),
                  offset: Offset(0.5,0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),

            child: Dismissible(
              // direction: DismissDirection.vertical,
              background: Container(
                color: Colors.green,
                child: Icon(Icons.cancel),
              ),

              key: ValueKey(items[index]),
              onDismissed: ( direction) {
                 firstscreenController.deleteTodo(firstscreenController.todoList[index].id);
              },

              child: ListTile(
                trailing: GestureDetector(
                    onTap: () async {
                     await buildShowModalBottomSheet(context,isUpdate:true,id:firstscreenController.todoList[index].id);
                     nameController.text=firstscreenController.todoList[index].name!;
                     taskController.text=firstscreenController.todoList[index].task!;
                     descController.text=firstscreenController.todoList[index].desc!;
                    },
                    child: Icon(Icons.edit,color: Colors.blue,)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${firstscreenController.todoList[index].id}"),
                    Text(
                      // "Name:"
                        "${firstscreenController.todoList[index].name}"
                    ),
                    Text(
                      // "Email:"
                        "${firstscreenController.todoList[index].task}"
                    ),
                    Text(
                      // "Password:"
                        "${firstscreenController.todoList[index].desc}"
                    ),
                  ],
                ),
              ),
            ),
          );
        }, separatorBuilder: (context,index){return SizedBox(height: 10,);},),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          buildShowModalBottomSheet(context,isUpdate: false);
        },
        tooltip: 'Floatingaction button',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, {required bool isUpdate, String? id}) {
    return showModalBottomSheet(context: context,
          builder:(BuildContext context){
          return SingleChildScrollView(
            child: Container(
              height: 550,
              // color: Colors.green,
             child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Form(
                 key: _formkey,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     SizedBox(height: 30,),
                    TextFormField(
                      controller: nameController,
                      validator: (a){
                        if(a!.isEmpty){
                          return "enter name";
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                         hintText: "Enter name",
                         labelText: "name",
                         border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                        )
                      ),
                    ),

                     SizedBox(height: 30,),

                     TextFormField(
                       controller: taskController,
                       validator: (a){
                         if(a!.isEmpty){
                           return 'enter task ';
                         }
                       },
                       decoration: InputDecoration(
                           isDense: true,
                           hintText: "Enter Task",
                           labelText: "task",
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           )
                       ),
                     ),

                     SizedBox(height: 30,),

                     TextFormField(
                       controller: descController,
                       validator: (a){
                         if(a!.isEmpty){
                           return "enter description";
                         }
                       },
                       decoration: InputDecoration(
                           isDense: true,
                           filled: true,
                           fillColor: Colors.white,
                           hintText: "Enter description",
                           labelText: "description",
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           )
                       ),
                     ),

                     SizedBox(height: 10,),

                     ElevatedButton(
                       onPressed: (){
                         if(_formkey.currentState!.validate()){
                           // print("done");
                           if(isUpdate==false){
                             firstscreenController.addData(name: nameController.text, task: taskController.text, desc: descController.text);
                           }
                           else{
                            firstscreenController.upadateTodo(TodoModel(id: id!,name: nameController.text,task: taskController.text,desc: descController.text));
                           }

                           Navigator.pop(context);
                           nameController.clear();
                           taskController.clear();
                           descController.clear();
                         }
                       }, child: Text("save"),
                     ),
                   ],
                 ),
               ),
             ),
            ),
          );
        },
    );
  }
}
