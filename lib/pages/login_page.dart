import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles_2026/constants.dart';

import 'package:proyecto_moviles_2026/pages/services/auth_google.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondos,
      body: SafeArea(
        child: Center(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,

            
            children: [
              
             Image(image: AssetImage('assets/images/Logo_UTFSM.png')),
              Padding(padding: EdgeInsets.all(10)),
              Text('Santa Perdida', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: colorLetrasBlancas)),
              const Spacer(),
             FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor: colorDrawer,
                foregroundColor: colorLetrasNegras,
                
              ),
              


              onPressed: () async {
                try {
                  final user = await AuthGoogle().loginGoogle();
                  if(user ==null) return;
                  
                }on FirebaseAuthException catch(error){
                  
                  if(!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.message??'ERROR DETECTADO'),
                    )
                  );
                }  
                
               catch(error){
                  
                  if(!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                    )
                  );
               }
              },
              icon: const Icon(MdiIcons.loginVariant),
              label: const Text('Iniciar con Google'),

             ),
             const Spacer()
            ],
          ),
        )
        ),
    );
  }
}