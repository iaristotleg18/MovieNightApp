//
//  PreviewViewController.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 22/3/18.
//  Copyright © 2018 Isaiah Glick. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var movie: Movie? ;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let m = movie {
            print(m.title)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
