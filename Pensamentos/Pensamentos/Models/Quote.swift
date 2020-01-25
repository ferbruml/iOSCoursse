//
//  Quote.swift
//  Pensamentos
//
//  Created by Fernanda Brum on 07/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation

// MODEL - struct que representa um pensamento
struct Quote: Codable { // struct implementa o protocolo Codable
    let quote: String
    let author: String
    let image: String
    
    var quoteFormatted: String {
        return " “" + quote + "” "
    }
    
    var authorFormatted: String {
        return "- " + author + " -"
    }
}
