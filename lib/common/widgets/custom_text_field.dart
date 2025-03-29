import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final bool obsecureText;
  final String hintext;
  final Icon iconData;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    this.obsecureText = false,
    required this.hintext,
    required this.iconData, 
    this.validator,
    this.controller,
    
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        validator: validator,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Colors.black
        ),
        decoration: InputDecoration(
          hintText: hintext,
          prefixIcon: iconData,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.black,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
             borderSide: BorderSide.none
          )  
        ),
       
      ),
    );
  } 
}