//
//  ShoppingViewController.swift
//  ComprasUSA
//
//  Created by Fernanda Brum on 05/11/18.
//  Copyright © 2018 Fernanda Brum. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController {

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var lbRealDescription: UILabel!
    @IBOutlet weak var lbReal: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAmount()
    }
    
    // quando o user clicar em qualquer lugar do app, o teclado sumirá já exibindo o valor atualizado em reais
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfDolar.resignFirstResponder()
        setAmount()
    }
    
    func setAmount() {
        //tc.shoppingValue = Double(tfDolar.text!)! esse não dá, pois o resultado do Double(...) pode ser nulo e, daí, quando formos desembrulhar, dá AV
        tc.shoppingValue = tc.convertToDouble(tfDolar.text!)
        lbReal.text = tc.getFormattedValue(of: tc.shoppingValue * tc.dolar, withCurrency: "R$ ")
        
        let dolar = tc.getFormattedValue(of: tc.dolar, withCurrency: "")
        lbRealDescription.text = "Valor sem impostos (dólar \(dolar))"
    }
}
