//
//  main.swift
//  BrazilStatesAndCitiesLibAutomator
//
//  Created by Munir Wanis on 23/12/17.
//  Copyright © 2017 Munir Wanis. All rights reserved.
//

import Foundation

struct States: Decodable {
    var estados: [State]
}

struct State: Decodable {
    var sigla: String
    var nome: String
    var cidades: [String]
}

let fileToRead = "estados-cidades.json"
let fileToWrite = "BrazilStates.swift"

if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
    
    let fileURL = dir.appendingPathComponent(fileToRead)
    let fileURLToWrite = dir.appendingPathComponent(fileToWrite)
    
    //reading
    do {
        let json = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)
        let statesUnsorted = try JSONDecoder().decode(States.self, from: json!)
        let states = statesUnsorted.estados.sorted(by: { $0.sigla < $1.sigla })
        
        let tab = "    "
        
        // MARK: - Enum declaration
        var statesEnum = "enum BrazilStates: String {\n"
        
        states.forEach {
            statesEnum.append("\(tab)case \($0.sigla.lowercased()) = \"\($0.sigla.uppercased())\"\n")
        }
        
        statesEnum.append("\n")
        
        // MARK: - Variable generation method
        
        statesEnum.append("\(tab)var code: String {\n")
        statesEnum.append("\(tab)\(tab)return self.rawValue\n")
        statesEnum.append("\(tab)}\n\n")
        
        statesEnum.append("\(tab)var name: String {\n")
        statesEnum.append("\(tab)\(tab)let stateInformation = getStateInformation()\n")
        statesEnum.append("\(tab)\(tab)return stateInformation.name\n")
        statesEnum.append("\(tab)}\n\n")
        
        statesEnum.append("\(tab)var cities: [String] {\n")
        statesEnum.append("\(tab)\(tab)let stateInformation = getStateInformation()\n")
        statesEnum.append("\(tab)\(tab)return stateInformation.cities\n")
        statesEnum.append("\(tab)}\n\n")
        
        // MARK: - getStateInformation() method
        
        statesEnum.append("\(tab)private func getStateInformation() -> (name: String, cities: [String]) {\n")
        statesEnum.append("\(tab)\(tab)switch self {\n")
        
        states.forEach {
            statesEnum.append("\(tab)\(tab)\(tab)case .\($0.sigla.lowercased()): return (\"\($0.nome)\", \($0.cidades))\n")
        }
        
        statesEnum.append("\(tab)\(tab)\(tab)default: return (\"\", [])\n")
        statesEnum.append("\(tab)\(tab)}\n")
        statesEnum.append("\(tab)}\n")
        
        statesEnum.append("}")
        
        try statesEnum.write(to: fileURLToWrite, atomically: false, encoding: .utf8)
    }
    catch {
        print("Deu merda.")
        print(error)
    }
}
