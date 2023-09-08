import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class forgotPasswordScreen extends StatefulWidget {
  const forgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<forgotPasswordScreen> createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading =  false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Firebase ",style: TextStyle(fontSize: 32,color: Colors.orange,fontWeight: FontWeight.bold),),
            Text("Integration",style: TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 3,color: Colors.black)
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter email";
                  }
                  else return null;
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                      setState(() {
                        loading = false;
                      });
                      Get.snackbar("", "",
                          snackPosition: SnackPosition.BOTTOM,
                          messageText: Text("Forgot password email is send.",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
                          titleText: Text("Email send to ${emailController.text.toString()}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
                         Navigator.pop(context);
                    }).onError((error, stackTrace){
                      setState(() {
                        loading = false;
                      });
                      Get.snackbar(error.toString(), "Enter correct Gmail account.",
                          snackPosition: SnackPosition.BOTTOM,
                          messageText: Text("Enter correct Gmail account.",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
                          titleText: Text(error.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
                    });
                  }
                },
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 30,right: 30,top: 12,bottom: 12)),
                    backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                child: loading ? const CircularProgressIndicator(color: Colors.white):const Text("Forgot Password",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),)),
          ],
        ),
      )
    );
  }
}
