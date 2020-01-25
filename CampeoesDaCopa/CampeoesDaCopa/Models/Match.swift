//
//  Match.swift
//  CampeoesDaCopa
//
//  Created by Fernanda Brum on 13/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation

struct Match: Codable {
    let stage: String // nome da fase
    let games: [Game] // partidas que ocorreram nessa fase
}
