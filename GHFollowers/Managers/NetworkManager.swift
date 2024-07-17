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
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username created an invalid request. Please try again.")
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
                    completed(nil, "Unable to complete your request. Please check your internet connection.")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(nil, "Invalid response from the server. Please try again.")
                    return
                }
                
                guard let data = data else {
                    completed(nil, "The data received from the server was invalid. Please try again.")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let followers = try decoder.decode([Follower].self, from: data)
                    completed(followers, nil)
                } catch {
                    completed(nil, "The data received from the server was invalid. Please try again.")
                }
            }
            
            task.resume()
        } catch {
            completed(nil, "Authentication error \(error.localizedDescription)")
        }
    }
}
