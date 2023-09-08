import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial_app/UI/FireStore/addFirestoreData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final editController = TextEditingController();
  // we are making a "fireStoreRef" reference as collection "users" from where we are fetching data form firestore
  final fireStoreRef = FirebaseFirestore.instance.collection("users").snapshots();
  final collectionReference = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Firestore List ",style: TextStyle(fontSize: 30,color: Colors.orange,fontWeight: FontWeight.bold),),
            Text("Screen",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            //we are taking some text from user and storing it on the firebase Database
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddFirestoreData();
            },));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add,color: Colors.orange,size: 42,)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: fireStoreRef,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return Text("Some error occured");
                }
                return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        String title = snapshot.data!.docs[index]["title"].toString();
                        String id = snapshot.data!.docs[index]["id"].toString();
                        return ListTile(
                            title: Text(title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        subtitle: Text(id, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                        trailing: PopupMenuButton(
                          child: Icon(Icons.more_vert,size: 20,),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(leading: const Icon(Icons.edit,size: 20),
                                onTap: (){
                                 showMyDialog(title,id);
                                },
                                title: const Text("Edit",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: (){
                                 collectionReference.doc(id).delete();
                                 Navigator.pop(context);
                                },
                                leading: Icon(Icons.delete,size: 20),
                                title: Text("Delete",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),),
                          ]),);
                      },)
                );
            },),
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
              collectionReference.doc(id).update({
                "title" : editController.text.toString()
              }).then((value){
                // updated
                Get.snackbar("", "",
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: const Text("Post updated", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
                Navigator.pop(context);
              }).onError((error, stackTrace){
                // error occured
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
