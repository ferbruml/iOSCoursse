//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Fernanda Brum on 13/05/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    
    // UTILIZANDO CLOSURE PARA CRIAR E JÁ CONFIGURAR O OBJETO
    // LAZY PQ PRECISAMOS TER ACESSO À CLASSE SEM, AINDA, TER ALIMENTADO TODAS AS PROPRIEDADES DELA; ENTÃO O LAZY SÓ CRIA A CLASSE QUANDO VAMOS UTILIZÁ-LA
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.backgroundColor = .white // TROCANDO A COR PQ NÃO FICOU MUITO BOM O CINZINHA PADRÃO DE FUNDO
        
        return pickerView
    }()
    
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareConsoleTextField()
        
        if game != nil // então é modo de edição
        {
            title = "Editar o jogo"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfTitle.text = game.title
            
            if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console)
            {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
            if let image = game.cover as? UIImage
            {
                ivCover.image = image
                btCover.setTitle(nil, for: .normal) // O TÍTULO DO BOTÃO NÃO DEVE APARECER SE HÁ IMAGEM
            }
            
            if let releaseDate = game.releaseDate
            {
                dpReleaseDate.date = releaseDate
            }
        }
    }
    
    func prepareConsoleTextField()
    {
        // PREPARANDO PARA EXIBIR UMA TOOLBAR COMO VIEW ACESSÓRIA DO TEXTFIELD
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44)) // 44 É MEIO QUE UMA ALTURA PADRÃO PARA TOOLBAR
        toolbar.tintColor = UIColor(named: "main")
        
        // CRIANDO OS BOTÕES QUE COMPORÃO A TOOLBAR, COM MODELOS PADRÃO DE BOTÕES DO SISTEMA
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        // POR PADRÃO, OS BOTÕES DE UMA TOOLBAR SÃO COLOCADOS LADO A LADO DA ESQUERDA PARA DIREITA... ENTÃO ESTE BOTÃO DE SISTEMA ESTILO .flexibleSpace ADICIONA UM ESPAÇO ENTRE ELES
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // INSERINDO DE FATO OS BOTÕES NA TOOLBAR
        toolbar.items = [btCancel, btDone, btFlexibleSpace]
        
        tfConsole.inputView = pickerView // NÃO QUEREMOS QUE O TEXTFIELD MOSTRE O TECLADO, MAS, SIM A PICKER VIEW COM AS PLATAFORMAS
    }
    
    @objc func cancel()
    {
        tfConsole.resignFirstResponder() // TIRANDO O FOCO DO TECLADO PARA ELE SAIR DA TELA
    }
    
    @objc func done()
    {
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name // LINHA SELECIONADA NO ÚNICO COMPONENT QUE TEMOS, POR ISSO 0 ( COLUNA 0 )
        
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        consolesManager.loadConsoles(with: context)
    }
    
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) // EXISTE CÂMERA NO DEVICE? SE SIM, ADICIONA O BOTÃO PARA SELECIONAR A CÂMERA
        {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType)
    {
        let imagePicker = UIImagePickerController() // A CLASSE IMAGEPICKER É O QUE USAMOS PARA DAR ACESSO AO ÁLBUM DE FOTO OU À CÂMERA DO USER
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        if game == nil
        {
            game = Game(context: context)
        }
        
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date // assim é que se recupera a data selecionada no date picker!!!
        
        if !tfConsole.text!.isEmpty // se há alguma plataforma selecionada...
        {
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        
        game.cover = ivCover.image
        
        do
        {
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    // NÚMERO DE COMPONETES ( COLUNAS ) DO PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // NÚMERO DE LINHAS QUE TEREMOS EM CADA COMPONENT ( COLUNA )
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        
        return console.name
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        ivCover.image = image
        btCover.setTitle(nil, for: .normal) // QUERO QUE O BOTÃO EXISTA, MAS NÃO QUERO MAIS VER O  TÍTULO DELE
        
        dismiss(animated: true, completion: nil)
    }
}
