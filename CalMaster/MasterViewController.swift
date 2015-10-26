//
//  MasterViewController.swift
//  CalMaster
//
//  Created by Jake Shropshire on 10/11/15.
//  Copyright (c) 2015 Jake Shropshire. All rights reserved.
//

import UIKit

var objects : [EventObject] = []


class MasterViewController: UITableViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(animated: Bool) {
        objects.sort({ $0.Time.compare($1.Time) == NSComparisonResult.OrderedAscending})
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        var event = EventObject()
        objects.insert(event, atIndex: 0)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as EventObject
                var pass = segue.destinationViewController as! DetailViewController
                
                pass.eventDetail = object
                pass.eventIndex = indexPath.row
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = objects[indexPath.row] as EventObject
        cell.detailTextLabel?.text = self.formatDate(object.Time)     //object.dayToString(object.DayOfWeek)
        cell.textLabel!.text = object.Title
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    /////// fix the removal ///////
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func formatDate(date: NSDate) -> String {
        var formatter = NSDateFormatter()
        //formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "EEE MMM d"
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
}

// Object that hold the event info
class EventObject {
    
    var Title: String
    var Time: NSDate
    var Details: String
    var DayOfWeek: Int!
    
    init(){
        self.Title = "Event Title"
        self.Details = "Details go here"
        self.Time = NSDate()
        self.DayOfWeek = getDay(Time)
        
    }
    
    func setValues(date: NSDate, title: String, details: String) {
        self.Time = date
        self.Title = title
        self.Details = details
        self.DayOfWeek = getDay(date)
        
    }
    
    func dayToString(day: Int) -> String {
        if day == 0 {
            return "Monday"
        } else if day == 1 {
            return "Tuesday"
        } else if day == 2 {
            return "Wednesday"
        } else if day == 3 {
            return "Thursday"
        } else if day == 4 {
            return "Friday"
        } else if day == 5 {
            return "Saturday"
        } else if day == 6 {
            return "Sunday"
        }
        return "Error"
    }
    
    func getDay(date: NSDate) -> Int {
        var cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var comp = cal.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date)
        
        if comp.weekday == 1 {
            return 6
        } else {
            return comp.weekday - 2
        }
    }
}
