//
//  PreviewViewController.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 22/3/18.
//  Copyright © 2018 Isaiah Glick. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var isaiahRating: UISegmentedControl!
    var movie: Movie? ;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let m = movie {
            titleLabel.text = m.title;
            m.getPosterAsync(imageView: posterView);
            synopsisTextView.text = m.synopsis
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
//    @IBAction func cancellation(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil);
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
