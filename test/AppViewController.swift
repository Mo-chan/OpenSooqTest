//
//  AppViewController.swift
//  test
//
//  Created by Mohammad Awwad on 10/16/15.
//  Copyright © 2015 Awwadeto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AppViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabe: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    var app : Apps!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabe.text = app.title
        nameLabel.text = app.name
        priceLabel.text = app.price
        artistLabel.text = app.artist
        releaseLabel.text = app.releaseDate
        imageView.image = app.appImage
    }

    @IBAction func backAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}