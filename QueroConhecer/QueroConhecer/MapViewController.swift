//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by Fernanda Brum on 20/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    enum MapMessageType
    {
        case routeError // erros ao traçar rotas
        case authorizationWarning // user não liberou acesso aos serviços de localização
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    var places: [Place]!
    var poi: [MKAnnotation] = []
    lazy var locationManager = CLLocationManager() // LAZY: por mais que estejamos instanciando o objeto aqui, ele não será instanciado realmente até que seja utilizado
    var btUserLocation: MKUserTrackingButton!
    var selectedAnnotation: PlaceAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        
        mapView.mapType = .mutedStandard // prioriza as annotations do user em detrimento das info do mapa ( poi, etc )
        
        // só queremos que estas views apareçam quando o user clicar numa annotation
        searchBar.isHidden = true
        viInfo.isHidden = true
        
        if places.count == 1
        {
            title = places[0].name
        }
        else
        {
            title = "Meus locais"
        }
        
        for place in places
        {
            addToMap(place)
        }
        
        showPlaces()
        
        configureLocationButton()
        
        requestUserLocationAuthorization()
    }
    
    // não precisamos implementar a funcionalidade dele, já vem implementada; só mexeremos no visual
    func configureLocationButton()
    {
        btUserLocation = MKUserTrackingButton(mapView: mapView)
        
        btUserLocation.backgroundColor = .white
        btUserLocation.frame.origin.x = 10
        btUserLocation.frame.origin.y = 10
        
        // configurando o layer da view, que é uma propriedade que permite configurar elementos internos da view. É O CORE DE RENDERIZAÇÃO DA VIEW
        btUserLocation.layer.cornerRadius = 5 // arredondando os cantinhos da view
        btUserLocation.layer.borderWidth = 1
        btUserLocation.layer.borderColor = UIColor(named: "main-icon")?.cgColor
    }
    
    // AQUI ESTAMOS VERIFICANDO O STATUS DA AUTORIZAÇÃO, ENTÃO É FEITO SEMPRE QUE O APP ABRE, E APÓS A 1a VEZ DEPOIS DO didChangeAuthorization
    func requestUserLocationAuthorization()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
                case .authorizedAlways, // se já foi autorizado alguma vez, mostra o botão de localização
                     .authorizedWhenInUse:
                    mapView.addSubview(btUserLocation)
                case .denied: // mostrar alerta
                    showMessage(type: .authorizationWarning)
                case .notDetermined: // user nunca viu a tela de autorização ainda
                    locationManager.requestWhenInUseAuthorization() // se o user negar aqui, esta pergunta nunca mais será feita... então
                case .restricted: // por exemplo: negado por controle parental
                    break
            }
        }
        else
        {
            // não dá: não vamos nos preocupar com isso, pois dificilmente ocorre
        }
    }
    
    func addToMap(_ place: Place)
    {
        //let annotation = MKPointAnnotation()
        let annotation = PlaceAnnotation(coordinate: place.coordinate, type: .place)
        
        annotation.title = place.name
        //annotation.coordinate = place.coordinate // nossa var computada já sendo útil!!!!!
        annotation.address = place.address
        
        mapView.addAnnotation(annotation)
    }
    
    func showPlaces()
    {
        mapView.showAnnotations(mapView.annotations, animated: true) // o mapView tenta calcular uma região que mostre todas as annotations que o user tem
    }
    
    func showInfo()
    {
        lbName.text = selectedAnnotation!.title
        lbAddress.text = selectedAnnotation!.address
        viInfo.isHidden = false
    }
    
    @IBAction func showRoute(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse
        {
            showMessage(type: .authorizationWarning)
            
            return
        }
        
        let request = MKDirections.Request()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation!.coordinate))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate))
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil
            {
                if let response = response // DESEMBRULHANDO RESPONSE, POIS É OPTIONAL
                {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    
                    let route = response.routes.first!
                    print("Nome: ", route.name)
                    print("Distância: ", route.distance)
                    print("Duração: ", route.expectedTravelTime)
                    
                    print("==================================")
                    
                    for step in route.steps // o passo a passo para chegar no destino
                    {
                        print("Em \(step.distance) metros, \(step.instructions)")
                    }
                    
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    var annotations = self.mapView.annotations.filter({!($0 is PlaceAnnotation)}) // pega as annotations que não são PlaceAnnotation, ou seja, aqui retorna somente a localização do user
                    annotations.append(self.selectedAnnotation!) // adiciona o destino selecionado pelo user, ou seja, o array contém somente a localização inicial e o destino final
                    
                    self.mapView.showAnnotations(annotations, animated: true) // SEM SETAR O RENDER, QUE O QUE REALMENTE DESENHA NA TELA, NADA ACONTECE!!!!!!
                }
            }
            else
            {
                self.showMessage(type: .routeError)
            }
        }
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        searchBar.isHidden = !searchBar.isHidden
        searchBar.resignFirstResponder()
    }
    
    // criando um alerta utilizando o sistema de alertas do swift
    func showMessage(type: MapMessageType)
    {
        let title = type == .authorizationWarning ? "Aviso" : "Erro"
        let message = type == .authorizationWarning ? "Para utilizar os recursos de localização do App, você precisa permitir o uso na tela de Ajustes" : "Não foi possível encontrar esta rota"
        
        // criando o alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // criando os botões do alerta e adicionando as ações no alerta
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil) // handler é nil pq só queremos que a tela feche quando o user clicar em Cancelar
        alert.addAction(cancelAction)
        
        if type == .authorizationWarning
        {
            let confirmAction = UIAlertAction(title: "Ir para Ajustes", style: .default, handler:
                { (action) in // MANDANDO O USER PARA A TELA DE AJUSTES!!!!
                    if let appSettings = URL(string: UIApplication.openSettingsURLString)
                    {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil) // pegamos a nossa própria aplicação e damos um open no recurso localizado naquela URL
                    }
                })
            
            alert.addAction(confirmAction)
        }
        // apresentar o alerta na tela
        present(alert, animated: true, completion: nil) // completion é nil pq não queremos que nada aconteça quando a modal terminar
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation)
        {
            return nil // daí o mapview escolhe uma annotation padrão
        }
        
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil // 1a vez que está sendo criada uma annotation
        {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.annotation = annotation // precisa realimentar, pois o dequeue traz uma já alimentada - CUIDADO!!!!!
        annotationView?.canShowCallout = true // permite visualizar um "balãozinho" na annotation, para adicionar info
        annotationView?.markerTintColor = type == .place ? UIColor(named: "color-main") : UIColor(named: "poi")
        annotationView?.glyphImage = type == .place ? UIImage(named: "placeGlyph"): UIImage(named: "poiGlyph")
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        
        return annotationView
    }
    
    // método chamado quando clicamos numa annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // alterando a câmera do mapa
        let camera = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        selectedAnnotation = (view.annotation as! PlaceAnnotation)
        
        showInfo()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //  cria o renderizador de polylines
        if overlay is MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "color-main")?.withAlphaComponent(0.8)
            renderer.lineWidth = 5.0
            
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay) // retorna um renderer genérico
    }
}

extension MapViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // usuário escreveu o texto e clicou no botão de pesquisar
        searchBar.isHidden = true // some com a searchbar
        searchBar.resignFirstResponder() // some com o teclado
        
        loading.startAnimating()
        
        // montando a requisição
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text // se digitar café, pesquisa por cafeterias, e não marcas de café, por exemplo
        request.region = mapView.region // a region do mapview é a área que estou visualizando no mapa
        
        // executando o request
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil
            {
                guard let response = response else { self.loading.stopAnimating(); return }
                
                self.mapView.removeAnnotations(self.poi) // limpa todos os poi adicionados anteriormente ao mapa
                self.poi.removeAll() // limpa o array tb, para recomeçar
                
                for item in response.mapItems
                {
                    let annotation = PlaceAnnotation(coordinate: item.placemark.coordinate, type: .poi)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    annotation.address = Place.getFormattedAddress(with: item.placemark)
                    
                    self.poi.append(annotation)
                }
                
                self.mapView.addAnnotations(self.poi)
                
                self.mapView.showAnnotations(self.poi, animated: true)
            }
            
            self.loading.stopAnimating()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate
{
    // AQUI ESTAMOS RESPONDENDO A UMA MUDANÇA DE STATUS
    // utilizado na 1a vez da apresentação da tela de permitir exibir localização do user... nas outras vezes, será feito pelo método requestUserLocationAuthorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true // mandamos o mapview mostrar a localização do user - é equivalente a marcar "User Location" no Attributes Inspector do MapView
            mapView.addSubview(btUserLocation)
            locationManager.startUpdatingLocation() // tracking da mudança da localização do user
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations.last)
        
        // MONITORANDO O USER INDEPENDENTE DELE TER SELECIONADO ISSO NA "SETINHA" DE NAVEGAÇÃO NO MAPA
        if let location = locations.last
        {
            print("Velocidade: ", location.speed)
            
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true) // atualiza a região visível do mapa
        }
    }
}
