// ignore_for_file: unused_local_variable, unused_label, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/common/widgets/custom_text_field.dart';
import 'package:gezify/presentation/auth/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  late String email,password;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text("Şimdi Kayıt Ol",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.black
            ),
            ),
            SizedBox(height: 20,),
            Text("Lütfen bilgileri doldurun ve hesap oluşturun.",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.grey.shade500
            )
            ),
            SizedBox(height: 40,),
            CustomTextField(
              hintext: "İsim",
              iconData: Icon(Icons.people)
              ),
            SizedBox(height: 10,),
            CustomTextField(hintext: "E-mail",
             iconData: Icon(Icons.mail),
             
             ),
             SizedBox(height: 10,),
            CustomTextField(hintext: "Şifre",
             iconData: Icon(Icons.lock),
             obsecureText: true,
             ),
             SizedBox(height: 10,),
             Padding(
              padding: EdgeInsets.only(right: 280),
              child: Text("Şifre 8 karakter içermelidir",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.grey.shade500
            )
            ), 
             ),
            SizedBox(height: 30,),
            SizedBox(
              width: 450,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Kayıt Ol",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.white
            ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
            SizedBox(height: 10),
            Text("Zaten hesabınız var mı?",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.grey.shade400
            )
            ),
            TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text("Giriş yap",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Colors.blue
                    )
                  ),
                ),
               ],
            ),
            Text("Veya bağlan",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.grey.shade400
            ),
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               
               children: [
                SizedBox(height: 50,),
                IconButton(onPressed: () {},
                 icon: Icon(Icons.alternate_email,color: Colors.lightBlue,size:30))
               ],
            )
          ],
        ),
    )
    );
  }
}
