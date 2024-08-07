import 'package:flutter/material.dart';

class Mytextcontroller extends StatelessWidget {
  TextEditingController cntroller = TextEditingController();
  Mytextcontroller({super.key,required this.cntroller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: cntroller,
      
      
      decoration: InputDecoration(
        
        hintText: "Enter City Name",
        border: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(12),
          
        )
      ),
    );
  }
}
