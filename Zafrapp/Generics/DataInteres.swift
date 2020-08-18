//
//  DataInteres.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class InterestedArea {
    
    var fabrics = ["Batey","Molinos","Calderas","Cristalización","Envase","Instrumentación","Campo","Maquinaria","Mantenimiento","Planta de Fuerza","Clarificación","Evaporación","Centrifugación","Servicios Generales","Destilería","Seguridad Industrial","Refinería de Azúcar","Taller Mecánico", "Cogeneración Energía Eléctrica"]
    
    var fields = ["Cosecha","Siembra y Cultivo","Laboratorio de Campo","Maquinaria Agrícola"]
    
    var administrations = ["Almacén de materiales","Almacén de producto terminado","Administración(Compras, cuentas por pagar, cuentas por cobrar, etc)","Recursos Humanos"]
    var others = ["Estudiante o pasante","Proveedor","Otro (cuál)"]
    
    func returnAreaInterest(area: String) -> String {
        if fabrics.contains(area){
            return "fábrica"
        } else if fields.contains(area){
            return "campo"
        } else if administrations.contains(area){
            return "admin"
        } else if others.contains(area){
            return "otro"
        } else {
            return ""
        }
    }
}
