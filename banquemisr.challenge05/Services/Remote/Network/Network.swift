//
//  Network.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import Foundation

class Network : networkProtocol {
    
    func fetch<T: Codable>(url: String, type: T.Type, completionHandler: @escaping (T?, Error?) -> Void){
        let url = URL(string:url)
        guard let newURL = url else {
            print("Invalid URL")
            return  }
        print("Fetching data from URL: \(newURL)")
        
        var components = URLComponents(url: newURL, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 2
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiODU0OGFkODE4ZDFlOTRiMjYxYjUzMzZjMjI2YmI4YyIsIm5iZiI6MTcyNzM2MjgwOC43MDcyNSwic3ViIjoiNjZmNTY5NzI1ZTM1NGM1MDEyNzQwMmFmIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.dSWX3HgnJePebISPwI5iaNR22lXuaGBoJ5VLmzUW8W8"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                
            if let error = error {
                print("error: \(error.localizedDescription)")
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data")
                completionHandler(nil, NSError(domain: "No Data", code: -1, userInfo: nil))
                return
            }
            
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(decodedData, nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()

        
    }
}
