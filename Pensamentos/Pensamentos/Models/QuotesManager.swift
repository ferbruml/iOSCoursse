//
//  QuotesManager.swift
//  Pensamentos
//
//  Created by Fernanda Brum on 07/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation

class QuotesManager {
    let quotes: [Quote]
    
    init() {
        let fileURL = Bundle.main.url(forResource: "quotes", withExtension: "json")! // desembrulhando sem preocupação, pois não é para termos problemas com o resource no bundle
        //let fileURL = Bundle.main.url(forResource: "quotes.json", withExtension: nil)! tb poderíamos fazer assim....
        
        // recupera o arquivo como binário
        let jsonData = try! Data(contentsOf: fileURL) // não utilizamos do/catch pq temos certeza de que não teremos problema com exceção aqui
        
        let jsonDecoder = JSONDecoder()
        quotes = try! jsonDecoder.decode([Quote].self, from: jsonData)
    }
    
    func getRandomQuote() -> Quote {
        let index = Int(arc4random_uniform(UInt32(quotes.count)))
        
        return quotes[index]
    }
}
