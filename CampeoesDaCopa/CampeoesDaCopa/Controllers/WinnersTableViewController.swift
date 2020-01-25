//
//  WinnersTableViewController.swift
//  CampeoesDaCopa
//
//  Created by Fernanda Brum on 12/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class WinnersTableViewController: UITableViewController {

    let WCManager = WorldCupManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WCManager.loadWorldCups()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! WorldCupViewController
        let worldCup = WCManager.worldCups[tableView.indexPathForSelectedRow!.row]
        vc.worldCup = worldCup
    }

    // MARK: - Table view data source

    /*          ESTE MÉTODO PODE SER COMENTADO QUANDO A TABLE VIEW POSSUI SOMENTE 1 SECTION, QUE É O NOSSO CASO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return WCManager.worldCups.count // RETORNA O NUM DE LINHAS QUE A TABLE CONTERÁ
    }

    // CHAMADO SEMPRE QUE A TABLE FOR APRESENTAR UMA CÉLULA ( QUANDO ELA ESTÁ PREPARANDO UMA CÉULA PARA EXIBIR )
    // IndexPath -> QUAL SECTION E QUAL LINHA DENTRO DESTA SECTION A CÉLULA SERÁ CONSTRUÍDA
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorldCupTableViewCell

        let worldCup = WorldCupManager.shared.worldCups[indexPath.row]
        cell.prepare(with: worldCup)
        
        /* COMENTADO - ERA UTILIZADO QDO O STYLE DA CELL ERA SUBTITLE, AGORA É CUSTOM
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         
        let worldCup = WorldCupManager.shared.worldCups[indexPath.row]
         
        cell.textLabel?.text = "Copa \(worldCup.year) - \(worldCup.country)"
        cell.detailTextLabel?.text = "\(worldCup.winner) vs \(worldCup.vice)"
        cell.imageView?.image = UIImage(named: "\(worldCup.winner).png")
        */
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
