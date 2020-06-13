//
//  Libro+CoreDataProperties.swift
//  CRUD5LIBROS1709462015
//
//  Created by Miguel on 6/12/20.
//  Copyright © 2020 UTEC. All rights reserved.
//

import Foundation
import CoreData


extension Libro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Libro> {
        return NSFetchRequest<Libro>(entityName: "Libro");
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var pages: Int32
    @NSManaged public var publicationYear: Int32

}
