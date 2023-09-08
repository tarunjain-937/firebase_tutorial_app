import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial_app/UI/HomePage.dart';
import 'package:firebase_tutorial_app/UI/auth/Forgot_Password_Screen.dart';
import 'package:firebase_tutorial_app/UI/auth/SignUp_Screen.dart';
import 'package:firebase_tutorial_app/UI/auth/loginWithPhoneNumberScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false; /// initial loading will be false
  final _auth = FirebaseAuth.instance;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Firebase ",style: TextStyle(fontSize: 34,color: Colors.orange,fontWeight: FontWeight.bold),),
            Text("Integration",style: TextStyle(fontSize: 34,color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 38,color:Colors.black)),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                              hintText: "Enter Email",
                              hintStyle: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                              prefixIcon: const Icon(Icons.alternate_email,color: Colors.black,size: 25,)
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(width: 2)),
                              hintText: "Enter Password",
                              hintStyle: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                              prefixIcon: const Icon(Icons.password,color: Colors.black,size: 25,)
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter password";
                            }
                            return null;
                          },
                        ),

                        //=================================================================================
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return forgotPasswordScreen();
                          },));
                        }, child: const Text("Forgot Password ?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                        //===================================================================================
                      ],
                    )
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      login();
                    }
                  },
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.only(left: 30,right: 30,top: 12,bottom: 12)),
                      backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                  child: loading ? const CircularProgressIndicator(color: Colors.white):const Text("Sign In",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),)),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    },));
                  }, child: const Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),))
                ],
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  // login with phone number method
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return LoginWithPhoneNumber();
                  },));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black,width: 2)
                  ),
                  child: Center(child: Text("Login with Phone Number", style: TextStyle(fontWeight: FontWeight.w500,fontSize:18),)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      /// if SignIn is Successful then Navigate to MyHomePage()

      debugPrint(value.user!.email.toString());// if user login successfully then this will give the user info

      setState(() {
        loading = false;
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      },));
    }).onError((error, stackTrace){
      /// if SignIn is UnSuccessful then show erroe on Snack Bar
      setState(() {
        loading = false;
      });
      Get.snackbar(error.toString(), "Enter correct Gmail account.",
      snackPosition: SnackPosition.BOTTOM,
      messageText: Text("Enter correct Gmail account.",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
      titleText: Text(error.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),));
    });
  }
}