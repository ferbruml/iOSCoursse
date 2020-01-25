//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Fernanda Brum on 19/05/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import CoreData

// classe auxiliar para se usar as plataformas em todo o código
class ConsolesManager
{
    static let shared = ConsolesManager() // garantindo acessar sempre o mesmo consolemanager, ou seja, sempre acessar as mesmas plataformas - buscamos 1 vez ( fetch ) e persistimos na instância
    var consoles: [Console] = []
    
    func loadConsoles(with context: NSManagedObjectContext)
    {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            consoles = try context.fetch(fetchRequest) // 2o método: chamada retorna diretamente os objetos buscados, sem precisar de delegate - é mais direto, mas menos poderoso; PARA POUCOS DADOS ESTÁ OK!!!!
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext)
    {
        let console = consoles[index]
        
        context.delete(console) // DELETOU DO CONTEXTO, AINDA NÃO ESTÁ PERSISTIDO NA BASE!!!
        
        do
        {
            try context.save() // AGORA SIM - EFETIVAMENTE COMMITANDO E PERSISTINDO NA BASE!!!
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    private init() // ao se criar uma instância singleton, o construtor deve ser privado
    {
        
    }
    
}
