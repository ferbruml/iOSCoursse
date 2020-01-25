//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Fernanda Brum on 13/05/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Game>!
    
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center

        loadGames()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "gameSegue"
        {
            let vc = segue.destination as! GameViewController
            
            if let games = fetchedResultController.fetchedObjects // SE CONSEGUIRMOS RECUPERAR A LISTA DE JOGOS
            {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func loadGames()
    {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest() // core data já cria o fetchRequest para a entidade, então não precisamos "criar na mão"
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor] // a ordernação é um array, assim, podemos ter vários descriptors
    
        // 2 formas de requisitar dados no core data:
        // 1. utilizando somente o fetchrequest mesmo
        // 2. utilizando uma fetchedrequestcontroller -> apesar de ser um pouco mais complicada, ela usa delegate, ou seja, quaisquer alterações o meu delegate é informado
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do
        {
            try fetchedResultController.performFetch() // nesse momento ele vai lá no context buscar as info
        }
        catch
        {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0 // fetchedObjects = lista de objetos retornados. USAMOS O OPERADOR DE COALESCÊNCIA NULA PQ É UM OPTIONAL!!!
        
        tableView.backgroundView = count == 0 ? label : nil // FORMATANDO A NOSSA TABLE PARA EXIBIR A MENSAGEM CASO NÃO HAJA JOGO CADASTRADO!!!
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell

        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return cell}
        
        // se conseguiu recuperar o game, vamos formatar a célula lá na GameTableViewCell
        cell.prepare(with: game)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else { return }
            
            context.delete(game)
        }
    }

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


// 1o método: fetch através de delegate - PARA GRANDES QUANTIDADES DE DADOS
extension GamesTableViewController: NSFetchedResultsControllerDelegate
{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type
        {
            case .delete:
                if let indexPath = indexPath
                {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
                break
            default:
            tableView.reloadData() // manter a lista atualizada
        }
    }
}
