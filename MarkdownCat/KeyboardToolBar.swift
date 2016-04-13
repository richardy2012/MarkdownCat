//
//  KeyboardToolBar.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/4/6.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit

class KeyboardToolBar: UIScrollView {
    
    var toolBarButtons = Array<UIButton>()
    let buttonSize = CGSize(width: 65, height: 40)
    let buttonSpace: CGFloat = 1
    let toolBarHeight: CGFloat = 40
    var topBorder = CALayer()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.showsHorizontalScrollIndicator = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
    func addButtons(buttons: [UIButton]) {
        var originX = buttonSpace
        for button in buttons {
            button.frame.size = buttonSize
            button.frame.origin = CGPointMake(originX, (toolBarHeight - buttonSize.height) / 2)
            originX += buttonSize.width + buttonSpace
            self.addSubview(button)
        }
        toolBarButtons += buttons
        self.contentSize = CGSizeMake(originX, toolBarHeight)
    }

}
