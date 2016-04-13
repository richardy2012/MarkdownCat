//
//  HighlightTextStorage.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/2/29.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit

class HighlightTextStorage: NSTextStorage {
    var textContent = NSMutableAttributedString()
    
    override var string: String {
        return textContent.string
    }
    
    // MARK: Markdown highlight constants
    enum MarkdownType {
        case head1, head2, head3, head4, head5, head6
        case blockQuotes
        case strong
        case italic
        case code
        case link
        case ordered
        case disordered
    }
        
    let markdownPattern: [MarkdownType: String] = [
        .head1: "^# [^ ].*$",
        .head2: "^## [^ ].*",
        .head3: "^### [^ ].*",
        .head4: "^#### [^ ].*",
        .head5: "^##### [^ ].*",
        .head6: "^###### [^ ].*",
        .strong: "\\*\\*[^ ].*?[^ ]\\*\\*",
//        .italic: "\\*[^ ].*?[^ ]\\*",
        .code: "`.*?`",
        .link: "\\[(.*?)\\]\\((.*?)\\)",
        .blockQuotes: "^> .*?$",
        .ordered: "^[0-9][0-9]?\\. .*?$",
        .disordered: "^- .*?$",
    ]
    
    let markdownFont: [MarkdownType: UIFont] = [
        .head1: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1),
        .head2: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2),
        .head3: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3),
        .head4: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3),
        .head5: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3),
        .head6: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3),
        .strong: UIFont.boldSystemFontOfSize(17),
//        .italic: UIFont.italicSystemFontOfSize(17),
        .code: UIFont.systemFontOfSize(17),
        .link: UIFont.systemFontOfSize(17),
        .blockQuotes: UIFont.systemFontOfSize(17),
        .ordered: UIFont.systemFontOfSize(17),
        .disordered: UIFont.systemFontOfSize(17),
    ]
    
    let markdownForegroundColor: [MarkdownType: UIColor] = [
        .head1: UIColor.blackColor(),
        .head2: UIColor.blackColor(),
        .head3: UIColor.blackColor(),
        .head4: UIColor.blackColor(),
        .head5: UIColor.blackColor(),
        .head6: UIColor.blackColor(),
        .strong: UIColor.blackColor(),
//        .italic: UIColor.blackColor(),
        .code: UIColor.init(red: 0.44, green: 0.72, blue: 0.45, alpha: 1),
        .link: UIColor.init(red: 0.53, green: 0.54, blue: 0.79, alpha: 1),
        .blockQuotes: UIColor.init(red: 0.80, green: 0.31, blue: 0.11, alpha: 1),
        .ordered: UIColor.init(red: 0.25, green: 0.58, blue: 0.78, alpha: 1),
        .disordered: UIColor.init(red: 0.96, green: 0.49, blue: 0.26, alpha: 1)
    ]
    
    let markdownBackgroundColor: [MarkdownType: UIColor] = [
        .code: UIColor.init(red: 0.44, green: 0.72, blue: 0.45, alpha: 1)
    ]
    
    // MARK: Customized methods
    func matchMarkdownKeyWords() {
        let paragraphRange = (self.string as NSString).paragraphRangeForRange(self.editedRange)
        removeAttribute(NSFontAttributeName, range: paragraphRange)
        removeAttribute(NSForegroundColorAttributeName, range: paragraphRange)
        
        self.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)], range: paragraphRange)
        for (type, pattern) in markdownPattern {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.AnchorsMatchLines]) {
                regex.enumerateMatchesInString(self.string, options: [], range: paragraphRange, usingBlock: { (result, flags, pointer) -> Void in
                    if let font = self.markdownFont[type], let fgColor = self.markdownForegroundColor[type] {
                        self.setAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: fgColor], range: result!.range)
                    }
                })
            }
        }
    }
    
    // MARK: Override methods
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return (textContent.attributesAtIndex(location, effectiveRange: range))
    }
   
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        textContent.replaceCharactersInRange(range, withString: str)
        self.edited(.EditedCharacters, range: range, changeInLength: str.characters.count - range.length)
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        textContent.setAttributes(attrs, range: range)
        self.edited(.EditedAttributes, range: range, changeInLength: 0)
    }
    
    override func processEditing() {
        matchMarkdownKeyWords()
        
        super.processEditing()
    }
    
    func appendContent(content: String) {
        
    }
}
