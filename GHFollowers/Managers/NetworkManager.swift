//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by MasterBi on 17/7/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidUsername)
            return
        }
        
        do {
            let token: String = try Configuration.value(for: "GithubToken")
            
            var request = URLRequest(url: url)
                request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completed(nil, .unableToComplete)
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(nil, .invalidResponse)
                    return
                }
                
                guard let data = data else {
                    completed(nil, .invalidData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let followers = try decoder.decode([Follower].self, from: data)
                    completed(followers, nil)
                } catch {
                    completed(nil, .invalidData)
                }
            }
            
            task.resume()
        } catch {
            completed(nil, .authenticationError)
        }
    }
}
