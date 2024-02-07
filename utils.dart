import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
showSnackBar(BuildContext context,String content)
{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(content),
      ),
   );
}
Future<Uint8List?>pickImage()async{
 FilePickerResult ? pickedImage=
             await FilePicker.platform.pickFiles(type: FileType.image);
 // FilePicker.platform.pickFiles(type: FileType.video);// for future we can add Video
    if(pickedImage!=null)
    {  if(kIsWeb)
     {
      return pickedImage.files.single.bytes;// for web version because  Following version gives output for mobile app only
     }
       return await File(pickedImage.files.single.path!).readAsBytes(); // File requires dart.io because of Input output Don't Use dart.HTML
      }
    return null;
}