//
//  WorldCupViewController.swift
//  CampeoesDaCopa
//
//  Created by Fernanda Brum on 12/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class WorldCupViewController: UIViewController {

    var worldCup: WorldCup!
    
    @IBOutlet weak var ivWinner: UIImageView!
    @IBOutlet weak var lbWinner: UILabel!
    @IBOutlet weak var ivVice: UIImageView!
    @IBOutlet weak var lbVice: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // PRINTA NO CONSOLE - DEBUG DE CÓDIGO
        //print("Ano da copa selecionada: \(worldCup.year)")
        
        title = "Copa do Mundo: \(worldCup.year)"
        
        ivWinner.image = UIImage(named: "\(worldCup.winner).png")
        ivVice.image = UIImage(named: "\(worldCup.vice).png")
        lbWinner.text = worldCup.winner
        lbVice.text = worldCup.vice
        lbScore.text = "\(worldCup.winnerScore) x \(worldCup.viceScore)"
    }
    
    
}

extension WorldCupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return worldCup.matches.count // QUANTAS FASES TIVER, SERÁ O NUM DE SEÇÕES DA TABLEVIEW; E CADA MATCH TEM FASES
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let games = worldCup.matches[section].games // RECUPERA OS JOGOS DE UMA FASE
        
        return games.count // O TOTAL DE JOGOS É O TOTAL DE LINHAS EM CADA SESSÁO
    }
    
    // MOMENTO EM QUE CONSTRUÍMOS A CÉLULA
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GamesTableViewCell
        
        let match = worldCup.matches[indexPath.section] // RECUPERAR A FASE DA SESSÃO ATUAL
        let game = match.games[indexPath.row] // RECUPERAR A PARTIDA
        
        cell.prepare(with: game)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let match = worldCup.matches[section]
        
        return match.stage // NOME DA FASE
    }
}

extension WorldCupViewController: UITableViewDelegate {
    
}
