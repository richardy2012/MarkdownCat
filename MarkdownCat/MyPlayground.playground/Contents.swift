//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let source = "Hello world, \n\nthis is worldshengjie"
let regex = try? NSRegularExpression(pattern: "world", options: [])
regex?.enumerateMatchesInString(source, options: [], range: NSMakeRange(0, 15), usingBlock: { (result, flag, point) -> Void in
    print("match!")
})

regex?.numberOfMatchesInString(source, options: [], range: NSMakeRange(0, source.characters.count))