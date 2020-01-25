//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Fernanda Brum on 13/05/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadConsoles()
    }
    
    func loadConsoles()
    {
        consolesManager.loadConsoles(with: context)
        
        tableView.reloadData()
    }
    
    @IBAction func addConsole(_ sender: UIBarButtonItem)
    {
        showAlert(with: nil)
    }
    
    func showAlert(with console: Console?) // console é optional pq podemos ou não ter um sender, dependendo do que queremos fazer
    {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in // textField me dá acesso ao próprio text field criado pelo método
            textField.placeholder = "Nome da plataforma"
            
            if let name = console?.name
            {
                textField.text = name
            }
        }
        
        // CONFIGURANDO O BOTÃO DE AÇÃO
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in // essa closure é a ação que executará quando se clicar no botão
            let console = console ?? Console(context: self.context) // se consegurimos desembrulhar o console, ok; senão, cria um novo
            console.name = alert.textFields?.first?.text // SABEMOS QUE SÓ HÁ 1 TEXTFIELD NO ARRAY, POR ISSO O FIRST!!!
            
            do
            {
                try self.context.save()
                
                self.loadConsoles()
            }
            catch
            {
                print(error.localizedDescription)
            }
        }))
        
        // CONFIGURANDO O BOTÃO DE CANCELAR
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)) // o botão não fará nada
        
        // CONFIGURANDO A COR DO ALERTA PARA NÃO FICAAR COM A DO SISTEMA
        alert.view.tintColor = UIColor(named: "second")
        
        // EXIBINDO O ALERTA
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return consolesManager.consoles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
