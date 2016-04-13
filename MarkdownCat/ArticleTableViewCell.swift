//
//  ArticleTableViewCell.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/2/24.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileDate: UILabel!
    @IBOutlet weak var fileSize: UILabel!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
