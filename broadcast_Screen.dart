import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:talkme/HomeScreen.dart';
import 'package:talkme/firestore_methods.dart';
import 'package:talkme/responsive_layout.dart';
import 'package:talkme/user_provider.dart';
import 'package:talkme/widgets/cust_button.dart';
import 'chat.dart';
import 'config/appid.dart';
 import 'package:http/http.dart' as http;
class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  const BroadcastScreen({
    Key?key,
    required this.isBroadcaster,
    required this.channelId
  }):super(key:key);
  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
late final RtcEngine _engine;
List<int>remoteUid=[];
bool switchCamera=true;
bool isMuted=false;
bool isScreenSharing=false;
@override
  void initState() {
    super.initState();
    _initEngine();
  }
  void _initEngine() async {
   _engine=await RtcEngine.createWithContext(RtcEngineContext(appId));
  _addListeners();
  await _engine.enableVideo();
  await _engine.startPreview();
  await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
  if(widget.isBroadcaster)
  {
  _engine.setClientRole(ClientRole.Broadcaster);
  }else{
    _engine.setClientRole(ClientRole.Audience);
  }
_joinChannel();
  }
  
   String baseUrl="";// Add your own BaseUrl
  String ? token;
  Future<void>getToken() async{
   //http.get(Url.parse(baseUrl));
   final res=await http.get(Uri.parse(baseUrl +'/rtc/'+widget.channelId+'publisher/userAccount'+Provider.of<UserProvider>(context,listen: false).user.uid+'/'
   )
   );
   if(res.statusCode==200)
     {
       setState(() {
         token=res.body;
         token=jsonDecode(token!)['rtcToken'];
       });
     }
   else{
     debugPrint('Failed to fetch token');
   }
  }
  void  _addListeners() {
  _engine.setEventHandler(RtcEngineEventHandler(
    joinChannelSuccess: (channeld,uid,elapsed)
        {
          debugPrint('JoinChannelSuccess $channeld $uid $elapsed');
        },
       userJoined: (uid,elapsed)
      {
        debugPrint('UserJoined  $uid $elapsed');
          setState(() {
            remoteUid.add(uid);
          });
      },
    userOffline: (uid,reason)
      {
        debugPrint('UserOffline $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element==uid);
        });
      },
    leaveChannel: (stats)
      {
        debugPrint('LeaveChannel $stats');
        setState(() {
          remoteUid.clear();
        }
        );
      },tokenPrivilegeWillExpire: (token)async{
      await getToken();
      await _engine.renewToken(token);
      }
     )
     );
  }
  void _joinChannel()async
  {  await getToken();
     if(defaultTargetPlatform==TargetPlatform.android)
       {
         await[
           Permission.microphone,
           Permission.camera].request();
       }
     await _engine.joinChannelWithUserAccount(
          token,
         widget.channelId,
         Provider.of<UserProvider>(context,listen: false).user.uid);

  }
void _switchCamera()
{
  _engine.switchCamera().then((value)
  {
    setState(() {
      switchCamera =!switchCamera;
    }
    );
  }).catchError((err)
  {
    debugPrint('SwitchCamera $err');
  });
}
void ontToggleMute()async
{
  setState(() {
    isMuted=!isMuted;
  });
  await _engine.muteLocalAudioStream(isMuted);
}


_startScreenShare() async {
  final helper = await _engine.getScreenShareHelper(
      appGroup: kIsWeb || Platform.isWindows ? null : 'io.agora');
  await helper.disableAudio();
  await helper.enableVideo();
  await helper.setChannelProfile(ChannelProfile.LiveBroadcasting);
  await helper.setClientRole(ClientRole.Broadcaster);
  var windowId = 0;
  var random = Random();
  if (!kIsWeb &&
      (Platform.isWindows || Platform.isMacOS || Platform.isAndroid)) {
    final windows = _engine.enumerateWindows();
    if (windows.isNotEmpty) {
      final index = random.nextInt(windows.length - 1);
      debugPrint('Screensharing window with index $index');
      windowId = windows[index].id;
    }
  }
  await helper.startScreenCaptureByWindowId(windowId);
  setState(() {
    isScreenSharing = true;
  });
  await helper.joinChannelWithUserAccount(
    token,
    widget.channelId,
    Provider.of<UserProvider>(context, listen: false).user.uid,
  );
}

_stopScreenShare() async {
  final helper = await _engine.getScreenShareHelper();
  await helper.destroy().then((value) {
    setState(() {
      isScreenSharing = false;
    });
  }).catchError((err) {
    debugPrint('StopScreenShare $err');
  });
}
  _leaveChannel()async
  {
    await _engine.leaveChannel();
    if('${Provider.of<UserProvider>(context,listen: false)
        .user.uid}'
        '${Provider.of<UserProvider>(context,listen: false)
        .user.username}'==widget.channelId)
      {
        await FirestoreMethods().endLiveStream(widget.channelId);
      }
    else{
      await FirestoreMethods().updateViewCount(widget.channelId,false);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
  final user= Provider.of<UserProvider>(context).user;
    return  WillPopScope(
      onWillPop: ()async
      {
         await _leaveChannel();
         return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: widget.isBroadcaster? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: CustomButton(
            text: 'End Stream',
            onTap:_leaveChannel,
          ),
        ):null,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child:  ResponsiveLatout(
            desktopBody: Row(
              children: [
                Expanded(child: Column(
                  children: [
                    _renderVideo(user,isScreenSharing),
                    if("${user.uid}${user.username}"==widget.channelId)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: _switchCamera,
                              child:const Icon(
                                Icons.flip_camera_ios_rounded,
                                color: Colors.deepPurple,
                                size:40,
                              )
                          ),
                          const SizedBox(width: 40,),
                          InkWell(
                              onTap: ontToggleMute,
                              child: Icon(
                                  isMuted ?Icons.mic_off:Icons.mic_none,
                                  color: Colors.red,
                                  size:40
                              )
                          ),
                          InkWell(
                            onTap: isScreenSharing
                                ? _stopScreenShare
                                : _startScreenShare,
                            child: Text(
                              isScreenSharing
                                  ? 'Stop ScreenSharing'
                                  : 'Start Screensharing',
                            ),
                          ),
                        ],
                      )
                  ],
                )
                )
              ],
            ),
            mobileBody: Column(
              children: [
                _renderVideo(user,isScreenSharing),
                if("${user.uid}${user.username}"==widget.channelId)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: _switchCamera,
                        child:const Icon(
                          Icons.flip_camera_ios_rounded,
                          color: Colors.deepPurple,
                          size:40,
                        )
                      ),
                  const SizedBox(width: 40,),
                      InkWell(
                          onTap: ontToggleMute,
                          child: Icon(
                              isMuted ?Icons.mic_off:Icons.mic_none,
                              color: Colors.red,
                              size:40
                          )
                      )
                    ],
                  ),
                Expanded(
                  child: Chat(channelId: widget.channelId,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
_renderVideo(user, bool isScreenSharing)
{
  return AspectRatio(aspectRatio: 16/9 ,//21/19
    child: "${user.uid}${user.username}"==widget.channelId
    ? isScreenSharing
        ?kIsWeb
        ?const RtcLocalView.SurfaceView.screenShare()
        :const RtcLocalView.TextureView.screenShare()
        :const RtcLocalView.SurfaceView(
       zOrderMediaOverlay:true,
      zOrderOnTop: true,
  )
        :isScreenSharing
        ? kIsWeb
        ?const RtcLocalView.SurfaceView.screenShare()
        :const RtcLocalView.TextureView.screenShare()
        :remoteUid.isNotEmpty
        ?kIsWeb
        ?RtcRemoteView.SurfaceView(
      uid:remoteUid[0],
      channelId: widget.channelId,
    )
    :RtcRemoteView.TextureView(
      uid:remoteUid[0],
      channelId: widget.channelId,
    )
        :Container()
  );

}
}
