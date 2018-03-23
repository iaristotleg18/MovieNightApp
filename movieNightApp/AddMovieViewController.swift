//
//  AddMovieViewController.swift
//  movieNightApp
//
//  Created by Spencer Brown on 3/18/18.
//  Copyright © 2018 Isaiah Glick. All rights reserved.
//

import UIKit

class AddMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AutoCompleteResultsDelegate{
    
    // Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var autoCompleteTable: UITableView!
    
    // File Management
    let imageDirName:String = "images";
    var imageDirPath: URL?;
    var fm = FileManager.default;
    
    // Auto Complete Results
    var allMoviesResults: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.autoCompleteTable.reloadData();
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Table Functions */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMoviesResults.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteTableViewCell", for: indexPath) as? AutoCompleteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AutoCompleteTableViewCell.")
        }
        
        if (indexPath.row < allMoviesResults.count){
            let movie = allMoviesResults[indexPath.row]
            cell.titleLabel.text = movie.title;
            cell.yearLabel.text = "(" + movie.getYear() + ")";
            cell.delegate = self;
            cell.data = movie;
        }
        
        return cell
    }
    
    /*
    // MARK: - Navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Parent update
        super.prepare(for: segue, sender: sender)
        
        print(segue.identifier);
        
        switch(segue.identifier ?? "") {
            
        case "ShowMovieDetails":
            
            guard let previewViewController = segue.destination as? PreviewViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMovieCell = sender as? AutoCompleteTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = autoCompleteTable.indexPath(for: selectedMovieCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMovie = allMoviesResults[indexPath.row]
            previewViewController.movie = selectedMovie;
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func cancellation(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if (searchTextField.text == "") {
            self.clearAutocompleteResults()
        } else {
            self.getMovies();
        }
    }
    
    func selectedMovie(movie: Movie) {
        
    }
    
    func clearAutocompleteResults(){
        self.allMoviesResults.removeAll() //Clear our the old results
    }
    
    //Order the results by closeness to spelling
    func orderAutocompleteResults(query: String, unordered: [Movie]) -> [Movie] {
        let regex = "^" + query.lowercased();
        let topResults = unordered.filter { $0.title.lowercased().range(of: regex, options: .regularExpression) != nil}
        let restResults = unordered.filter { $0.title.lowercased().range(of: regex, options: .regularExpression) == nil}
        var results = topResults
        results += restResults
        return results;
    }
    
    func getMovies() {
        let endpoint = "https://api.themoviedb.org/3/search/movie";
        guard var url = URLComponents(string: endpoint) else {return}
        guard let query = searchTextField.text else {return}
        
        url.queryItems = [
            URLQueryItem(name: "api_key", value: "8fe986d35425fe4c2fc5e5b7656225b5"),
            URLQueryItem(name: "query", value: query)
        ];
        
        guard let myUrl = url.url else {return}
        
        self.clearAutocompleteResults();
        
        let session = URLSession.shared;
        session.dataTask(with: myUrl) { (data, res, error) in
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers);
                    guard let allData = json as? [String: Any] else {return};
                    guard let results = allData["results"] as? [Any] else {return}
                    
                    var autoCompleteResults = [Movie]()
                    for result in results{
                        var posterPath = "";
                        var date = "";
                        guard let values = result as? [String: Any] else {return}
                        guard let title = values["title"] as? String else {return}
                        guard let description = values["overview"] as? String else {return}
                        guard let id = values["id"] as? Int else {print("id is not an int"); return}
                        if let releaseDate = values["release_date"] as? String {
                            date = releaseDate;
                        }
                        if let poster = values["poster_path"] as? String {
                            posterPath = poster;
                        }
                        if let movie = Movie(title: title, movieDbId: id, synopsis: description) {
                            if (date != "") {
                                movie.setReleaseDate(dateString: date);
                            }
                            if (posterPath != ""){
                                movie.setPoster(path: posterPath);
                            }
                            autoCompleteResults.append(movie)
                        }
                    }
                    self.allMoviesResults = self.orderAutocompleteResults(query: query, unordered: autoCompleteResults);
                } catch {
                    print(error);
                }
            }
        }.resume();
    }
}
