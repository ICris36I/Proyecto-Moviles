import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles_2026/constants.dart';
import 'package:proyecto_moviles_2026/pages/mis_publicaciones.dart';
import 'package:proyecto_moviles_2026/pages/mostrar_publicaciones.dart';
import 'package:proyecto_moviles_2026/pages/publicar_objeto.dart';


class HomePage extends StatefulWidget {
  
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index =0;
  String largoNombre = "";

  void _navegar (int index) async{
    setState(() {
      _index =index;
    });

    Navigator.pop(context);

    switch(index){
      
      case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const PublicarObjeto()));
      break;

      case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const MostrarPublicaciones()));
      
      case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const MisPublicaciones()));

      case 3: 
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    largoNombre = user?.displayName??'Usuario';

    return Scaffold(
      backgroundColor: colorFondos,
      appBar: AppBar(
        centerTitle: false,
       
        title: Text('¡Bienvenido $largoNombre!',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
    ),
          backgroundColor: colorAppBar,
          foregroundColor: colorLetrasBlancas,
),
      drawer: NavigationDrawer(
        backgroundColor: colorDrawer,
        indicatorColor: colorLetrasBlancas,
        selectedIndex: _index,
        onDestinationSelected: _navegar,
        children: [
          DrawerHeader(child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  
                  
                  image: DecorationImage(
                    
                    image:
                      user?.photoURL != null ? NetworkImage(user!.photoURL!): const AssetImage('assets/images/Logo_UTFSM.png') as ImageProvider, fit:BoxFit.cover)),
                ),
                Padding(padding: EdgeInsets.all(5)),

                Expanded(
                  child: Text(
                    largoNombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorLetrasNegras,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                     
                    ),
                    ),
                ),
              
            ],
          )
          ),
        
         
           NavigationDrawerDestination(
            icon: Icon(MdiIcons.bookPlusMultiple, color: colorIconos), 
            label: Text('Publicar Objeto', style: TextStyle(color: colorLetrasNegras)
          // bookMinusMultiple = icono eliminar libro 
            )
          ),
          
          Divider(),
           NavigationDrawerDestination(
            icon: Icon(MdiIcons.book, color: colorIconos), 
            label: Text('Lista de objetos perdidos', style: TextStyle(color: colorLetrasNegras)),
     
          ),
          Divider(),
           NavigationDrawerDestination(
            icon: Icon(MdiIcons.bookmark, color: colorIconos), 
            label: Text('Mis Objetos Publicados', style: TextStyle(color: colorLetrasNegras)),
     
          ),
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(MdiIcons.exitToApp, color: colorAppBar), 
            label: Text('Cerrar Sesión', style: TextStyle(color: colorLetrasNegras)),
            

          ),
        ],

      ),
      
      body:
      
      SizedBox(
        
        width: double.infinity,
        child: Column( 
             children: [
              
              SizedBox(height: 16),
              Image.asset('assets/images/Logo_UTFSM.png',
                height: 150,
              ),
              Padding(padding:EdgeInsets.all(10)),
              Text(
                'Santa Perdida',
                
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: colorLetrasBlancas),
                
              ),
              Padding(padding: EdgeInsets.all(15)),
              SizedBox(height: 10),
              Text('La mejor aplicación para encontrar aquello que perdiste',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorLetrasBlancas) ,
              ),
              
              Padding(padding: EdgeInsets.all(10)),
              Divider(),
              SizedBox(height: 10),
              Text('Te invitamos a presionar el boton de arriba a la izquierda para explorar todas nuestras funciones',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: colorLetrasBlancas),
                
              ),
              
              
        
             ],
            
          
        ),
      ),

    );
  }
}