//
//  HighlightTextView.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/3/5.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit

class HighlightTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        let layoutManager = NSLayoutManager()
        let textStorage = HighlightTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        
        super.init(frame: frame, textContainer: textContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        let textView = UITextView(coder: aDecoder)
        let layoutManager = NSLayoutManager()
        let textStorage = HighlightTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        
        super.init(frame: (textView?.frame)!, textContainer: textContainer)
    }

}
