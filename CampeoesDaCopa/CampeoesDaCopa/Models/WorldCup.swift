//
//  WorldCup.swift
//  CampeoesDaCopa
//
//  Created by Fernanda Brum on 12/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation

struct WorldCup: Codable {
    let year: Int
    let country: String
    let winner: String
    let vice: String
    let winnerScore: String
    let viceScore: String
    let matches: [Match] // array de partidas
}
