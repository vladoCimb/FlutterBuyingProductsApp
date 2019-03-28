import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            padding: EdgeInsets.all(10),
            child: Theme.of(context).platform == TargetPlatform.android
                ? Column(
                    children: <Widget>[
                      Text(
                        'Pick an Image',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text('Use Camera'),
                        onPressed: () {
                          _getImage(context, ImageSource.camera);
                        },
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text('Use Gallery'),
                        onPressed: () {
                          _getImage(context, ImageSource.gallery);
                        },
                      )
                    ],
                  )
                : CupertinoPicker(onSelectedItemChanged: (_){},
                itemExtent: 40.0,
                backgroundColor: Colors.white,
                    children: <Widget>[               
                      FlatButton(
                        textColor: Colors.black,
                      
                        child: Text('Use Camera',style: new TextStyle(fontSize: 15.0),),
                        onPressed: () {
                          _getImage(context, ImageSource.camera);
                        },
                      ),
                      FlatButton(
                        textColor: Colors.black,
                        child: Text('Use Gallery',style: new TextStyle(fontSize: 15.0),),
                        onPressed: () {
                          _getImage(context, ImageSource.gallery);
                        },
                      )
                    ],
                  ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt),
              SizedBox(
                width: 5.0,
              ),
              Text('Add Image')
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _imageFile == null
            ? Text('Pleas pick an image')
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300.0,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
              )
      ],
    );
  }
}
