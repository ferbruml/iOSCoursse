//
//  QuotesViewController.swift
//  Pensamentos
//
//  Created by Fernanda Brum on 07/01/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    @IBOutlet weak var ivPhotoBg: UIImageView!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbQuotes: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var ctTop: NSLayoutConstraint!
    
    let config = Configuration.shared
    
    let quotesManager = QuotesManager()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
            self.formatView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { // vamos implementar este método pq queremos q apareça um novo pensamento cada vez que entrarmos na tela
        super.viewWillAppear(animated)
        
        formatView()
    }
    
    // poderemos trocar o pensamento tocando na tela, sem aguardar o timeout da troca
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareQuote()
    }
    
    func formatView() {
        view.backgroundColor = config.colorScheme == 0 ? .white : UIColor(red: 156.0/255.0, green: 68.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        
        lbQuotes.textColor = config.colorScheme == 0 ? .black : .white
        
        lbAuthor.textColor = config.colorScheme == 0 ? UIColor(red: 192.0/255.0, green: 96.0/255.0, blue: 49.0/255.0, alpha: 1.0) : .yellow
        
        // preparar um pensamento para ser apresentado
        prepareQuote()
    }
    
    // prepara um pensamento e o mostra na tela
    func prepareQuote() {
        timer?.invalidate() // estamos invalidando o agendamento anterior, já q este método é executado cada vez que entramos na tela e pode já haver um timer rodando de antes, o que pode fazer com que vejamos 2x a mesma coisa acontecendo - É UMA BOA PRÁTICA!!!
        
        if config.autoRefresh {
            // agendamos para daqui 8s a closure começar a acontecer
            timer = Timer.scheduledTimer(withTimeInterval: config.timeInterval, repeats: true) { (timer) in // closure retorna o próprio timer
                self.showRandomQuote() // como estamos dentro de uma closure, para utilizar membros da classe precisamos do self
            }
        }
        
        // e já mostramos um pensamento na tela no momento em que agendamos a ação
        showRandomQuote()
    }
    
    // mostra o pensamento na tela, pedindo um pensamento para o QuotesManager
    func showRandomQuote() {
        let quote = quotesManager.getRandomQuote()
        lbQuotes.text = quote.quote
        lbAuthor.text = quote.author
        ivPhoto.image = UIImage(named: quote.image)
        ivPhotoBg.image = ivPhoto.image
        
        setAlpha(0.0, 0.0, 0.0, 0.0, 50)
        
        UIView.animate(withDuration: 2.5) {
            self.setAlpha(1.0, 1.0, 1.0, 0.25, 10) // como estamos dentro de uma closure, para utilizar membros da classe precisamos do self
        }
    }
    
    func setAlpha(_ valuelbQuote: CGFloat, _ valuelbAuthor: CGFloat, _ valueivPhoto: CGFloat, _ valueivPhotoBg: CGFloat, _ valueLayoutConstraintTop: CGFloat) {
        lbQuotes.alpha = valuelbQuote
        lbAuthor.alpha = valuelbAuthor
        ivPhoto.alpha = valueivPhoto
        ivPhotoBg.alpha = valueivPhotoBg
        ctTop.constant = valueLayoutConstraintTop
        
        view.layoutIfNeeded() // pede para a view reposicionar todo o mundo na tela - necessário qdo trabalhamos com animação de constraints
    }
}
