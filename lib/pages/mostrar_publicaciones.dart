import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles_2026/constants.dart';
import 'package:proyecto_moviles_2026/pages/detalles_publicacion.dart';
//import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:proyecto_moviles_2026/pages/services/fs_service.dart';


class MostrarPublicaciones extends StatefulWidget {
  
  const MostrarPublicaciones({super.key});

  @override
  State<MostrarPublicaciones> createState() => _MostrarPublicacionesState();
}

class _MostrarPublicacionesState extends State<MostrarPublicaciones> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondos,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Lista de objetos perdidos')
          ],
        ),
        backgroundColor: colorAppBar,
        foregroundColor: colorLetrasBlancas,
      ),

      body: SizedBox(
        
        child: StreamBuilder(
          stream: FsService().publicaciones(), 
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData||
              snapshot.connectionState == ConnectionState.waiting
            ){
              return Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final foto = data['Foto'];   
                final devuelto = data['Estado'] == 'Devuelto';             
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: devuelto? colorVerdeTransparente: colorLetrasBlancas,
                    border: Border.all(color: colorLetrasNegras, width: 2)
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                              
                      leading: foto is Blob
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          foto.bytes,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ): const Icon(MdiIcons.progressAlert),
                      title: Text(data['Titulo']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['Tipo']),
                          FutureBuilder<DocumentSnapshot>(
                            future: (data['Categoria'] as DocumentReference).get(),
                            builder: (context, snap){
                              if(!snap.hasData) return const Text('Categoria: ....');
                              final cate = snap.data!.data() as Map<String, dynamic>?;
                              return Text('Categoria: ${cate?['nombre']}');
                            },
                            ),
                          
                          Text(data['Estado']),
                          
                        ],
                        
                      ),
                      trailing: Icon(
                        devuelto? MdiIcons.checkCircle : MdiIcons.homeSearch,
                        color: devuelto? colorIconos : colorIconoSinDevolver,
                      ),
                        onTap: ()=> Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetallesPublicacion(data: data))
                        ),                
                    ),
                  ),
                );
              },
            );
          }
          ),
      ),

    );
  }
}