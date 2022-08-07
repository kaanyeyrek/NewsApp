//
//  APICaller.swift
//  MyNewsApp
//
//  Created by Kaan Yeyrek on 8/5/22.
//

import Foundation


//MARK: - Request for API

final class APICaller {
    
    static let shared = APICaller()
    
    
    struct Constants {
        
        static let topHeadLinesURL = URL(string:
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=73a9e56fbc224f389025bb23a0ff8305")
        
        static let searchURLString =
        "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=73a9e56fbc224f389025bb23a0ff8305&q="
        
    }
    
        
    private init() {}
    
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
        }
        
    }
        task.resume()
    
    
}
    
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
         
        let urlString = Constants.searchURLString + query
        guard let url = URL(string: urlString) else { return }
       
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
        }
        
    }
        task.resume()
    
    
}

    


}

//MARK: - API Models


struct APIResponse: Codable {
    let articles: [Article]
    
}

struct Article: Codable {
    let source: Source
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    
}

struct Source: Codable {
    let name: String
    
}

