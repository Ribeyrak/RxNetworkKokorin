//
//  APIManager.swift
//  RxNetworkKokorin
//
//  Created by Yevhen Lukhtan on 20.12.2023.
//

import Foundation
import RxSwift

class APIManager {
    
    func getRepositories(_ gitHubID: String) -> Observable<[Repos]> {
        guard !gitHubID.isEmpty,
                let url = URL(string: "https://api.github.com/users/\(gitHubID)/repos")
        else {
            return Observable.just([])
        }
        
        return URLSession.shared
            .rx.json(request: URLRequest(url: url))
            .retry(3)
            .map {
                var repositories = [Repos]()
                
                if let item = $0 as? [[String: AnyObject]] {
                    item.forEach {
                        guard let name = $0["name"] as? String,
                              let url = $0["html_url"] as? String
                        else { return }
                        repositories.append(Repos(name: name, url: url))
                    }
                }
                
                return repositories
            }
            
    }
}
