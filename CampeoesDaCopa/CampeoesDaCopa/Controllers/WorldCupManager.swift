//
//  WorldCupManager.swift
//  CampeoesDaCopa
//
//  Created by Fernanda Brum on 13/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation

class WorldCupManager {
    
    static var shared: WorldCupManager = WorldCupManager()
    
    var worldCups: [WorldCup] = []
    
    private init() {
        
    }
    
    func loadWorldCups() {
        let fileURL = Bundle.main.url(forResource: "winners.json", withExtension: nil)!
        let jsonData = try! Data(contentsOf: fileURL)
        
        do {
            worldCups = try JSONDecoder().decode([WorldCup].self, from: jsonData)
        } catch {
            print(error.localizedDescription)
        }
    }
}
