//
//  BookTableViewController.swift
//  PtNovel
//
//  Created by Andy on 2015/12/3.
//  Copyright © 2015年 Andy. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    @IBOutlet var bookTableView: UITableView!
    @IBOutlet weak var bookSearchBar: UISearchBar!
    @IBOutlet weak var prevBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!

    let cellIdentifier = "BookTableViewCell"
    
    var refreshHeight: CGFloat!
    var page = 1
    var maxPage = 1
    var searchPage = 1;
    var searchMaxPage = 1;
    var search: String = ""
    var books = [PtBook]()
    
    @IBAction func onNextPage(sender: UIBarButtonItem) {
        if (search == "") {
            if (page < maxPage) {
                page++
                loadBookList(nil)
            }
        } else {
            if (searchPage < searchMaxPage) {
                searchPage++
                searchBook()
            }
        }
        updateButtonState()
    }
    
    @IBAction func onPrevPage(sender: UIBarButtonItem) {
        if (search == "") {
            if (page > 1) {
                page--
                loadBookList(nil)
            }
        } else {
            if (searchPage > 1) {
                searchPage--
                searchBook()
            }
        }
        updateButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookSearchBar.delegate = self
        
        self.refreshControl?.addTarget(self, action: "loadBookList:", forControlEvents: UIControlEvents.ValueChanged)
        refreshHeight = -(self.refreshControl?.frame.size.height)!
        loadBookList(nil)
        updateButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bookIdx = indexPath.row
        let bookCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! BookTableViewCell
        let book = books[bookIdx]
        bookCell.updateBook(book)
        return bookCell
    }
    
    func updateButtonState() {
        let p = search == "" ? page : searchPage
        let mp = search == "" ? maxPage : searchMaxPage
        if (p <= 1) {
            prevBtn.enabled = false
        } else {
            prevBtn.enabled = true
        }
        if p >= mp {
            nextBtn.enabled = false
        } else {
            nextBtn.enabled = true
        }
        self.title = "Book List: \(p)"
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search = searchText
        if (search == "") {
            loadBookList(nil)
            searchPage = 1
            searchMaxPage = 1
        } else {
            searchBook()
        }
        
    }
    
    func searchBook() {
        let client = PtClient(params: "searchBook", search, String(searchPage))
        client.get { (result: NSData?) -> () in
            let books = PtBook.parseBooks(result)
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                if (books.count > 0) {
                    self?.updateSearchMaxPage()
                }
                self?.books = books
                self?.bookTableView.reloadData()
                self?.refreshControl?.endRefreshing()
                self?.updateButtonState()
            })
        }
    }
    
    func loadBookList(sender: AnyObject?) {
        searchPage = 1
        searchMaxPage = 1
        if sender == nil {
            self.refreshControl?.beginRefreshing()
            self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y + refreshHeight), animated: true)
        }
        let client = PtClient(params: "getBookList", String(page))
        client.get { (result: NSData?) -> () in
            let books = PtBook.parseBooks(result)
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                if (books.count > 0) {
                    self?.updateMaxPage()
                }
                self?.books = books
                self?.bookTableView.reloadData()
                self?.refreshControl?.endRefreshing()
                self?.updateButtonState()
            })
        }
    }
    
    func updateMaxPage() {
        maxPage = max(page + 1, 2)
    }
    
    func updateSearchMaxPage() {
        searchMaxPage = max(searchPage + 1, 2)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BookInfo" {
            let bookInfoVC = segue.destinationViewController as! BookInfoViewController
            if let selectedBookCell = sender as? BookTableViewCell {
                let bookIdx = tableView.indexPathForCell(selectedBookCell)
                bookInfoVC.book = books[bookIdx!.row]
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
