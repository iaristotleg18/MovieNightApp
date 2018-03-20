//
//  MovieElNavTableViewController.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 05/10/2017.
//  Copyright © 2017 Isaiah Glick. All rights reserved.
//

import UIKit

import os.log

class MovieNavTableViewController: UITableViewController {
    
    var movies: [Movie] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        //change the color of this leftBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white

        if let savedMovies = loadMovies(){
            movies += savedMovies
        } else {
            loadSampleMovies()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        
        //gradient.frame = defaultNavBarFrame
        //gradient.colors = [dark.cgColor, UIColor.black.cgColor]
       
        //self.navigationController?.navigationBar.layer.addSublayer(gradient)
        
    }
    
    func saveMovies(){
        var saveSuccess = NSKeyedArchiver.archiveRootObject(movies, toFile: Movie.ArchiveURL.path)
    }
    
    func loadMovies()->[Movie]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Movie.ArchiveURL.path) as? [Movie]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MovieTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell else{
            fatalError("POPCORN BURNING. YOU ARE KICKED OUT. IT IS THE ORDER OF THE AGENTS")
        }
        
        
        let movie = movies[indexPath.row]
        cell.movieName.text = movie.title
        cell.moviePoster.image = movie.getPoster()
        return cell
    }

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            movies.remove(at: indexPath.row)
            saveMovies();
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Parent update
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            
            os_log("Adding a new film.", log: OSLog.default, type: .debug)
        
        case "ShowDetail":
            
            guard let movieViewController = segue.destination as? MovieViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMovieCell = sender as? MovieTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMovieCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMovie = movies[indexPath.row]
            movieViewController.movie = selectedMovie
        
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    func loadSampleMovies()  {
        
        // Force Awakens
        let forceMovie: Movie = Movie(title: "The Force Awakens", movieDbId: 0, cast: "Daisy Ridley, John Boyega, Adam Driver, JJ Abrams", metaRating: 81, isaiahRating: 2)!
        forceMovie.setPosterName(name: "TheForceAwakensPoster")
        
        let tapMovie: Movie = Movie(title: "Spinal Tap", movieDbId: 0, cast: "Christopher Guest, Rob Reiner, Michael McKean, Harry Shearer", metaRating: 85, isaiahRating: 2)!
        tapMovie.setPosterName(name: "TheSpinalTapPoster");
        
        let rogueMovie: Movie = Movie(title: "Rogue One: A Star Wars Story", movieDbId: 0, cast: "Felicity Jones, Diego Luna, Ben Mendelsohn, Gareth Edwards", metaRating: 65, isaiahRating: 2)!
        rogueMovie.setPosterName(name: "TheRogueOnePoster");
    
        movies.append(forceMovie)
        movies.append(tapMovie)
        movies.append(rogueMovie)
    }
    
    //Movie Table View
    @IBAction func unwindToMovieList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MovieViewController, let movie = sourceViewController.movie {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                movies[selectedIndexPath.row] = movie
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new movie
                let newIndexPath = IndexPath(row: movies.count, section: 0)
                movies.append(movie)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMovies()
        }
    }
}
