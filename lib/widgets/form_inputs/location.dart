import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  Uri _staticMapUri;
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(
        _updateLocation); //metoda ktora focusuje ci sa ymenil status focusu cize napr ked klikneme niekde inde a prestaneme pisat
    super.initState();
  }

  @override
  void dispose() {
    //toto preto lebo ten listener by pocuval stala aj keby odideme z pagu takze kvoli memory leakom
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      print('adressa ' + address);
      return;
    }

    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': "AIzaSyBLLMgJn2PEtrfw7c1tWeiv961mmMaWyBU"});
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];


    print('decoded response' + decodedResponse);
    print('formatted adress' + formattedAddress);
    print('coords' + coords);
  
    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider('AIzaSyBLLMgJn2PEtrfw7c1tWeiv961mmMaWyBU');
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', coords['lat'], coords['lng'])],
        center: Location(coords['lat'], coords['lng']),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

        print(staticMapUri.toString());
    setState(() {
      _addressInputController.text = formattedAddress;
      _staticMapUri = staticMapUri;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressInputController,
          decoration: InputDecoration(labelText: 'Address'),
        ),
        SizedBox(
          height: 10.0,
        ),
        //Image.network(_staticMapUri.toString())
      ],
    );
  }
}
