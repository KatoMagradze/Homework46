//
//  APIServices.swift
//  Lecture46
//
//  Created by Kato on 6/23/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

class APIServices {
    
    typealias completion = (TopArtists) -> ()
    
    func fetchArtists(completion: @escaping (TopArtists) -> ()) {
        
        guard let url = URL(string: "https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=8bebe116c2700b9e469cca041a8d2890&format=json") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let artists = try decoder.decode(TopArtists.self, from: data)

                
                completion(artists)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
}
