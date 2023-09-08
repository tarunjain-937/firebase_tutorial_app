import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial_app/UI/auth/verifyCodeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Text("Login with ",style: TextStyle(fontSize: 22,color: Colors.white),),
            Text("phone number",style: TextStyle(fontSize: 22,color: Colors.orange),),
          ],
        ),
      ),
      body:Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 100,),
              Text("Enter Phone Number",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              TextFormField(
                controller: phoneNumberController,
                obscureText: false,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                    hintText: "+1 2343456234",
                    hintStyle: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                    prefixIcon: const Icon(Icons.phone,color: Colors.black,size: 22,)
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Phone Number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      login();
                    }
                  },
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.only(left: 30,right: 30,top: 12,bottom: 12)),
                      backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                  child: loading ? const CircularProgressIndicator(color: Colors.white):const Text("Login",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black),)),
            ],
          ),
        ),
      ),
    );
  }

  void login(){
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text,
        verificationCompleted: (context){
        setState(() {
          loading = false;
        });
        },
        verificationFailed: (error){
        setState(() {
          loading = false;
        });
          Get.snackbar(error.toString(), "Enter correct Phone Number",
              snackPosition: SnackPosition.BOTTOM,
              titleText: Text(error.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
        },
        codeSent: (String? verificationId, int? token){
          setState(() {
            loading = false;
          });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return VerifyCodeScreen(verificationId: verificationId.toString(),);
        },));
        },
        codeAutoRetrievalTimeout: (error){
          setState(() {
            loading = false;
          });
          Get.snackbar(error.toString(), "verification code TimeOut",
              snackPosition: SnackPosition.BOTTOM,
              titleText: Text(error.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
        });
  }
}

