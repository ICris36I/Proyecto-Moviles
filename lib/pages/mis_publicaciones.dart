import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles_2026/constants.dart';

class MisPublicaciones extends StatefulWidget {
  const MisPublicaciones({super.key});
  

  @override

  State<MisPublicaciones> createState() => _MisPublicacionesState();
}

class _MisPublicacionesState extends State<MisPublicaciones> {
  final _email = FirebaseAuth.instance.currentUser?.email;
  Future<void> _seguroBorrar(DocumentSnapshot doc) async{
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contex)=> AlertDialog(
        title: Text('Eliminar Publicación'),
        content: Text('Se eliminará tu publicación, estás seguro? '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contex, false), 
            child: Text('Cancelar')
            ),
            TextButton(
              onPressed: ()=> Navigator.pop(contex, true), 
              child: Text('Eliminar', style: TextStyle(color: Colors.red),)
              ),
        ],
      )
    );

    if (confirmar != true) return;

    try{
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publicación eliminada')),
      );


    }catch (err){
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $err')),
      );

    }
  }

  Future<void> _devuelto(DocumentSnapshot doc) async{
    final confirmar = await showDialog(
      context: context, 
      builder: (contex) => AlertDialog(
        title: Text('Marcar como devuelto'),
        content: Text('Seguro que quieres marcar como devuelto?'),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(contex, false), 
            child: Text('Cancelar'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(contex, true), 
            child: Text('Devuelto'),
            ),
        ],
      )
      );

      if (confirmar != true) return;

      try{
        await doc.reference.update({'Estado' : 'Devuelto'});
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publicación marcada como devuelta')),
        );

      }catch(err){
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $err')),
        );
      }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondos,

      appBar: AppBar(
        title: Row(
          children: [
            Text('Mis Publicaciones')
          ],
        ),
        backgroundColor: colorAppBar,
        foregroundColor: colorLetrasBlancas,
      ),

      body: _email == null ? const Center(child: Text('No hay una sesion iniciada')) : 
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Publicaciones').where('Autor', isEqualTo: _email).snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }

          final docs = snapshot.data!.docs;
          debugPrint('Buscando autor = $_email, encontrados : ${docs.length}');
          if (docs.isEmpty){
            return Center(child: Text('Aún no has publicado objetos', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20),) );
          }
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index){
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final foto = data['Foto'];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorLetrasBlancas,
                    border: Border.all(color: colorLetrasNegras, width: 2)
                  ),
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                      foto is Blob ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          foto.bytes,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ): Icon(MdiIcons.stop),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['Titulo']),
                              Text('Tipo : ${data['Tipo']}'),
                              Text('Lugar : ${data['Lugar']}'),
                              Text('Fecha : ${data['FechaHora']}'),
                              Text('Estado : ${data['Estado']}'),
                              //style
                            ],
                          ),
                        ),
                        if(data['Estado'] == 'Vigente')
                        IconButton(
                          onPressed: ()=> _devuelto(doc), 
                          icon: Icon(MdiIcons.checkCircle, color: colorIconos),
                          tooltip: 'Marcar como devuelto',
                          ),
                        IconButton(
                          onPressed: ()=> _seguroBorrar(doc), 
                          icon: Icon(MdiIcons.delete)
                        ),
                      ]
                    ), 
                    ),
                ),
              );


            },
          );

        },
      ),

    );
  }
}