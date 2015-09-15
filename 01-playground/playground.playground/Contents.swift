//: Playground - noun: a place where people can play

import UIKit

class DiaryRecord {

    let creationDate: NSDate
    var name: String
    var body: String
    var tags = [String]()
    
    init(creationDate: NSDate) {
        self.creationDate = creationDate
        self.name = ""
        self.body = ""
    }
    
    func fullDescription() -> String {
        var desc: String = formatDate()
        
        if !name.isEmpty {
            desc += "\n"
            desc += name
        }
        
        if !body.isEmpty {
            desc += "\n"
            desc += body
        }
        
        if tags.count > 0 {
            desc += "\n"
            for tag in tags {
                if !tag.isEmpty {
                    desc += " [" + tag + "]"
                }
            }
        }
        
        return desc
    }
    
    private func formatDate() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let formattedDate = dateFormatter.stringFromDate(creationDate)
        
        return formattedDate
    }
    
}

let dr1 = DiaryRecord(creationDate: NSDate())
dr1.fullDescription()

let dr2 = DiaryRecord(creationDate: NSDate())
dr2.name = "Hello"
dr2.body = "My second post with tags"
dr2.tags.append("hi")
dr2.tags.append("first_post")
dr2.tags.append("")
dr2.fullDescription()

let dr3 = DiaryRecord(creationDate: NSDate())
dr3.body = "Post with body only"
dr3.fullDescription()
