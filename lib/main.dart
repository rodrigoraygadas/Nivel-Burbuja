import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

String pelota="https://acegif.com/wp-content/uploads/loading-42.gif";

void main()=>runApp(Sensores());

class Sensores extends StatefulWidget {

  @override
  Estado createState() => Estado();
}

class Estado extends State<Sensores> {
  //Variables
  Color contenedor = Colors.red;
  List<double> acelerometro =[0.0,0.0,0.0];
  double posicionImagen=125.0, ancho= 200;

  //Eventos de sensores
  @override
  void initState(){
    super.initState();
    accelerometerEvents.listen((event) {
      setState(() {
        acelerometro=[event.x,event.y,event.z];
        if(acelerometro[0]>=-1 && acelerometro[0]<=1){
          contenedor = Colors.green;
          posicionImagen = 125; //centrar
        }else{
          contenedor = Colors.red;
          if(posicionImagen>=1 && posicionImagen<=300){
            posicionImagen -= acelerometro[0] *2;
            if (posicionImagen>300){
              posicionImagen=299;
            }
            if (posicionImagen<1.2){
              posicionImagen=1.2;
            }
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context)=>  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: contenedor,
    ),
    home: Scaffold(
        appBar: AppBar(title: Text("Equilibrio: ${acelerometro[0].roundToDouble()}")),
        //backgroundColor: contenedor,
        body: Stack(
          children: [
            Expanded(
              child: ClipPath(
                clipper: rectanguloClipper(),
                child: Container(
                  color: contenedor,
                ),
              ),
            ),
            Positioned(child: Image.network(pelota),
              top: 300,
              right: posicionImagen,
              height: ancho,
              width: 200,
            )
          ],
        )
    ),
  );
}

class rectanguloClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0,350)
      ..lineTo(0,450)
      ..lineTo(size.width,450)
      ..lineTo(size.width,350)
      ..lineTo(0,350)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}