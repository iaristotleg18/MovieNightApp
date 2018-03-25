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
    //Add outlets here
    var movie: Movie? ;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Todo: #1 Display the properties of the movies
        if let selectedMovie = movie {
            selectedMovie.getPosterAsync(imageView: posterView);
            //display the title
            //display the synopsis
            
        }
        
        if !FileManager.default.fileExists(atPath: Movie.ImageURL.path){
            print("images directory does not exist")
            do{
                try FileManager.default.createDirectory(atPath: Movie.ImageURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)");
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedMovie = movie {
            selectedMovie.savePoster();
        }
    }
    
    //Todo: #2 Update Isaiah Rating
}
