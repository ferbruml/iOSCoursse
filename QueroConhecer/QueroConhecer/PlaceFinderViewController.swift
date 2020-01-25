//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Fernanda Brum on 20/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceFinderDelegate: class
{
    func addPlace(_ place: Place)
}

class PlaceFinderViewController: UIViewController {

    enum PlaceFinderMessageType
    {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    var place: Place!
    var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:))) // chama a action no target ( classe ) especificado
        gesture.minimumPressDuration = 2.0 // configurando os 2s do trigger do gesture
        mapView.addGestureRecognizer(gesture) // informando que o gesture só vale quando ocorrer no mapView
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer)
    {
        if gesture.state == .began // precisamos testar o estado do gesto, pois, senão, será disparado por qualquer gesto
        {
            load(show: true)
            
            let point = gesture.location(in: mapView) // coordenadas x,y da UIKit do ponto que o user tocou dentro da view, no caso, do mapView
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView) // convertendo para latitude/longitude as coordenadas da tela dentro do mapView
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in self.trataRetorno(placemarks, error) }
        }
    }
    
    // pega um placemark a partir de um texto ( user )
    @IBAction func findCity(_ sender: UIButton) {
        tfCity.resignFirstResponder() // 1a coisa: sumir com o teclado, pois o user já digitou e pressionou enter
        let address = tfCity.text!
        
        load(show: true)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in self.trataRetorno(placemarks, error) }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool
    {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
        }
        
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        // agora que já temos o place, vamos levar o user no mapa para o local pesquisado
        // 1o: definir os limites da região a se mostrar no mapa
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        // 2o: mostrar a região no mapa
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        return true
    }
    
    // criando um alerta utilizando o sistema de alertas do swift
    func showMessage(type: PlaceFinderMessageType)
    {
        // todo alerta tem um título principal e uma mensagem
        let title: String, message: String
        var hasConfirmation: Bool = false // o alerta precisa de um botão de confirmação?
        
        switch type {
        case .confirmation(let name):
            title = "Local encontrado"
            message = "Deseja adicionar \(name)?"
            
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Message"
            message = errorMessage
        }
        
        // criando o alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // criando os botões do alerta e adicionando as ações no alerta
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil) // handler é nil pq só queremos que a tela feche quando o user clicar em Cancelar
        alert.addAction(cancelAction)
        
        if hasConfirmation
        {
            let confirmAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.delegate?.addPlace(self.place)
                
                self.dismiss(animated: true, completion: nil) // voltando para a tela anterior
            }
            
            alert.addAction(confirmAction)
        }
        
        // apresentar o alerta na tela
        present(alert, animated: true, completion: nil) // completion é nil pq não queremos que nada aconteça quando a modal terminar
    }
    
    func trataRetorno(_ placemarks: [CLPlacemark]?, _ error: Error?) // pegando um placemark a partir de uma localização ( onde o user clicou no mapa )
    {
        load(show: false)
    
        /*
         guard let placemark = placemarks?.first else { return }
         print(Place.getFormattedAddress(with: placemark))
         */
    
        if error == nil
        {
            if !self.savePlace(with: placemarks?.first)
            {
                self.showMessage(type: .error("Não foi encontrado nenhum local com este nome."))
            }
        }
        else
        {
            self.showMessage(type: .error("Erro desconhecido."))
        }
    }
    
    func load(show: Bool)
    {
        viLoading.isHidden = !show
        
        if show {
            aiLoading.startAnimating()
        }
        else {
            aiLoading.stopAnimating()
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil) // ASSIM É QUE SE FECHA UMA TELA MODAL
    }
}
