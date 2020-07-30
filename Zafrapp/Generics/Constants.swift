//
//  Constants.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/30/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

enum UserDefaultsConstants_Enum: String {
    case defaultRecoverUser                         = "username"
    case defaultRecoverDrowssap                     = "password"
    case bIsSaved                                   = "bSaved"
}

enum typeOfDataPicker_Enum: Int {
    case Departamento        = 1
    case ingenio             = 2
    case birthDay            = 3
}

enum typeOfPickerEditProfile_Enum: Int {
    case Estado              = 1
    case Municipio           = 2
    case AreaDeInteres       = 3
    case Ingenio             = 4
    case departamento        = 5
    case Trabajo             = 7
    case Calle               = 8
    case PhoneOffice         = 9
    case Cell                = 10
    case interesOpcional     = 11
    case optionalDepartment  = 12
    case optionaIngenio      = 13
}

var arrServicios = ["Combustoleo", "Materiales para laboratorio", "Aceites, grasas y lubricantes", "Combustibles(diesel y gasolina)","Productos químicos de fábrica","Reactivos laboratorio","Artículos industriales", "Tornillería","Fierros, aceros y aleaciones no ferrosas", "Materiales de construcción","Válvulas, tuercas y conexiones", "Empaquetadoras y juntas", "Soldadura y gases", "Material eléctrico", "Ferretería varios (incluye herramientas)"]

var areaDeInteres = ["Fábrica", "Campo", "Administración", "Otro"]
