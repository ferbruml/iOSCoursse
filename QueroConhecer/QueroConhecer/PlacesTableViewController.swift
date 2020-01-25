//
//  PlacesTableViewController.swift
//  QueroConhecer
//
//  Created by Fernanda Brum on 20/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    var places: [Place] = []
    let ud = UserDefaults.standard
    var lbNoPlaces: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPlaces()
        
        lbNoPlaces = UILabel()
        lbNoPlaces.text = "Cadastre os locais que deseja conhecer\nclicando no botão + acima"
        lbNoPlaces.textAlignment = .center
        lbNoPlaces.numberOfLines = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finderSegue"
        {
            let vc = segue.destination as! PlaceFinderViewController
            vc.delegate = self
        }
        else if segue.identifier == "mapSegue"
        {
            let vc = segue.destination as! MapViewController
            
            switch sender // passando para a próxima tela o(s) place(s) que o user quer visualizar
            {
                case let place as Place:
                    vc.places = [place]
                default:
                    vc.places = places
            }
        }
    }

    func loadPlaces()
    {
        if let placesData = ud.data(forKey: "places")
        {
            do
            {
                places = try JSONDecoder().decode([Place].self, from: placesData)
                
                tableView.reloadData() // recarrega a tabela
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func savePlaces()
    {
        let json = try? JSONEncoder().encode(places)
        
        ud.set(json, forKey: "places")
    }
    
    @objc func showAll()
    {
        performSegue(withIdentifier: "mapSegue", sender: nil) // sender nil pq daí cai no default do switch e a tela recebe todos os places ( método prepare for segue acima )
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0
        {
            let btShowAll = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btShowAll // definindo que o nosso botão criado é o que estará à direita
            
            tableView.backgroundView = nil
        }
        else
        {
            navigationItem.leftBarButtonItem = nil
            
            tableView.backgroundView = lbNoPlaces
        }
        
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let place = places[indexPath.row]
        
        cell.textLabel?.text = place.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // usuário acabou de selecionar a célula
        let place = places[indexPath.row]
        
        performSegue(withIdentifier: "mapSegue", sender: place)
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
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            savePlaces()
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

extension PlacesTableViewController: PlaceFinderDelegate
{
    func addPlace(_ place: Place)
    {
        if !places.contains(place)
        {
            places.append(place)
            
            savePlaces()
            
            tableView.reloadData()
        }
    }
}

