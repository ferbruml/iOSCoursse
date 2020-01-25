//
//  WorldCupTableViewCell.swift
//  CampeoesDaCopa
//
//  Created by Fernanda Brum on 15/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

// É UMA CONTROLLER PQ ESTÁ CONTROLANDO UMA VIEW QUE É UMA CÉLULA
class WorldCupTableViewCell: UITableViewCell {

    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var ivWinner: UIImageView!
    @IBOutlet weak var lbWinner: UILabel!
    @IBOutlet weak var lbWinnerScore: UILabel!
    @IBOutlet weak var ivVice: UIImageView!
    @IBOutlet weak var lbVice: UILabel!
    @IBOutlet weak var lbViceScore: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MÉTODO PARA PREPARAR A COPA QUE A TABLEVIEW ESTÁ PREENCHENDO NAQUELA CÉLULA
    func prepare(with cup: WorldCup) {
        // PREENCHE COM OS DADOS QUE ESTÃO VINDO DA TABLEVIEW
        lbYear.text = "\(cup.year)"
        ivWinner.image = UIImage(named: cup.winner)
        ivVice.image = UIImage(named: cup.vice)
        lbWinner.text = cup.winner
        lbVice.text = cup.vice
        lbCountry.text = cup.country
        lbWinnerScore.text = cup.winnerScore
        lbViceScore.text = cup.viceScore
    }

}
