//
//  ViewController.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 7/20/17.
//  Copyright © 2017 Isaiah Glick. All rights reserved.
//

import UIKit
import os.log

class MovieViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //label
    @IBOutlet weak var makeChanges: UILabel!
    //image
    @IBOutlet weak var makeAnew: UIImageView!
    //text field
    @IBOutlet weak var makeAnother: UITextField!
    //image view
    
    //ui label: meta
    @IBOutlet weak var metaNum: UILabel!
    //text field: meta
    @IBOutlet weak var metaInput: UITextField!
    //button:meta
    @IBOutlet weak var metaClick: UIButton!
    //text field: title
    @IBOutlet weak var MakeTitle: UITextField!
    //button: title
    @IBOutlet weak var makeTitleActivate: UIButton!
    //buttonact: title
    @IBOutlet weak var metaSlider: UISlider!
    //slider:meta
    
    
    //scroll view
    @IBOutlet weak var scrollContainer: UIScrollView!
    
    @IBOutlet weak var isaiahRating: UISegmentedControl!
    
    @IBOutlet weak var navSave: UIBarButtonItem!
    var movie:Movie?
    
    
    @IBAction func cancelation(_ sender: UIBarButtonItem) {
        
        var isAddingMovie = presentingViewController is UINavigationController;
        
        if isAddingMovie{
            dismiss(animated: true, completion: nil)
        } else if let owningController = navigationController{
            owningController.popViewController(animated: true)
        }
        
    }
    
    @IBAction func MakeTitleAct(_ sender: UIButton) {
        
        makeChanges.text = MakeTitle.text
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let movie = movie{
                        
            makeChanges.text = movie.title
            makeAnew.image = movie.poster
            MakeTitle.text = movie.title
            makeAnother.text = movie.castCrew
            metaNum.text = String(movie.metaMovie)
            metaInput.text = String(movie.metaMovie)
            isaiahRating.selectedSegmentIndex = movie.rate
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enterMeta(_ sender: UIButton) {
        metaInput.resignFirstResponder();
        updateRating()
    }
    //Declares updateRating
    func updateRating() {
        //it lets there be Ints and text
        if let value = Int(metaInput.text!){
            
        // the past function
            if value >= 0 && value < 25{
                metaNum.backgroundColor = .red
                metaNum.text = metaInput.text
                
            } else if value >= 25 && value < 50{
                metaNum.backgroundColor = .orange
                metaNum.text = metaInput.text
            }else if value >= 50 && value < 75{
                metaNum.backgroundColor = .yellow
                metaNum.text = metaInput.text
            }else if value >= 0 && value <= 100{
                metaNum.backgroundColor = .green
                metaNum.text = metaInput.text
            }else{
                print("You disobeyed our ancient Law of the Forsaken. Your number was too big or too small")
            
            }
            // prints the value
            print(value)
            //meta num text is meta input text
            
            }else{
            //print nil land
                print("Welcome to NIL-LAND")
            
            }
        }
    
    @IBAction func getPic(_ sender: UITapGestureRecognizer) {
    
            print("tap")
        
            let pictureRemote = UIImagePickerController()
            
            MakeTitle.resignFirstResponder()
            metaNum.resignFirstResponder()
            makeAnother.resignFirstResponder()
            
            pictureRemote.sourceType = .photoLibrary
            pictureRemote.delegate = self
            present(pictureRemote, animated: true, completion: nil)
    }

    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected an image, received: \(info) ")
        }
        
       makeAnew.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }

    
    //Movie controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === navSave else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //Create new movie -- whats the code for this?
        
        var myTitle = MakeTitle.text!;
        var poster = makeAnew.image!;
        var castCrew = makeAnother.text!;
        var metaMovie = Int(metaInput.text!)!;
        var rate = isaiahRating.selectedSegmentIndex
        movie = Movie(title: myTitle,poster: poster,castCrew: castCrew,metaMovie: metaMovie, rate: rate)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (metaInput == textField){
            scrollContainer.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        }
        self.makeAnew.isUserInteractionEnabled = false;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if (metaInput == textField){
            scrollContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        self.makeAnew.isUserInteractionEnabled = true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    

}




