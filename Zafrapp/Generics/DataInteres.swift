//
//  DataInteres.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class areaOfInteres {
    
   var ArrFabrica = ["Batey","Molinos","Calderas","Cristalización","Envase","Instrumentación","Campo","Maquinaria","Mantenimiento","Planta de Fuerza","Clarificación","Evaporación","Centrifugación","Servicios Generales","Destilería","Seguridad Industrial","Refinería de Azúcar","Taller Mecánico", "Cogeneración Energía Eléctrica"]
    
     var ArrCampo = ["Cosecha","Siembra y Cultivo","Laboratorio de Campo","Maquinaria Agrícola"]
    
    var ArrAdmin = ["Almacén de materiales","Almacén de producto terminado","Administración(Compras, cuentas por pagar, cuentas por cobrar, etc)","Recursos Humanos"]
    var arrOtro = ["Estudiante o pasante","Proveedor","Otro (cuál)"]
    
    func returnAreaInterest (Area : String) -> String {
        if ArrFabrica.contains(Area){
            return "fábrica"
        }else if ArrCampo.contains(Area){
            return "campo"
        }else if ArrAdmin.contains(Area){
            return "admin"
        }else if arrOtro.contains(Area){
            return "otro"
        }else {
            return ""
        }
    }
}
