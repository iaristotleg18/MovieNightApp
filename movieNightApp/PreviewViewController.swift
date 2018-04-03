//
//  PreviewViewController.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 22/3/18.
//  Copyright © 2018 Isaiah Glick. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    // Scroll Container
    @IBOutlet weak var scrollContainer: UIScrollView!

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSynopsis: UITextView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieIsaiahRating: UISegmentedControl!
    
    @IBOutlet weak var metaInput: UITextField!
    @IBOutlet weak var metaRatingSetButton: UIButton!
    @IBOutlet weak var metaNumber: UILabel!
    
    var toolbar:UIToolbar?;
    var movie: Movie? ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make sure the text view starts at the top && metaInput is formatted
        movieSynopsis.contentInset = UIEdgeInsetsMake(-4,-4,0,0);
        metaNumber.layer.masksToBounds = true
        metaNumber.layer.cornerRadius = 5
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        //Todo: #1 Display the properties of the movies
        if let selectedMovie = movie {
            selectedMovie.getPosterAsync(imageView: posterView)
            movieTitle.text = selectedMovie.title
            movieSynopsis.text = selectedMovie.synopsis
            movieYear.text = "(" + selectedMovie.getYear() + ")";
            movieIsaiahRating.selectedSegmentIndex = selectedMovie.isaiahRating;
            if selectedMovie.metaRating != "" {
                let label = selectedMovie.getMetacriticRating();
                metaNumber.text = label.text;
                metaNumber.backgroundColor = label.backgroundColor;
            }
        }
        
        if !FileManager.default.fileExists(atPath: Movie.ImageURL.path){
            print("images directory does not exist")
            do{
                try FileManager.default.createDirectory(atPath: Movie.ImageURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)");
            }
        }
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        customView.backgroundColor = UIColor.red
        metaInput.inputAccessoryView = customView
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
    
    // MARK: - Actions

    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        if (metaInput == sender){
            self.addToolBar(textField: sender)
            scrollContainer.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        }
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        if (metaInput == sender){
            scrollContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    @IBAction func metaInputUpdated(_ sender: UITextField) {
        if let text = sender.text {
            self.checkMetacriticValid(value: text);
        }
    }
    
    func addToolBar(textField: UITextField) {
        self.toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        self.toolbar?.setItems(self.getToolbarButtons(), animated: false);
        textField.inputAccessoryView = self.toolbar
    }
    
    func toolBarButtonTapped(button:UIBarButtonItem) -> Void {
        if button.title?.lowercased() == "set" {
            self.updateMetacriticRating();
        } else {
            metaInput.text = "";
            metaInput.resignFirstResponder();
        }
        // do you stuff here..
    }
    
    func checkMetacriticValid(value: String) {
        guard let myInt = Int(value) else {
            metaRatingSetButton.isEnabled = false;
            self.toolbar?.items?.last?.isEnabled = false;
            return;
        }
        
        if myInt <= 100 && myInt >= 0 {
            metaRatingSetButton.isEnabled = true;
            self.toolbar?.items?.last?.isEnabled = true;
        } else {
            metaRatingSetButton.isEnabled = false;
            self.toolbar?.items?.last?.isEnabled = false;
        }
    }
    
    func getToolbarButtons() -> [UIBarButtonItem] {
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(self.toolBarButtonTapped(button:)))
        doneButton.isEnabled = false;
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain  , target: self, action: #selector(self.toolBarButtonTapped(button:)))
        
        return [cancelButton, spaceButton, doneButton];
    }
    
    func updateMetacriticRating() {
        if let selectedMovie = movie, let text = metaInput.text {
            let newLabel = selectedMovie.setMetacriticRating(inputText: text)
            metaNumber.text = newLabel.text;
            metaNumber.backgroundColor = newLabel.backgroundColor;
            metaInput.text = "";
            metaInput.sendActions(for: .editingChanged);
            metaInput.resignFirstResponder();
        }
    }
    @IBAction func setMetaRating(_ sender: UIButton) {
        self.updateMetacriticRating();
    }
    
    @IBAction func isaiahRatingSet(_ sender: UISegmentedControl) {
        if let selectedMovie = movie {
            selectedMovie.setIsaiahRating(rating: sender.selectedSegmentIndex)
        }
    }
}
