//
//  Cource.swift
//  REST API
//
//  Created by Дмитрий Тараканов on 29.11.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

class Cource: Object, Codable {
    
    @objc dynamic var event: Event?
}

class Event: Object, Codable {
    
    @objc dynamic var title: String = ""
    @objc dynamic var id:    String = ""
    let dayes = List<Day>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case id
        case dayes
    }
    
     required init(from decoder: Decoder) throws
           
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           
        id          = try container.decode(String.self, forKey: .id)
        title       = try container.decode(String.self, forKey: .title)
        let dayList = try container.decode([Day].self, forKey: .dayes)
           
        dayes.append(objectsIn: dayList)
           
        super.init()
    }
    
    required init() {
        super.init()
    }
}

class Day: Object, Codable {
    
    @objc dynamic var title: String = ""
    let items = List<Item>()
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case items
    }
    
    required init(from decoder: Decoder) throws
        
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title        = try container.decode(String.self, forKey: .title)
        let itemList = try container.decode([Item].self, forKey: .items)
        
        items.append(objectsIn: itemList)
        
        super.init()
    }
    
    required init() {
        
        super.init()
    }
}

class Item: Object, Codable {
    
    @objc dynamic var id:              String = ""
    @objc dynamic var itemDescription: String = ""
    @objc dynamic var title:           String = ""
    @objc dynamic var presenterName:   String = ""
    @objc dynamic var timeString:      String = ""
    
    let links = List<Link>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case itemDescription
        case title
        case presenterName
        case timeString
        case links
    }
    
    required init(from decoder: Decoder) throws
        
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id              = try container.decode(String.self, forKey: .id)
        itemDescription = try container.decode(String.self, forKey: .itemDescription)
        title           = try container.decode(String.self, forKey: .title)
        presenterName   = try container.decode(String.self, forKey: .presenterName)
        timeString      = try container.decode(String.self, forKey: .timeString)
        let linkList    = try container.decode([Link].self, forKey: .links)
        
        links.append(objectsIn: linkList)
        
        super.init()
    }
    
    required init() {

        super.init()
    }
}

class Link: Object, Codable {
    
    @objc dynamic var url:   String = ""
    @objc dynamic var title: String = ""
    
    override class func primaryKey() -> String? {
        return "title"
    }
}
