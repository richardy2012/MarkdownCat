//
//  Article.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/2/19.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import Foundation

class Article: NSObject, NSCoding {
    
    // MARK: Properties
    var title: String = "New File"
    var content: String = ""
    var size: Int
    var date: NSDate
    
    struct PropertyKey {
        static let titleKey = "title"
        static let contentKey = "content"
        static let sizeKey = "size"
        static let dateKey = "date"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("articles")

    
    // MARK: Initializer
    init(title: String = "New File", content: String = "", date: NSDate = NSDate()) {
        self.title = title
        self.content = content
        self.size = content.characters.count
        self.date = date
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let content = aDecoder.decodeObjectForKey(PropertyKey.contentKey) as! String
        _ = aDecoder.decodeObjectForKey(PropertyKey.sizeKey) as! Int
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        self.init(title: title, content: content, date: date)
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(content, forKey: PropertyKey.contentKey)
        aCoder.encodeObject(size, forKey: PropertyKey.sizeKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
    }
}