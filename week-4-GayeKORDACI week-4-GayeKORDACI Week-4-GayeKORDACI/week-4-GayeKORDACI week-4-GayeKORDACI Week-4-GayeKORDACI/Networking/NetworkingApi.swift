//
//  NetworkingApi.swift
//  week-4-GayeKORDACI week-4-GayeKORDACI Week-4-GayeKORDACI
//
//  Created by Gaye Kordacı Deprem on 13.06.2022.
//

import Foundation


protocol NetworkingService {
    @discardableResult func fetchCoins(completion: @escaping ([CryptoCurrency]) -> ()) -> URLSessionDataTask
    
}

final class NetworkingApi: NetworkingService {
    private let session = URLSession.shared
    
    @discardableResult //Result'ın kullanılmayacağını belirtir
    func fetchCoins( completion: @escaping ([CryptoCurrency]) -> ()) -> URLSessionDataTask {
        let request = URLRequest(url: URL(string: "https://api.coincap.io/v2/assets")!)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                    let response = try? JSONDecoder().decode(CoinsResponse.self, from: data) else {
                        completion([])
                        return
                }
                completion(response.data)
            }
        }
        task.resume()
        return task
    }

}

fileprivate struct CoinsResponse: Codable {
    let data: [CryptoCurrency]
}
