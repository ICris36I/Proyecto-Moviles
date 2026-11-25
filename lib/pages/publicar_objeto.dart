import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_moviles_2026/constants.dart';

class PublicarObjeto extends StatefulWidget {
  const PublicarObjeto({super.key});

  @override
  State<PublicarObjeto> createState() => _PublicarObjetoState();
}

class _PublicarObjetoState extends State<PublicarObjeto> {
  Future<void> agregarPublicacion(
  String autor,
  String categoria,
  String descripcion,
  String estado,
  Timestamp fechaHora,
  String lugar,
  String tipo,
  String titulo,

){
  return FirebaseFirestore.instance.collection('Publicaciones').doc().set({
    'Autor': autor,
    'Categoria': categoria,
    'Descripcion': descripcion,
    'Estado': estado,
    'FechaHora': fechaHora,
    'Lugar': lugar,
    'Tipo': tipo,
    'Titulo': titulo,
    
  });

}

final formkey = GlobalKey<FormState>();

TextEditingController tituloCtrl = TextEditingController();
TextEditingController descripcionCtrl = TextEditingController();
String? tipoCtrl;
DocumentReference? categoriaCtrl;
TextEditingController lugarCtrl = TextEditingController();
TextEditingController fechahoraCtrl = TextEditingController();
TextEditingController estadoCtrl = TextEditingController();
TextEditingController autorCtrl = TextEditingController();

Uint8List? _fotoBytes;

bool guardar = false;

Future<void> _fechaHora()async{
  final fecha = await showDatePicker(
    context: context, 
    firstDate: DateTime(2024), 
    lastDate: DateTime.now(),

  );


  if (fecha == null || !mounted) return;

  final hora = await showTimePicker(
    context: context, 
    initialTime: TimeOfDay.now(),
    );

  if (hora == null || !mounted) return;

  String dos(int n) => n.toString().padLeft(2, '0');
    fechahoraCtrl.text =
        '${dos(fecha.day)}/${dos(fecha.month)}/${fecha.year} ${dos(hora.hour)}:${dos(hora.minute)}';
}


Future<void> _foto(ImageSource fuente) async{
  final picker = ImagePicker();
  final XFile? img= await picker.pickImage(
    source: fuente,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 70,
    );
    if (img == null) return;

    final bytes = await img.readAsBytes();
    if (bytes.length >900 * 1024){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('La foto pesa demasiado, coloque otra. ')),
      );
      return;
    }
  setState(()=> _fotoBytes = bytes);

}

void _elegirFoto(){
  showModalBottomSheet(context: context, builder: (_)=> SafeArea(child: Wrap(children: [
    ListTile(
      leading: Icon(MdiIcons.camera),
      title: Text('Tomar Foto'),
      onTap: () {
        Navigator.pop(context);
        _foto(ImageSource.camera);
      },
    ),
    ListTile(
      leading: Icon(MdiIcons.viewGallery),
      title: Text('Galería'),
      onTap: () {
        Navigator.pop(context);
        _foto(ImageSource.gallery);
      },
    )
  ],)));
}



Future<void> _publicar() async{
  if (!formkey.currentState!.validate()) return;
  if (_fotoBytes== null){
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('La foto es obligatoria')),
    );
    return;
  }

  setState(() => guardar = true);
  try{
    await FirebaseFirestore.instance.collection('Publicaciones').add({
      'Titulo': tituloCtrl.text.trim(),
      'Descripcion': descripcionCtrl.text.trim(),
      'Tipo': tipoCtrl,
      'Categoria': categoriaCtrl,
      'Lugar': lugarCtrl.text.trim(),
      'FechaHora':fechahoraCtrl.text,
      'Foto': Blob(_fotoBytes!),
      'Estado': 'Vigente',
      'AutorNombre': FirebaseAuth.instance.currentUser?.displayName,
      'Autor' : FirebaseAuth.instance.currentUser?.email,

    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Publicación creada')),
    );
    Navigator.pop(context);

  } catch(err){
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error al guardar: $err')),
    );
  }finally{
    if (mounted) setState(() => guardar = false);
  }

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondos,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Publicar Objeto Perdido')
          ],
        ),
        backgroundColor: colorAppBar,
        foregroundColor: colorLetrasBlancas,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Titulo', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20,)),
              TextFormField(
                
                style: TextStyle(color: colorLetrasNegras),
                controller: tituloCtrl,         
                textInputAction: TextInputAction.next,       
                decoration: InputDecoration(
                  hintText: 'Ej. Audífonos Bluetooth negros',
                  

                  
                ),
                
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
              ),
              Divider(),
              Text('Descripción', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20,)),

              TextFormField(
                controller: descripcionCtrl,         
                textInputAction: TextInputAction.next,       
                decoration: InputDecoration(                            
                  hintText: 'Ej. Estaba en el piso',
                  
                  
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio'  : null,
              ),
               Divider(),
              Text('Tipo', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20,)),
               
              DropdownButtonFormField<String>(
                
                decoration: InputDecoration(
                  
                  
                ),
                items: [
                  DropdownMenuItem(value: 'Perdido', child: Text('Perdido')),
                  DropdownMenuItem(value: 'Encontrado', child: Text('Encontrado'),)
                ],
                onChanged: (value) => setState(() => tipoCtrl = value),
                validator: (value) => value == null? 'Selecciona un tipo' : null,

              ),
               Divider(),
              Text('Categoría', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20,)),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Categorias').snapshots(),
                builder: (context, snap){
                  if (snap.hasError){
                    return Text('Error');
                  }
                  if (!snap.hasData){
                    return LinearProgressIndicator();
                  }
                  final docs = snap.data!.docs;
                  return DropdownButtonFormField<DocumentReference>(
                    initialValue: categoriaCtrl,
                    decoration: InputDecoration(
                      
                      
                    ),
                    items: docs.map((d){
                      final data = d.data() as Map<String, dynamic>;
                      return DropdownMenuItem<DocumentReference>(
                        value:d.reference,
                        child: Text((data['nombre'] ?? d.id).toString()),
                      );
                    }).toList(),
                    onChanged:(value) => setState(()=> categoriaCtrl = value),
                    validator: (value) => value == null? 'Selecciona una categoría' : null,

                  );

                },

              ),
               Divider(),
              Text('Lugar', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20,)),

              TextFormField(
                controller: lugarCtrl,         
                textInputAction: TextInputAction.next,       
                decoration: InputDecoration(                            
                  hintText: 'Ej. Estaba adentro del edificio R',
                  
                  
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
              ),
               Divider(),
              Text('Fecha y Hora', style: TextStyle(color: colorLetrasBlancas, fontWeight: FontWeight.bold, fontSize: 20,)),

              TextFormField(
                controller: fechahoraCtrl,         
                readOnly: true,
                onTap: _fechaHora,                      
                decoration: InputDecoration(                            
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
              ),
          

               if (_fotoBytes != null)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: ClipRRect(
                      
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(_fotoBytes!, height: 200, fit: BoxFit.cover
                      ),
                      
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: OutlinedButton.icon(onPressed: _elegirFoto, icon: Icon(MdiIcons.cellphone),
                    style: OutlinedButton.styleFrom(foregroundColor: colorLetrasNegras, backgroundColor: colorDrawer),
                    label: Text(_fotoBytes == null? 'Agregar foto' : 'Cambiar foto'),
                  ),
                ),
    
                Divider(),

              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  
                  child: ElevatedButton(onPressed: guardar? null: _publicar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAppBar,
                    foregroundColor: colorLetrasBlancas,
                    padding: EdgeInsets.all(10),
                  ),
                  child: guardar? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  :Text('Publicar', style: TextStyle(color: colorLetrasBlancas, fontSize: 20),)
                  ),
                ),
              ),
              

            ],
          ),
          ),
      ),


    );
  }
}