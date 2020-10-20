// import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MLPage extends StatefulWidget {
  // final String url;
  final File imageFile;

  MLPage(this.imageFile);

  @override
  _MLPageState createState() => _MLPageState();
}

class _MLPageState extends State<MLPage> {
  
  ProgressDialog pr;
 
  
  String url;
  void callApi(BuildContext context) async {
    var dio = Dio();
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: true);
    //pr.show();
    pr.hide().whenComplete(() => print("ok"));
    FormData formdata = FormData.fromMap({
      'image': await MultipartFile.fromFile(this.widget.imageFile.path),
    });
    // print(tempFile.path);
    Response response = await dio
        .post("http://34.80.236.168/upload-image", data: formdata);
      
    setState(() {
      // log(url);
      url = response.data.toString();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   callApi(context);  
  // }
  @override
  Widget build(BuildContext context) {
    
    //  log(file);
    String name;
    String api;

    if (url != null) {
      name = this.url.split("/")[1];
      api = "http://34.80.236.168/image/" + name;
    } else {      
         callApi(context); 
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff575dcf),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: url == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: PhotoView(
                  imageProvider: NetworkImage(api,
                      headers: {"Connection": "keep-alive"}))),
    );
  }
}
