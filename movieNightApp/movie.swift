//
//  movie.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 28/09/2017.
//  Copyright © 2017 Isaiah Glick. All rights reserved.
//

import UIKit

class Movie: NSObject, NSCoding {
    // MARK: Properties
    // The Movie DB
    var theMovieDbId: Int

    // Movie Specific
    var title: String
    var synopsis: String
    var releaseDate: Date?
    var posterEndpoint: String = "";
    var posterPath: URL?;
    var posterName:String = "";
    var cast: String = "";
    var crew: String = "";
    var metaRating: Int = 0;

    // User Specific
    var isaiahRating: Int = 0;
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    static let ImageURL = DocumentsDirectory.appendingPathComponent("images")
    
    struct MovieKeys {
        static var DbId = "DbId"
        static var title = "title"
        static var posterPath = "posterPath"
        static var synopsis = "synopsis"
        static var releaseDate = "releaseDate"
        static var cast = "cast"
        static var crew = "crew"
        static var metaRating = "metaRating"
        static var isaiahRating = "isaiahRating"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(theMovieDbId, forKey: MovieKeys.DbId)
        aCoder.encode(title, forKey: MovieKeys.title)
        aCoder.encode(posterPath, forKey: MovieKeys.posterPath)
        aCoder.encode(releaseDate, forKey: MovieKeys.releaseDate)
        aCoder.encode(synopsis, forKey: MovieKeys.synopsis)
        aCoder.encode(cast, forKey: MovieKeys.cast)
        aCoder.encode(crew, forKey: MovieKeys.crew)
        aCoder.encode(metaRating, forKey: MovieKeys.metaRating)
        aCoder.encode(isaiahRating, forKey: MovieKeys.isaiahRating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let savedTitle = aDecoder.decodeObject(forKey: MovieKeys.title) as? String else {
            return nil;
        }
        
        let savedDbId = aDecoder.decodeInteger(forKey: MovieKeys.DbId);
        let savedSynopsis = aDecoder.decodeObject(forKey: MovieKeys.synopsis) as? String ?? ""
        let savedDate = aDecoder.decodeObject(forKey: MovieKeys.releaseDate) as? Date
        let savedPosterPath = aDecoder.decodeObject(forKey: MovieKeys.posterPath) as? URL
        let savedCast = aDecoder.decodeObject(forKey: MovieKeys.cast) as? String ?? ""
        let savedCrew = aDecoder.decodeObject(forKey: MovieKeys.crew) as? String ?? ""
        let savedMeta = aDecoder.decodeInteger(forKey: MovieKeys.metaRating);
        let savedRating = aDecoder.decodeInteger(forKey: MovieKeys.isaiahRating);
        
        self.init(title:savedTitle, movieDbId: savedDbId, synopsis: savedSynopsis, releaseDate: savedDate, posterPath: savedPosterPath, cast: savedCast, crew: savedCrew, metaRating: savedMeta, isaiahRating: savedRating);
        
    }
    
    init?(title: String, movieDbId: Int, synopsis: String = "", releaseDate: Date? = nil, posterPath: URL? = nil, cast: String = "", crew: String = "", metaRating: Int = 0, isaiahRating: Int = 0) {
        guard !title.isEmpty else{
            return nil
        }
        
        self.title = title;
        self.theMovieDbId = movieDbId;
        self.synopsis = synopsis;
        self.releaseDate = releaseDate;
        self.posterPath = posterPath;
        self.cast = cast;
        self.crew = crew;
        self.metaRating = metaRating;
        self.isaiahRating = isaiahRating;
    }
    
    func getYear() -> String {
        let calendar = Calendar.current;
        if let date = self.releaseDate {
            return String(calendar.component(.year, from: date))
        } else {
            return "";
        }
    }
    
    func setReleaseDate(dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd";
        if let date = formatter.date(from: dateString) {
            self.releaseDate = date
        } else {
            self.releaseDate = nil
        }
    }
    
    func getPoster() -> UIImage? {
        if let path = self.posterPath {
            return self.getImageData(posterPath: path);
        } else if self.posterName != ""{
            if (UIImage(named: self.posterName) != nil) {
                return UIImage(named: self.posterName);
            }
        }
        return nil;
    }
    
    func getImageData(posterPath: URL) -> UIImage? {
        if FileManager.default.fileExists(atPath: posterPath.path) {
            return UIImage(contentsOfFile: posterPath.path);
        } else {
            return nil;
        }
    }
    
    func getImagePath(path: String) -> URL {
        return Movie.ImageURL.appendingPathComponent(path)
    }
    
    func setMetaCriticRating(rating: Int) {
        self.metaRating = rating;
    }
    
    func setIsiahRating(rating: Int) {
        self.isaiahRating = rating;
    }
    
    func setPosterName(name: String){
        self.posterName = name;
    }
    
    func setPoster(path: String) {
        self.posterEndpoint = path;
        let cleanPosterPath = path.replacingOccurrences(of: "/", with: "");
        self.posterPath = self.getImagePath(path: cleanPosterPath);
    }
    
    func downloadPoster() {
        guard let posterPath = self.posterPath else {return}
        // If file already exists, just set the poster path to the correct image path
        if FileManager.default.fileExists(atPath: posterPath.path) {
            print("file apparently found")
            return;
        }
        
        print(posterPath);
        
        // If not, download it
        if (self.posterEndpoint.isEmpty) { return }
        var endpoint = "https://image.tmdb.org/t/p/w500/";
        endpoint = endpoint + self.posterEndpoint;
        guard var url = URLComponents(string: endpoint) else {return}
        
        url.queryItems = [
            URLQueryItem(name: "api_key", value: "8fe986d35425fe4c2fc5e5b7656225b5")
        ];
        
        guard let myUrl = url.url else {return}
        let session = URLSession.shared;
        
        session.dataTask(with: myUrl) { (data, res, error) in
            
            //Make sure you connect to the end point
            guard let data = data, error == nil else {
                print("dataTask error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            //Make sure its a 200
            guard let httpResponse = res as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                print("Error; Text of response = \(String(data: data, encoding: .utf8) ?? "(Cannot display)")")
                return
            }
            
            do {
                try data.write(to: posterPath, options: .atomic)
                return;
            } catch let fileError {
                print(fileError)
            }
        }.resume();
    }
}




