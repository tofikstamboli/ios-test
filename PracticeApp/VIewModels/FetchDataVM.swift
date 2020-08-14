//
//  FetchDataVM.swift
//  PracticeApp
//
//  Created by Indiawyn Gaming on 13/08/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import Foundation
import CoreData

// ViewModel for fetch data from CoreData or Http Server
class FetchDataVM {
    
    
   var coreDataClass = CoreDataClass()
    
    /* fetching data from core data , If result is empty then fetch data from Http Url and save it in CoreData entity and store in Core data */
    
    func fetchData(resp : @escaping([DataModel]?) -> Void , issue : @escaping(String?) -> Void)  {
        
        coreDataClass.retrieveDataFromDB(success: { data in
            
            // return data from Core data
            resp(data)
            
        }, failure: { _ in // Make HTTP call
            
            self.fetchHttpData(success: { data in
                
                // save data in Core data entity
                self.coreDataClass.saveData(arrayOfData: data)
                //return data
                resp(data)
                
            }, failure: { error in
                issue(error) // return if error found
            })
        })
        
    }
    
    
    
    
    // fetch HTTP Url data from ApiClass.swift
    func fetchHttpData(success:@escaping ([DataModel]) -> Void, failure:@escaping (String) -> Void) {
                  let decoder = JSONDecoder()
                      ApiClass.getData(suceess: {jsn in
        
                          do {
                            let model = try decoder.decode([DataModel].self, from: jsn as! Data)
                            success(model)
                          } catch let err {
                              print(err)
                            failure(err.localizedDescription)
                          }
        
                      }, error: {error in
                       
                        failure(error!.localizedDescription)
                 })
    }
    
}
