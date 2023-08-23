import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

Column encabezado(BuildContext context,
                  String texto,
                  bool activarBtn,
                  Function()? onPressed,
                  bool activarObli,
                  { String btnText = 'Nuevo',
                    IconData? btnIcon = Icons.add_circle_outline } ) {

  return Column(

    children: [

      Container(

        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        alignment: Alignment.centerLeft,
        child: Row(

          children: [

            textoDosis(texto, 23),

            const Spacer(),

            if(activarBtn)
            OutlinedButton.icon(
              
              icon: Icon(btnIcon, color: Colors.black, size: 20,),            
              label: textoDosis(btnText, 16),
              onPressed: onPressed 
              
            ),

            if(activarObli) textoDosis('* -> Obligatorios', 18)
            
          ],

        )

      ),
    
      const Divider(
            
        color: Colors.black,
        indent: 20,
        endIndent: 20,
    
      ),

    ]

  );

}