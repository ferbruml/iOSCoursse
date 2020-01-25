//
//  TaxesCalculator.swift
//  ComprasUSA
//
//  Created by Fernanda Brum on 04/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation

class TaxesCalculator {
    
    static let shared = TaxesCalculator() // singleton: devolve sempre a mesma instancia
    
    var dolar: Double = 3.5
    var iof: Double = 6.38
    var stateTax: Double = 7.0
    var shoppingValue: Double = 0 // valor da compra do user
    
    let formatter = NumberFormatter()
    
    // variáveis computadas
    // 1a tela
    var shoppingValueInReal: Double {
        return shoppingValue * dolar
    }
    // 3a tela
    var stateTaxValue: Double {
        return shoppingValue * stateTax / 100
    }
    var iofValue: Double {
        return (shoppingValue + stateTax) * iof/100
    }
    
    private init() { // garante que ninguém conseguirá instanciar esta classe, já que este cto somente será chamado na criação da shared
        formatter.usesGroupingSeparator = true
    }
    
    func calculate(usingCreditCard: Bool) -> Double {
        var finalValue = shoppingValue + stateTaxValue
        
        if (usingCreditCard) {
            finalValue += iofValue
        }
        
        return finalValue * dolar
    }
    
    func convertToDouble(_ string: String) -> Double {
        
        formatter.numberStyle = .none // setamos isso pq agora estamos trabalhando com números simples, não valores de moedas, por exemplo. Precisamos ficar alterando o style pq estamos utilizando o mesmo formatter para duas coisas
        return formatter.number(from: string)!.doubleValue
    }
    
    func getFormattedValue(of value: Double, withCurrency currency: String) -> String {
        formatter.numberStyle = .currency // agora vamos trabalhar com moedas
        formatter.currencySymbol = currency // com este símbolo da moeda que estamos recebendo
        formatter.alwaysShowsDecimalSeparator = true // mostrar sempre o valor de decimal? Sim, pois aqui estamos trabalhando com moeda
        
        return formatter.string(for: value)!
    }
}
