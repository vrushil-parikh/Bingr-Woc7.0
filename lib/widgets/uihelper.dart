import 'package:flutter/material.dart';
class UiHelper {

  static CustomeTextField(TextEditingController controller,String text,IconData iconData,bool toHide){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
      child: TextField(
        obscureText: toHide,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8)
          )
        ),
      ),
    );
  }
  static CustomeButton(VoidCallback voidCallBack,String text){
    return SizedBox(
        height: 50,width: 300,
      child: ElevatedButton(
        onPressed: (){
          voidCallBack();
        },
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20)
          ),style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
      )
    );
  }
  static CustomAlertBox(BuildContext context, String text){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);} , child: Text("ok",style: TextStyle(fontSize:20,)))
        ],
        title: Text(text),
      );
    });
  }

}