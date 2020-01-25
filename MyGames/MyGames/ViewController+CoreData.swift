//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Fernanda Brum on 19/05/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController
{
    var context: NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // estamos pegando a nossa classe AppDelegate, que é a classe delegate da nossa aplicação
        
        return appDelegate.persistentContainer.viewContext // assim é como recuperamos o contexto que foi criado lá no core data stack pela nossa persistent container
    }
}
