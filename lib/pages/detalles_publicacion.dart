import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles_2026/constants.dart';

class DetallesPublicacion extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetallesPublicacion({super.key, required this.data});
  

  @override
  Widget build(BuildContext context) {
    final foto = data['Foto'];
    final categoria = data['Categoria'];
    final autor= data['Autor'];


    return Scaffold(
      backgroundColor: colorFondos,
      appBar: AppBar(
        title: const Text('Detalle del objeto'),
        backgroundColor: colorAppBar,
        foregroundColor: colorLetrasBlancas,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foto is Blob)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(foto.bytes, width: double.infinity, fit: BoxFit.contain),
            )
            else
              Center(child: Icon(MdiIcons.imageEdit)),
              SizedBox(),

              Row(
                children: [
                  Expanded(
                    child: Text(data['Titulo'],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: colorLetrasBlancas),
                      ),
                    ),
                    Chip(label: Text(data['Estado']
                    ),
                    ),

                ],
              ),
              Divider(),
              
              _fila('Tipo', data['Tipo'],),
              if (categoria is DocumentReference)
              FutureBuilder(
              future: categoria.get(), 
              builder: (context, snap){
                if (!snap.hasData) return _fila('Categoria', '...');
                final cate = snap.data!.data() as Map<String, dynamic>?;
                return _fila('Categoria', cate?['nombre']);
              },
              )
              else _fila('Categoria', categoria),

              _fila('Lugar', data['Lugar']),
              _fila('Fecha y hora', data['FechaHora']),
              _fila('Descripción', data['Descripcion']),
              _fila('Publicado por', data['AutorNombre'] ??autor),

          ],
        ),
      ),
    );
  }
}


Widget _fila(String titulo, dynamic valor){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(fontSize: 13, color: colorLetrasBlancas),),
          Text(valor, style: TextStyle(fontSize: 16, color: colorLetrasBlancas),)
        ],
      ),
    );
}