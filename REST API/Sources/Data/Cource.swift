//
//  Cource.swift
//  REST API
//
//  Created by Дмитрий Тараканов on 29.11.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation

struct Cource : Codable {
    
    let event: Event
    
}

struct Event : Codable {
    
    let title: String
    let dayes: [Day]
    
}

struct Day : Codable {
    
    let title: String
    let items: [Item]
}

struct Item : Codable {
    
    let itemDescription: String
    let title: String
    let presenterName: String
    let links: [Link]
    let timeString: String
}

struct Link: Codable {
    
    let url: String
    let title: String
}
