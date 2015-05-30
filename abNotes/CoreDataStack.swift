//
//  CoreDataStack.swift
//  UnCloudNotes
//
//  Created by Saul Mora on 6/17/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: Printable {
  var modelName : String
  var storeName : String
	var options: [NSObject: AnyObject]?

	init(modelName:String, storeName:String, options: [NSObject: AnyObject]? = nil) {
    self.modelName = modelName
    self.storeName = storeName
		self.options = options
  }

  var description : String
    {
    return "context: \(context)\n" +
      "modelName: \(modelName)" +
      //        "model: \(model.entityVersionHashesByName)\n" +
      //        "coordinator: \(coordinator)\n" +
      "storeURL: \(storeURL)\n"
      //        "store: \(store)"
  }

  var modelURL : NSURL {
    return NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
  }

  var storeURL : NSURL {
    var storePaths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
      let storePath = storePaths[0] as! String
      let fileManager = NSFileManager.defaultManager()

      fileManager.createDirectoryAtPath(storePath, withIntermediateDirectories:
        true, attributes: nil, error: nil)
      return NSURL.fileURLWithPath(storePath.stringByAppendingPathComponent(storeName + ".sqlite"))!
  }

  lazy var model : NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: self.modelURL)!

  var store : NSPersistentStore?

  private var _coordinator : NSPersistentStoreCoordinator? = nil
  var coordinator : NSPersistentStoreCoordinator {
    if _coordinator == nil {
      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
      var storeError : NSError?
      store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
				configuration: nil,
        URL: storeURL,
        options: self.options,
        error: nil)
      if storeError != nil {
        println("store error \(storeError!)")
      }
      _coordinator = coordinator
    }
    return _coordinator!
  }

  private var _context : NSManagedObjectContext? = nil
  var context : NSManagedObjectContext {
    if _context == nil {
      let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
      context.persistentStoreCoordinator = coordinator
      _context = context
      println(self)
    }
    return _context!
  }

}