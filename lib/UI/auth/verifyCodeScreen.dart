import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial_app/UI/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final otpCodeController = TextEditingController();
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
            Text("Verify ",style: TextStyle(fontSize: 22,color: Colors.white),),
            Text("OTP Code",style: TextStyle(fontSize: 22,color: Colors.orange),),
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
              Text("Enter 6 digit OTP code",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              TextFormField(
                controller: otpCodeController,
                obscureText: false,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                    hintText: "235 910",
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
                  child: loading ? const CircularProgressIndicator(color: Colors.white):const Text("Verify",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black),)),
            ],
          ),
        ),
      ),
    );
  }

  void login()async{
     final credentials = PhoneAuthProvider.credential(
         verificationId: widget.verificationId,
         smsCode: otpCodeController.text.toString());
     try{
       await _auth.signInWithCredential(credentials);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
         return HomePage();
       },));
     }catch(error){
       setState(() {
         loading = true;
       });

       Get.snackbar(error.toString(), "Try again",
           titleText: Text(error.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
           snackPosition: SnackPosition.BOTTOM,
       );
     }
  }
}
