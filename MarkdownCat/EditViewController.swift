//
//  ViewController.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/2/18.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit
import CocoaMarkdown

class EditViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var bodyTextView: UITextView!
    var toolBar: KeyboardToolBar!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var previewButton: UIBarButtonItem!
    
    
    var article: Article?
    var textStorage = HighlightTextStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        createBodyTextView()
        createKeyboardToolbar()
        
        bodyTextView.delegate = self
        
        if let newArticle = article {
            loadArticle(newArticle)
        }
        
        

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillShow), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    
    // MAKR: Action
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        let isAddMode = presentingViewController is UINavigationController
        if isAddMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch sender as! UIBarButtonItem {
        case saveButton:
            article = Article(title: titleTextField.text!, content: bodyTextView.text, date: NSDate())
        case previewButton:
            bodyTextView.resignFirstResponder()
            let desViewController = segue.destinationViewController as! PreviewViewController
            desViewController.htmlContent = parseMarkdownToHtml(bodyTextView.text)
        default:
            print("Nothing")
        }
    }
    
    func parseMarkdownToHtml(MDString: String) -> String {
        let data = MDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let document = CMDocument(data: data, options: .Normalize)
        let renderer = CMHTMLRenderer(document: document)
        return renderer.render()
    }
    
    func loadArticle(article: Article) {
        titleTextField.text = article.title
        bodyTextView.text = article.content
    }
    
    func inputCode() {
        if let range = bodyTextView.selectedTextRange {
            let originRange = bodyTextView.selectedRange
            bodyTextView.replaceRange(range, withText: "`Code`")
            bodyTextView.selectedRange = NSMakeRange(originRange.location + 1, 4)
        }
    }
    
    func inputStrong() {
        if let range = bodyTextView.selectedTextRange {
            let originRange = bodyTextView.selectedRange
            bodyTextView.replaceRange(range, withText: "**Strong**")
            bodyTextView.selectedRange = NSMakeRange(originRange.location + 2, 6)
        }
    }
    
    func inputItalic() {
        if let range = bodyTextView.selectedTextRange {
            let originRange = bodyTextView.selectedRange
            bodyTextView.replaceRange(range, withText: "*Italic*")
            bodyTextView.selectedRange = NSMakeRange(originRange.location + 1, 6)
        }
    }
    
    func inputQuotation() {
        bodyTextView.text = bodyTextView.text + "\n> "
    }
    
    func inputDisorderList() {
        bodyTextView.text = bodyTextView.text + "\n- Item1\n- Item2\n- Item3"
    }
    
    func inputOrderList() {
        bodyTextView.text = bodyTextView.text + "\n1. Item1\n2. Item2\n3. Item3"
    }
    
    func inputLine() {
        bodyTextView.text = bodyTextView.text + "\n-----"
    }
    
    func inputLink() {
        if let range = bodyTextView.selectedTextRange {
            let originRange = bodyTextView.selectedRange
            bodyTextView.replaceRange(range, withText: "[This Link](http://...)")
            bodyTextView.selectedRange = NSMakeRange(originRange.location + 1, 9)
        }
    }
    
    func inputTitle1() {
        bodyTextView.text = bodyTextView.text + "\n# Title1"
        bodyTextView.selectedRange = NSMakeRange(bodyTextView.selectedRange.location - 6, 6)
    }
    
    func inputTitle2() {
        bodyTextView.text = bodyTextView.text + "\n# Title2"
        bodyTextView.selectedRange = NSMakeRange(bodyTextView.selectedRange.location - 6, 6)
    }
    
    func inputTitle3() {
        bodyTextView.text = bodyTextView.text + "\n# Title3"
        bodyTextView.selectedRange = NSMakeRange(bodyTextView.selectedRange.location - 6, 6)
    }
    
    func inputTitle4() {
        bodyTextView.text = bodyTextView.text + "\n# Title4"
        bodyTextView.selectedRange = NSMakeRange(bodyTextView.selectedRange.location - 6, 6)
    }
    
    func inputTitle5() {
        bodyTextView.text = bodyTextView.text + "\n# Title5"
        bodyTextView.selectedRange = NSMakeRange(bodyTextView.selectedRange.location - 6, 6)
    }
    
    func inputTitle6() {
        bodyTextView.text = bodyTextView.text + "\n# Title6"
        bodyTextView.selectedRange = NSMakeRange(bodyTextView.selectedRange.location - 6, 6)
    }
    

    func createBodyTextView() {
        let bodyTextStorage = HighlightTextStorage()
        let layoutManager = NSLayoutManager()
        let containerSize = CGSizeMake(view.frame.width, CGFloat.max)
        let container = NSTextContainer(size: containerSize)
        layoutManager.addTextContainer(container)
        bodyTextStorage.addLayoutManager(layoutManager)
        
        // Initialize UIView
        bodyTextView = UITextView(frame: CGRectMake(0, 0, 100, 100), textContainer: container)
        view.addSubview(bodyTextView)
        
        // Add constraints to TextView
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.topAnchor.constraintEqualToAnchor(titleTextField.bottomAnchor, constant: 8).active = true
        bodyTextView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -20).active = true
        bodyTextView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 20).active = true
        bodyTextView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -20).active = true
        bodyTextView.textContainer.size = bodyTextView.frame.size
        
    }
    
    func createKeyboardToolbar() {
        toolBar = KeyboardToolBar(frame: CGRectMake(0, 0, 0, 40))
        
        let normalImage = [
            UIImage.init(named: "bold_normal"),
            UIImage.init(named: "code_normal"),
            UIImage.init(named: "quote_normal"),
            UIImage.init(named: "disordered_normal"),
            UIImage.init(named: "ordered_normal"),
            UIImage.init(named: "link_normal"),
        ]
        
        var toolBarButtons = [UIButton]()
        for image in normalImage {
            let button = UIButton(type: .Custom)
            button.setImage(image, forState: .Normal)
            toolBarButtons.append(button)
        }
        toolBar.addButtons(toolBarButtons)
        
        toolBarButtons[0].addTarget(self, action: #selector(EditViewController.inputStrong), forControlEvents: .TouchUpInside)
        toolBarButtons[1].addTarget(self, action: #selector(EditViewController.inputCode), forControlEvents: .TouchUpInside)
        toolBarButtons[2].addTarget(self, action: #selector(EditViewController.inputQuotation), forControlEvents: .TouchUpInside)
        toolBarButtons[3].addTarget(self, action: #selector(EditViewController.inputDisorderList), forControlEvents: .TouchUpInside)
        toolBarButtons[4].addTarget(self, action: #selector(EditViewController.inputOrderList), forControlEvents: .TouchUpInside)
        toolBarButtons[5].addTarget(self, action: #selector(EditViewController.inputLink), forControlEvents: .TouchUpInside)
      
        bodyTextView.inputAccessoryView = toolBar
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        var originSize = UIScreen.mainScreen().bounds.size
        let keyboardSize = aNotification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        originSize.height -= keyboardSize.CGRectValue().height
        view.frame.size = originSize
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        view.frame.size = UIScreen.mainScreen().bounds.size
    }
}

