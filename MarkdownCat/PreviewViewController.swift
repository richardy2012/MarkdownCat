//
//  PreviewViewController.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/2/19.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var contentPreview: UIWebView!
    
    var htmlContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentPreview.loadHTMLString(htmlContent!, baseURL: nil)
    }

    
    // MARK: Action
    @IBAction func donePreview(sender: UIBarButtonItem) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
