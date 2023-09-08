import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial_app/UI/FireStore/firestoreListScreen.dart';
import 'package:firebase_tutorial_app/UI/addPostScreen.dart';
import 'package:firebase_tutorial_app/UI/auth/SignIn_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();
  // we are fetching data from firebase table reference as "Post"
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home ",style: TextStyle(fontSize: 34,color: Colors.orange,fontWeight: FontWeight.bold),),
            Text("Screen",style: TextStyle(fontSize: 34,color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen(),));
            }).onError((error, stackTrace){
              Get.snackbar(error.toString(), "Enter correct Gmail account.",
                  snackPosition: SnackPosition.BOTTOM,
                  messageText: const Text("Enter correct Gmail account.",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
                  titleText: Text(error.toString(), style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
            });
          },
          tooltip: "Log Out",
          icon: const Icon(Icons.logout,size: 20,color: Colors.white,))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            //we are taking some text from user and storing it on the firebase Database
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddPostScreen();
            },));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add,color: Colors.orange,size: 42,)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // we are filtering the data stored in list
            TextFormField(
              controller: searchFilterController,
              onChanged: (String value){
                // when we type a single character also the UI have to change
                setState(() {});
              },
              decoration:const  InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderSide:BorderSide(width: 2)
                )
              ),
            ),
            SizedBox(height: 20,),
            Text("(Firebase Realtime database implementation)",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),

            // we are fetching real time data from firebase database
            Expanded(
              child: FirebaseAnimatedList(
                  query: databaseRef,
                  defaultChild: const Center(child: CircularProgressIndicator()),
                  itemBuilder: (context, snapshot, animation, index) {

                    final title = snapshot.child("title").value.toString();
                    if(searchFilterController.text.isEmpty){
                      // user is not searching anything
                      return ListTile(
                        title: Text(snapshot.child("title").value.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        subtitle: Text(snapshot.child("id").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert,size: 20,),
                            itemBuilder: (context) =>  [
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(leading: const Icon(Icons.edit,size: 20),
                                onTap: (){
                                    showMyDialog(title,snapshot.child("id").value.toString());
                                },
                                title: const Text("Edit",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),),
                              PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                  onTap: (){
                                    databaseRef.child(snapshot.child("id").value.toString()).remove();
                                     Navigator.pop(context);
                                    },
                                  leading: Icon(Icons.delete,size: 20),
                                  title: Text("Delete",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                ),),
                            ],),
                      );
                    }
                    else if(title.toLowerCase().contains(searchFilterController.text.toLowerCase())){
                      // user has search something
                      return ListTile(
                        title: Text(snapshot.child("title").value.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        subtitle: Text(snapshot.child("id").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert,size: 20,),
                          itemBuilder: (context) =>  [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(leading: const Icon(Icons.edit,size: 20),
                                onTap: (){
                                  showMyDialog(title,snapshot.child("id").value.toString());
                                },
                                title: const Text("Edit",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: (){
                                  databaseRef.child(snapshot.child("id").value.toString()).remove();
                                  Navigator.pop(context);
                                },
                                leading: Icon(Icons.delete,size: 20),
                                title: Text("Delete",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),),
                          ],),
                      );
                    }else{
                      return Container();
                    }

                  },),
            ),

           TextButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) {
               return FirestoreListScreen();
             },));
           },
               child: Text("Firestore implementation >",style:  TextStyle(fontWeight: FontWeight.w500,fontSize: 20),))
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async{
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update title"),
          content: TextFormField(
            controller: editController,
            decoration: InputDecoration(
              hintText: "New title",
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 2),
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            },
                child: const Text("Cancel",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
            ElevatedButton(onPressed: (){
              // we are updating the title from database
              databaseRef.child(id).update({
                "title" : editController.text.toString()
              }).then((value){
                Get.snackbar("", "",
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: const Text("Post updated", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
                Navigator.pop(context);
              }).onError((error, stackTrace){
                Get.snackbar(error.toString(), "",
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text(error.toString(), style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
                Navigator.pop(context);
              });
            },
                child: const Text("Update",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
          ],
        );
      },
    );
  }
}
