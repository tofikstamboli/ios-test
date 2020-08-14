//
//  CoreDataClass.swift
//  PracticeApp
//
//  Created by Indiawyn Gaming on 14/08/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import Foundation
import CoreData

//Class for core data operations
class CoreDataClass {
    
    //Context fore core data operations
    var context : NSManagedObjectContext!
          
          init()
          {
              //setup with coredata manager
              context = CoreDataManager.sharedManager.persistentContainer.viewContext
          
          }
    
    // retriving data from dataname entity
    func retrieveDataFromDB(success:@escaping ([DataModel]) -> Void, failure:@escaping (String) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataName")
        var respData = [DataModel]()
        
        do{
            let result = try context.fetch(fetchRequest)
         if result.count > 0 { // check count of data
            for data in result as! [NSManagedObject] {
               let oneModel = DataModel()
                oneModel.id = (data.value(forKey: "id") as? String)
                oneModel.type = (data.value(forKey: "type") as? String)
                oneModel.date = (data.value(forKey: "date") as? String)
                oneModel.data = (data.value(forKey: "data") as? String)
                respData.append(oneModel)
            }
            //return data modeled object
            success(respData)
         } else {
            //return for fetch data from HTTP server
            failure("faild")
         }
        }catch{
            //return for fetch data from HTTP server
            failure("faild")
        }
        
    }
    
    //Save data in core data entity
    func saveData(arrayOfData: [DataModel]){
        
        for userObj in arrayOfData{
            
            do {
                var tableObj = DataName()
                tableObj = NSEntityDescription.insertNewObject(forEntityName: "DataName",into: self.context) as! DataName
                
                tableObj.id = userObj.id
                tableObj.type = userObj.type
                tableObj.date = userObj.date
                tableObj.data = userObj.data
                
                try context.save()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
