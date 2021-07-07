import 'package:empire_developments/utils/color.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AnahtarTeslimYapildiPage extends StatefulWidget {
  String projectName;
  String projectImageUrl;

  AnahtarTeslimYapildiPage({this.projectName, this.projectImageUrl});

  @override
  _AnahtarTeslimYapildiPageState createState() =>
      _AnahtarTeslimYapildiPageState();
}

class _AnahtarTeslimYapildiPageState extends State<AnahtarTeslimYapildiPage> {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: constantColors.primaryKapaliColor,
          title: Text(widget.projectName),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: ExtendedImage.network(
                      widget.projectImageUrl,
                      height: MediaQuery.of(context).size.height - 70,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 10),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${widget.projectName}\n\n ${"Projemizin Anahtar Teslimi Yapılmıştır."}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.5, 0.1),
                                      blurRadius: 2.0,
                                      color: Colors.white,
                                    ),
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 3.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
                              CircleAvatar(
                                  backgroundColor: Colors.white70,child: Icon(Icons.vpn_key_outlined,size: 35,color: constantColors.primaryBlueColor,))
                            ],
                          ),
                        ),
                      ),
                    ),
                    alignment: Alignment.topCenter,
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
