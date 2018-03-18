//
//  movie.swift
//  movieNightApp
//
//  Created by Isaiah Glick on 28/09/2017.
//  Copyright © 2017 Isaiah Glick. All rights reserved.
//

import UIKit

class Movie: NSObject, NSCoding {
    
    var title: String
    var poster: UIImage?
    var castCrew: String
    var metaMovie: Int
    var rate: Int
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")

    
    struct MovieKeys {
        static var movieTitle = "title"
        static var moviePoster = "image"
        static var movieCastCrew = "castCrew"
        static var movieMeta = "meta"
        static var movieIsaiahRating = "isaiahRating"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: MovieKeys.movieTitle)
        aCoder.encode(poster, forKey: MovieKeys.moviePoster)
        aCoder.encode(castCrew, forKey: MovieKeys.movieCastCrew)
        aCoder.encode(metaMovie, forKey: MovieKeys.movieMeta)
        aCoder.encode(rate, forKey: MovieKeys.movieIsaiahRating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let savedTitle = aDecoder.decodeObject(forKey: MovieKeys.movieTitle) as? String else {
            return nil;
        }
        
        let savedPoster = aDecoder.decodeObject(forKey: MovieKeys.moviePoster) as? UIImage
        let savedCastCrew = aDecoder.decodeObject(forKey: MovieKeys.movieCastCrew) as? String
        let savedMeta = aDecoder.decodeInteger(forKey: MovieKeys.movieMeta) as? Int
        let savedRating = aDecoder.decodeInteger(forKey: MovieKeys.movieIsaiahRating) as? Int
        
        self.init(title:savedTitle, poster:savedPoster, castCrew:savedCastCrew!, metaMovie: savedMeta!, rate: savedRating!);
        
    }
    
    init?(title: String,poster: UIImage?,castCrew: String,metaMovie: Int,rate: Int) {
        guard !title.isEmpty else{
        
            return nil
        
        }
        
        if metaMovie > 100{
            return nil
        }
        
        if metaMovie < 0{
            return nil
        }

    
        self.title = title
        self.poster = poster
        self.castCrew = castCrew
        self.metaMovie = metaMovie
        self.rate = rate
        
        
    }
    
}




