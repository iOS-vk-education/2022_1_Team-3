//
//  Model.swift
//  DeadLine
//
//  Created by Roman Nizovtsev on 20.04.2022.
//

import Foundation
struct Task: Codable {
    var Title: String
    var Description: String
    var Priority:Float
    var Done:Bool
}
