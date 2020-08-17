//
//  Album.swift
//  Apple_RSS
//
//  Created by Vamsi Kallepalli on 8/10/20.
//  Copyright © 2020 Vamsi Kallepalli. All rights reserved.
//

/*
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Album {
    init(json: [String: Any]) throws {
        // Extract name
        guard let name = json["artistName"] as? String else {
            throw SerializationError.missing("artistName")
        }
        
        // Extract and validate coordinates
        guard let coordinatesJSON = json["coordinates"] as? [String: Double],
            let latitude = coordinatesJSON["lat"],
            let longitude = coordinatesJSON["lng"]
            else {
                throw SerializationError.missing("coordinates")
        }
        
        let coordinates = (latitude, longitude)
        guard case (-90...90, -180...180) = coordinates else {
            throw SerializationError.invalid("coordinates", coordinates)
        }
        
        // Extract and validate meals
        guard let mealsJSON = json["meals"] as? [String] else {
            throw SerializationError.missing("meals")
        }
        
        var meals: Set<Meal> = []
        for string in mealsJSON {
            guard let meal = Meal(rawValue: string) else {
                throw SerializationError.invalid("meals", string)
            }
            
            meals.insert(meal)
        }
        
        // Initialize properties
        self.name = name
        self.coordinates = coordinates
        self.meals = meals
    }
}
 */

struct Album: Codable {
    let artistName : String?
    let id : String?
    let releaseDate : String?
    let name : String?
    let kind : String?
    let copyright : String?
    let artistId : String?
    let contentAdvisoryRating : String?
    let artistUrl : String?
    let artworkUrl100 : String?
    let genres : [Genre]?
    let url : String?
}

struct Genre: Codable {
    let genreId : String?
    let name : String?
    let url : String?
}


