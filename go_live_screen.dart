import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:talkme/broadcast_Screen.dart';
import 'package:talkme/cust_text.dart';
import 'package:talkme/firestore_methods.dart';
import 'package:talkme/reponsive.dart';
import 'package:talkme/utils/colours.dart';
import 'package:talkme/widgets/cust_button.dart';
import 'utils.dart';
class GoliveScreen extends StatefulWidget {
  const GoliveScreen({Key?key}):super(key:key);
  @override
  State<GoliveScreen> createState() => _GoliveScreenState();
}
class _GoliveScreenState extends State<GoliveScreen> {
  final TextEditingController _titleController=TextEditingController();
  Uint8List?image;
  @override
  void dispose()
  {  _titleController.dispose();
    super.dispose();
  }
  goLiveStream()
  async{
    String channelId=await FirestoreMethods().startLiveStream(context, _titleController.text, image);
    if(channelId.isNotEmpty)
      {
        showSnackBar(context, 'Live Strame Started Successfullly');
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> BroadcastScreen(
          isBroadcaster: true,
          channelId: channelId,
        ),
        ),
        );
      }
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child:
    Responsive(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: ()async{
                      Uint8List? pickedImage=await pickImage();
                      if(pickedImage!=null)
                        {
                          setState(() {
                            image=pickedImage;
                          });
                        }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 20.0
                      ),
                      child:image!=null?SizedBox(height: 400,child:Image.memory(image!),):DottedBorder(
                       borderType: BorderType.RRect,
                        radius: const Radius.circular(3.0),
                        dashPattern: const [10,4],
                        strokeCap: StrokeCap.round,
                        color: Colors.purple,
                        child:Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: backgroundColour.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open,color: Colors.purple,size: 40
                                ),
                                const SizedBox(height: 15),
                                Text('Select your Thumbnail',style: TextStyle(fontSize: 15,color:Colors.grey.shade400,
                                    ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                   Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title',style: TextStyle(fontWeight: FontWeight.bold
                      ),
                      ),
                      Padding(padding: const EdgeInsets.symmetric(vertical: 8
                      ),
                        child: CustomTextField(controller: _titleController
                        ),
                      )
                    ],
                  )
                ],
              ),
            Padding(padding: const EdgeInsets.only(bottom: 10),child: CustomButton(text:'Go live',onTap:goLiveStream,// never put() it show erro JAY MATA Di
                 ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
