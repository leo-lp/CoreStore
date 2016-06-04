//
//  From.swift
//  CoreStore
//
//  Copyright © 2015 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData


// MARK: - From

/**
 A `From` clause specifies the source entity and source persistent store for fetch and query methods. A common usage is to just indicate the entity:
 ```
 let person = transaction.fetchOne(From(MyPersonEntity))
 ```
 For cases where multiple `NSPersistentStore`s contain the same entity, the source configuration's name needs to be specified as well:
 ```
 let person = transaction.fetchOne(From<MyPersonEntity>("Configuration1"))
 ```
 */
public struct From<T: NSManagedObject> {
    
    /**
     Initializes a `From` clause.
     ```
     let people = transaction.fetchAll(From<MyPersonEntity>())
     ```
     */
    public init(){
        
        self.init(entityClass: T.self)
    }
    
    /**
     Initializes a `From` clause with the specified entity type.
     ```
     let people = transaction.fetchAll(From<MyPersonEntity>())
     ```
     
     - parameter entity: the `NSManagedObject` type to be created
     */
    public init(_ entity: T.Type) {
        
        self.init(entityClass: entity)
    }
    
    /**
     Initializes a `From` clause with the specified entity class.
     ```
     let people = transaction.fetchAll(From<MyPersonEntity>())
     ```
     
     - parameter entityClass: the `NSManagedObject` class type to be created
     */
    public init(_ entityClass: AnyClass) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass)
    }
    
    /**
     Initializes a `From` clause with the specified configurations.
     ```
     let people = transaction.fetchAll(From<MyPersonEntity>(nil, "Configuration1"))
     ```
     
     - parameter configuration: the `NSPersistentStore` configuration name to associate objects from. This parameter is required if multiple configurations contain the created `NSManagedObject`'s entity type. Set to `nil` to use the default configuration.
     - parameter otherConfigurations: an optional list of other configuration names to associate objects from (see `configuration` parameter)
     */
    public init(_ configuration: String?, _ otherConfigurations: String?...) {
        
        self.init(entityClass: T.self, configurations: [configuration] + otherConfigurations)
    }
    
    /**
     Initializes a `From` clause with the specified configurations.
     ```
     let people = transaction.fetchAll(From<MyPersonEntity>(["Configuration1", "Configuration2"]))
     ```
     
     - parameter configurations: a list of `NSPersistentStore` configuration names to associate objects from. This parameter is required if multiple configurations contain the created `NSManagedObject`'s entity type. Set to `nil` to use the default configuration.
     */
    public init(_ configurations: [String?]) {
        
        self.init(entityClass: T.self, configurations: configurations)
    }
    
    /**
     Initializes a `From` clause with the specified configurations.
     ```
     let people = transaction.fetchAll(From(MyPersonEntity.self, nil, "Configuration1"))
     ```
     
     - parameter entity: the associated `NSManagedObject` type
     - parameter configuration: the `NSPersistentStore` configuration name to associate objects from. This parameter is required if multiple configurations contain the created `NSManagedObject`'s entity type. Set to `nil` to use the default configuration.
     - parameter otherConfigurations: an optional list of other configuration names to associate objects from (see `configuration` parameter)
     */
    public init(_ entity: T.Type, _ configuration: String?, _ otherConfigurations: String?...) {
        
        self.init(entityClass: entity, configurations: [configuration] + otherConfigurations)
    }
    
    /**
     Initializes a `From` clause with the specified configurations.
     ```
     let people = transaction.fetchAll(From(MyPersonEntity.self, ["Configuration1", "Configuration1"]))
     ```
     
     - parameter entity: the associated `NSManagedObject` type
     - parameter configurations: a list of `NSPersistentStore` configuration names to associate objects from. This parameter is required if multiple configurations contain the created `NSManagedObject`'s entity type. Set to `nil` to use the default configuration.
     */
    public init(_ entity: T.Type, _ configurations: [String?]) {
        
        self.init(entityClass: entity, configurations: configurations)
    }
    
    /**
     Initializes a `From` clause with the specified configurations.
     ```
     let people = transaction.fetchAll(From(MyPersonEntity.self, nil, "Configuration1"))
     ```
     
     - parameter entity: the associated `NSManagedObject` entity class
     - parameter configuration: the `NSPersistentStore` configuration name to associate objects from. This parameter is required if multiple configurations contain the created `NSManagedObject`'s entity type. Set to `nil` to use the default configuration.
     - parameter otherConfigurations: an optional list of other configuration names to associate objects from (see `configuration` parameter)
     */
    public init(_ entityClass: AnyClass, _ configuration: String?, _ otherConfigurations: String?...) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass, configurations: [configuration] + otherConfigurations)
    }
    
    /**
     Initializes a `From` clause with the specified configurations.
     ```
     let people = transaction.fetchAll(From(MyPersonEntity.self, ["Configuration1", "Configuration1"]))
     ```
     
     - parameter entity: the associated `NSManagedObject` entity class
     - parameter configurations: a list of `NSPersistentStore` configuration names to associate objects from. This parameter is required if multiple configurations contain the created `NSManagedObject`'s entity type. Set to `nil` to use the default configuration.
     */
    public init(_ entityClass: AnyClass, _ configurations: [String?]) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass, configurations: configurations)
    }
    
    
    // MARK: Internal
    
    internal let entityClass: AnyClass
    internal let dumpInfo: (key: String, value: Any)?
    
    internal func applyToFetchRequest(fetchRequest: NSFetchRequest, context: NSManagedObjectContext, applyAffectedStores: Bool = true) {
        
        fetchRequest.entity = context.entityDescriptionForEntityClass(self.entityClass)
        if applyAffectedStores {
            
            self.applyAffectedStoresForFetchedRequest(fetchRequest, context: context)
        }
    }
    
    internal func applyAffectedStoresForFetchedRequest(fetchRequest: NSFetchRequest, context: NSManagedObjectContext) -> Bool {
        
        let stores = self.findPersistentStores(context: context)
        fetchRequest.affectedStores = stores
        return stores?.isEmpty == false
    }
    
    internal func upcast() -> From<NSManagedObject> {
        
        return From<NSManagedObject>(
            entityClass: self.entityClass,
            dumpInfo: self.dumpInfo,
            findPersistentStores: self.findPersistentStores
        )
    }
    
    
    // MARK: Private
    
    private let findPersistentStores: (context: NSManagedObjectContext) -> [NSPersistentStore]?
    
    private init(entityClass: AnyClass) {
        
        self.init(
            entityClass: entityClass,
            dumpInfo: nil,
            findPersistentStores: { (context: NSManagedObjectContext) -> [NSPersistentStore]? in
                
                return context.parentStack?.persistentStoresForEntityClass(entityClass)
            }
        )
    }
    
    private init(entityClass: AnyClass, configurations: [String?]) {
        
        let configurationsSet = Set(configurations.map { $0 ?? Into.defaultConfigurationName })
        self.init(
            entityClass: entityClass,
            dumpInfo: ("configurations", configurations),
            findPersistentStores: { (context: NSManagedObjectContext) -> [NSPersistentStore]? in
                
                return context.parentStack?.persistentStoresForEntityClass(entityClass)?.filter {
                    
                    return configurationsSet.contains($0.configurationName)
                }
            }
        )
    }
    
    private init(entityClass: AnyClass, storeURLs: [NSURL]) {
        
        let storeURLsSet = Set(storeURLs)
        self.init(
            entityClass: entityClass,
            dumpInfo: ("storeURLs", storeURLs),
            findPersistentStores: { (context: NSManagedObjectContext) -> [NSPersistentStore]? in
                
                return context.parentStack?.persistentStoresForEntityClass(entityClass)?.filter {
                    
                    return $0.URL != nil && storeURLsSet.contains($0.URL!)
                }
            }
        )
    }
    
    private init(entityClass: AnyClass, persistentStores: [NSPersistentStore]) {
        
        let persistentStores = Set(persistentStores)
        self.init(
            entityClass: entityClass,
            dumpInfo: ("persistentStores", persistentStores),
            findPersistentStores: { (context: NSManagedObjectContext) -> [NSPersistentStore]? in
                
                return context.parentStack?.persistentStoresForEntityClass(entityClass)?.filter {
                    
                    return persistentStores.contains($0)
                }
            }
        )
    }
    
    private init(entityClass: AnyClass, dumpInfo: (key: String, value: Any)?, findPersistentStores: (context: NSManagedObjectContext) -> [NSPersistentStore]?) {
        
        self.entityClass = entityClass
        self.dumpInfo = dumpInfo
        self.findPersistentStores = findPersistentStores
    }
    
    
    // MARK: Deprecated
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ storeURL: NSURL, _ otherStoreURLs: NSURL...) {
        
        self.init(entityClass: T.self, storeURLs: [storeURL] + otherStoreURLs)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ storeURLs: [NSURL]) {
        
        self.init(entityClass: T.self, storeURLs: storeURLs)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entity: T.Type, _ storeURL: NSURL, _ otherStoreURLs: NSURL...) {
        
        self.init(entityClass: entity, storeURLs: [storeURL] + otherStoreURLs)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entity: T.Type, _ storeURLs: [NSURL]) {
        
        self.init(entityClass: entity, storeURLs: storeURLs)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entityClass: AnyClass, _ storeURL: NSURL, _ otherStoreURLs: NSURL...) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass, storeURLs: [storeURL] + otherStoreURLs)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entityClass: AnyClass, _ storeURLs: [NSURL]) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass, storeURLs: storeURLs)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ persistentStore: NSPersistentStore, _ otherPersistentStores: NSPersistentStore...) {
        
        self.init(entityClass: T.self, persistentStores: [persistentStore] + otherPersistentStores)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ persistentStores: [NSPersistentStore]) {
        
        self.init(entityClass: T.self, persistentStores: persistentStores)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entity: T.Type, _ persistentStore: NSPersistentStore, _ otherPersistentStores: NSPersistentStore...) {
        
        self.init(entityClass: entity, persistentStores: [persistentStore] + otherPersistentStores)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entity: T.Type, _ persistentStores: [NSPersistentStore]) {
        
        self.init(entityClass: entity, persistentStores: persistentStores)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entityClass: AnyClass, _ persistentStore: NSPersistentStore, _ otherPersistentStores: NSPersistentStore...) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass, persistentStores: [persistentStore] + otherPersistentStores)
    }
    
    /**
     Deprecated. Use initializers that accept configuration names.
     */
    @available(*, deprecated=2.0.0, message="Use initializers that accept configuration names.")
    public init(_ entityClass: AnyClass, _ persistentStores: [NSPersistentStore]) {
        
        CoreStore.assert(
            entityClass is T.Type,
            "Attempted to create generic type \(cs_typeName(From<T>)) with entity class \(cs_typeName(entityClass))"
        )
        self.init(entityClass: entityClass, persistentStores: persistentStores)
    }
}
