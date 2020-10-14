//
//  ViewController.swift
//  Planit
//
//  Created by Pete Walker on 10/13/20.
//  Copyright © 2020 Pete Walker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // to identify the segue named "firstLink" (main - calendar) and follow that segue to open another view.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performSegue(withIdentifier: "firstLink", sender: self)
    }
}

