//
//  ViewController.swift
//  MyContacts
//
//  Created by Courtney Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import UIKit

protocol ContactDelegate: class {
    func pushToContact()
}

class ViewController: BaseViewController, ContactDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we have to do this so that when we click done no matter what we reveal the contacts view
        if segue.identifier == "creatorSegue" {
            print("segue.destination \(segue.destination)")
            if let nc = segue.destination as? UINavigationController {
                if let vc = nc.viewControllers[0] as? CreateViewController{
                    vc.delegate = self
                }
            }
        }
    }
    
    func pushToContact(){
        performSegue(withIdentifier: "contactSegue", sender: nil)
    }

}


