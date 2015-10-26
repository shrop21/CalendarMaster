//
//  DetailViewController.swift
//  CalMaster
//
//  Created by Jake Shropshire on 10/11/15.
//  Copyright (c) 2015 Jake Shropshire. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var detailsTextBox: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var eventIndex : Int?
    var currentEvent : EventObject?

    var eventDetail: EventObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: EventObject = self.eventDetail {
            if let label = self.titleLabel {
                label.text = detail.Title
            }
            if let box = self.detailsTextBox {
                box.text = detail.Details
            }
            if let picker = self.datePicker {
                picker.date = detail.Time
            }
        }
    }
    
    @IBAction func clickSave(sender: AnyObject) {
        if let detail: EventObject = self.eventDetail {
            detail.setValues(datePicker.date, title: titleLabel.text!, details: detailsTextBox.text)
            //if let label = self.titleLabel {
            //    detail.Title = label.text!
            //}
            //if let box = self.detailsTextBox {
            //    detail.Details = box.text
            //}
            objects[self.eventIndex!] = detail
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If touched outside of keyboard
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

