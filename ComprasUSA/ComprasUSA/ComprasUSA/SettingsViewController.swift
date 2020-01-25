//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Fernanda Brum on 05/11/18.
//  Copyright © 2018 Fernanda Brum. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tfStateTaxes: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // lendo os valores configurados no TaxesCalculator
        tfDolar.text = tc.getFormattedValue(of: tc.dolar, withCurrency: "")
        tfIOF.text = tc.getFormattedValue(of: tc.iof, withCurrency: "")
        tfStateTaxes.text = tc.getFormattedValue(of: tc.stateTax, withCurrency: "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // informando a view para finalizar a sua edição -> user clica fora na tela e o teclado desaparecerá
    }
    
    // user altera os valores das taxas, então precisamos que, quando o user saia do campo ou clique fora na tela, os valores dos campos sejam repassados para o TaxesCalculator
    func setValues() {
        tc.dolar = tc.convertToDouble(tfDolar.text!)
        tc.iof = tc.convertToDouble(tfIOF.text!)
        tc.stateTax = tc.convertToDouble(tfStateTaxes.text!)
    }
}

// como esta tela é delegate dos textfields dela, precisa implementar o protocolo UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) { // sempre que o user sair de um campo...
        setValues()
    }
}
