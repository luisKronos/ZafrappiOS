//
//  AppConstants.swift
//  Zafrapp
//
//  Created by Ing. Jorge Ivan Estrada Torres on 15/08/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

enum AppConstants {

    static let services = ["Combustoleo", "Materiales para laboratorio", "Aceites, grasas y lubricantes", "Combustibles(diesel y gasolina)","Productos químicos de fábrica","Reactivos laboratorio","Artículos industriales", "Tornillería","Fierros, aceros y aleaciones no ferrosas", "Materiales de construcción","Válvulas, tuercas y conexiones", "Empaquetadoras y juntas", "Soldadura y gases", "Material eléctrico", "Ferretería varios (incluye herramientas)"]

    static let interestAreas = ["Fábrica", "Campo", "Administración", "Otro"]
    
    enum String {
        static let errorTitle = NSLocalizedString("Error", comment: "")
        static let accept = NSLocalizedString("Aceptar", comment: "")
        static let internetConnection = NSLocalizedString("Conexion de internet", comment: "")
        static let internetConnectionMessage = NSLocalizedString("No tienes conexion a internet.", comment: "")
        static let tryAgain = NSLocalizedString("Intenta de nuevo", comment: "")
    }

    enum ErrorCode {
        static let bad = "BAD"
        static let noInternetConnection = -1009
    }

    enum Storyboard {
        static let login = "Login"
    }
    
    enum ViewController {
        static let loginNavigation = "Login_Nav"
        static let editProfile = "editProfileVC"
    }

    enum UserDefaults: Swift.String {
        case defaultRecoverUser = "username"
        case defaultRecoverDrowssap = "password"
        case isSaved = "isSaved"
    }

}

enum PickerDataType: Int {
    case suburb = 1
    case ingenio = 2
    case birthDay = 3
}

enum EditProfilePickerType: Int {
    case state = 1
    case suburb = 2
    case interestArea = 3
    case ingenio = 4
    case department = 5
    case work = 7
    case street = 8
    case officePhone = 9
    case cell = 10
    case interestOptional = 11
    case departmentOptional = 12
    case ingenioOptional = 13
}

