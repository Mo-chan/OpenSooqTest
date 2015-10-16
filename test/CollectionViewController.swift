//
//  CollectionViewController.swift
//  test
//
//  Created by Mohammad Awwad on 10/16/15.
//  Copyright © 2015 Awwadeto. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        } catch { }
        fetchedResultsController.delegate = self
        
        if fetchedResultsController.sections![0].numberOfObjects == 0 {
            iTunes.sharedInstance().taskForGet() { (data , error) in
                
                    if let appsData = data {
                        for app in appsData {
                            let dictionary: [String : AnyObject] = [
                                Apps.Keys.Path : app["im:image"]!.valueForKey("label")!.lastObject!!,
                                Apps.Keys.Category : app["category"]!.valueForKey("attributes")!.valueForKey("label")!,
                                Apps.Keys.Name : app["im:name"]!.valueForKey("label")!,
                                Apps.Keys.Price : app["im:price"]!.valueForKey("label")!,
                                Apps.Keys.Title : app["title"]!.valueForKey("label")!,
                                Apps.Keys.Artist : app["im:artist"]!.valueForKey("label")!,
                                Apps.Keys.Release : app["im:releaseDate"]!.valueForKey("attributes")!.valueForKey("label")!,
                            ]
                            self.sharedContext.performBlockAndWait({
                                _ = Apps(dictionary: dictionary, context: self.sharedContext)
                                CoreDataStackManager.sharedInstance().saveContext()
                            })
                        }
                }
            }
        }
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Apps")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! imageViewCell
        let app = fetchedResultsController.objectAtIndexPath(indexPath) as! Apps
        cell.imageLabel.text = app.name
        configureCell(cell, app: app)
        
        return cell
    }
override     
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DetailView") as! AppViewController
        controller.app = fetchedResultsController.objectAtIndexPath(indexPath) as! Apps
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func configureCell(cell: imageViewCell , app: Apps){
        
        self.sharedContext.performBlockAndWait({
            if let image = NSKeyedUnarchiver.unarchiveObjectWithFile(iTunes.Caches.imagecache.pathForIdentifier(app.path)) as? UIImage {
                cell.imageView!.image = image
            } else {

                _ = iTunes.sharedInstance().taskForImage(app.path){ data, error in
                    if let error = error {
                        print("Photo download error: \(error)")
                    }
                    if let data = data {
                        let image = UIImage(data: data)
                        app.appImage = image
                        self.sharedContext.performBlockAndWait({
                            NSKeyedArchiver.archiveRootObject(image!,toFile: iTunes.Caches.imagecache.pathForIdentifier(app.path))
                        })
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.imageView!.image = image
                        }
                    }
                }
            }
        })
        
    }
}

