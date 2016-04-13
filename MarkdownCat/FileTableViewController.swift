//
//  FileTableViewController.swift
//  MarkdownCat
//
//  Created by ShengJie on 16/2/18.
//  Copyright © 2016年 ShengJie. All rights reserved.
//

import UIKit

class FileTableViewController: UITableViewController {

    // MARK: Properties
    let sectionsInTableView = 1
    var articles: [Article] = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadArticles()
    }


    // MARK: - TableView data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sectionsInTableView
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath) as! ArticleTableViewCell

        let article = articles[indexPath.row]
        // Configure the cell...
        cell.fileName.text = article.title
        cell.fileDate.text = NSDateFormatter().stringFromDate(article.date)
        cell.fileDate.text = NSDateFormatter.localizedStringFromDate(article.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        cell.fileSize.text = "\(article.size) 个字"

        return cell
    }
    
    @IBAction func unwindToFileList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EditViewController, article = sourceViewController.article {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                articles[selectedIndexPath.row] = article
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Automatic)
            } else {
                let newIndexPath = NSIndexPath(forRow: articles.count, inSection: 0)
                articles.append(article)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveArticles()
        }
    }
    
    // MARK: NSCoding
    func saveArticles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(articles, toFile: Article.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save articles...")
        }
    }
    
    func loadArticles() {
        if let articles = NSKeyedUnarchiver.unarchiveObjectWithFile(Article.ArchiveURL.path!) as? [Article] {
            self.articles = articles
        }
    }
    
    func createHelpAriticle() -> Article {
        let helpContent = "# 欢迎使用MarkdownCat\n\n--------------\n**Markdown Cat**是`iOS`平台上一款轻量级的Markdown编辑器,通过键盘上方的语法提示(`Syntax Hint`)可以帮助你方便快速地编写Markdown文档并分享。\n\n# Markdown简介\n--------------\n> Markdown是一种轻量级标记语言，它允许人们使用易于读写的纯文本格式编写文档，然后转化成格式丰富的HTML页面。\n--[维基百科](https://zh.wikipedia.org/wiki/Markdown)\n\n\n## 列表\nMarkdown支持有序列表和无序列表。\n无序列表使用星号、加号或是减号作为列表标记：\n\n- Red\n- Green\n- Blue\n\n等同于：\n\n+ Red\n+ Green\n+ Blue\n\n也等同于：\n\n* Red\n* Green\n* Blue\n\n有序列表则使用数字接着一个英文句点：\n\n1. Bird\n2. McHale\n3. Parish\n\n更多语法说明请点击[Markdown语法说明](http://wowubuntu.com/markdown/)。"
        return Article(title: "欢迎使用MarkdownCat", content: helpContent, date: NSDate())
    }
    
    func createFileDirectory() {
        let fileManager = NSFileManager()
        let url = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("Articles")
        if let _ = try? fileManager.createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil) {
            print("Succeeded in creating directory!")
        } else {
            print("Failed to create directory!")
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            articles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveArticles()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let editViewController = segue.destinationViewController as! EditViewController
            let selectedArticleCell = sender as! ArticleTableViewCell
            let indexPath = self.tableView.indexPathForCell(selectedArticleCell)!
            let selectedArticle = articles[indexPath.row]
            editViewController.article = selectedArticle
        }
    }


}
