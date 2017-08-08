//
//  BaseViewController.swift
//  MyContacts
//
//  Created by Courtney Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    var NavigationController : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarStyle()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavbarStyle(){
        NavigationController = self.navigationController!
        NavigationController?.navigationBar.tintColor = Theme.navbarTitleColor
        NavigationController?.navigationBar.barTintColor = Theme.navbarBackgroundColor
        NavigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : Theme.navbarTitleColor
        ]
    }
    
    func popToPreviousViewController(){
        NavigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
