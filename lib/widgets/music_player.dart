import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});
  @override State<MusicPlayerWidget> createState()=>_MusicPlayerWidgetState();
}
class _MusicPlayerWidgetState extends State<MusicPlayerWidget> with SingleTickerProviderStateMixin {
  final AudioPlayer player=AudioPlayer(); late final AnimationController disc=AnimationController(vsync:this,duration:const Duration(seconds:6)); bool playing=false;
  @override void initState(){super.initState();player.setReleaseMode(ReleaseMode.loop);player.setSource(AssetSource('audio/music.mp3'));player.onPlayerStateChanged.listen((state){if(!mounted)return;setState(()=>playing=state==PlayerState.playing);playing?disc.repeat():disc.stop();});}
  @override void dispose(){player.dispose();disc.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>GestureDetector(onTap:()async=>playing?await player.pause():await player.resume(),child:Container(padding:const EdgeInsets.fromLTRB(8,7,14,7),decoration:BoxDecoration(color:const Color(0xFF241713).withValues(alpha:.93),borderRadius:BorderRadius.circular(40),border:Border.all(color:Colors.white.withValues(alpha:.14)),boxShadow:const [BoxShadow(color:Color(0x55241713),blurRadius:25,offset:Offset(0,10))]),child:Row(mainAxisSize:MainAxisSize.min,children:[RotationTransition(turns:disc,child:Container(width:43,height:43,decoration:const BoxDecoration(shape:BoxShape.circle,gradient:RadialGradient(colors:[Color(0xFFD77B84),Color(0xFFD77B84),Color(0xFF17100E),Color(0xFF3B2924)],stops:[0,.12,.13,1])),child:Icon(playing?Icons.pause_rounded:Icons.play_arrow_rounded,color:const Color(0xFFFFFAF3),size:20))),const SizedBox(width:10),const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('НАША ПЕСНЯ',style:TextStyle(color:Color(0xFFFFFAF3),fontSize:8,letterSpacing:1.3,fontWeight:FontWeight.w600)),SizedBox(height:3),Text('Нажми, чтобы слушать',style:TextStyle(color:Color(0x99FFFAF3),fontSize:9))])])));
}
