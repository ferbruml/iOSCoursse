//
//  GameViewController.swift
//  MyGames
//
//  Created by Fernanda Brum on 13/05/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game! // VAR QUE CONTÉM O JOGO QUE SERÁ APRESENTADO NESTA TELA, VINDO DA TELA DE EDIÇÃO
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
        if let releaseDate = game.releaseDate
        {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR") // FORÇANDO PARA EXIBIR A DATA EM PORTUGUÊS, INDEPENDENTE DO LOCALE ( IDIOMA ) DO SO
            
            lbReleaseDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
        if let image = game.cover as? UIImage
        {
            ivCover.image = image
        }
        else
        {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
