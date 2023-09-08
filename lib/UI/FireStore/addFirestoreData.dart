import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({Key? key}) : super(key: key);

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final postController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // we are defining a firestor e reference as "firestoreRef" and a collection as "users"
  final fireStoreRef = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add post to ",style: TextStyle(fontSize: 25,color: Colors.orange,fontWeight: FontWeight.bold),),
            Text("Firestore",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black,width: 5)
                  ),
                  hintText: "What is in your mind?",
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter some Post";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    addPost();
                  }
                },
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 30,right: 30,top: 12,bottom: 12)),
                    backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                child: loading ? const CircularProgressIndicator(color: Colors.white):const Text("Add",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),))
          ],
        ),
      ),
    );
  }

  void addPost(){
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    fireStoreRef.doc(id).set({
      "title" : postController.text.toString(),
      "id" : id
    }).then((value){
      setState(() {
        loading = false;
      });
      Get.snackbar("", "",
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text("Post Added", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
      Navigator.pop(context);
    }).onError((error, stackTrace){
      setState(() {
        loading = false;
      });
      Get.snackbar(error.toString(), "",
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(error.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
      Navigator.pop(context);
    });
  }
}
