//
//  ViewController.swift
//  hw4_MVC
//
//  Created by Kaan Alkan on 15.06.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        callAPI()
    }
    

    
    var responseArray: [CoinModel] = []
    
    func callAPI() {
        AF.request(URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc")!,
                          method: .get,
                          parameters: nil,
                          headers: nil)
            .responseJSON { response in
                if let responseData = response.data {
                    print(responseData)
                    do {
                        let decodeJson = JSONDecoder()
                        self.responseArray =  try decodeJson.decode([CoinModel].self, from: responseData)
                        self.tableView.reloadData()
                    } catch {
                        print(String(describing: error))
                    }
                }
            }
                   }
}
    

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        }
        let coin = responseArray[indexPath.row]
        cell!.textLabel?.text = "\(coin.id ?? "no data")"
        cell!.detailTextLabel?.text =  "Current Price: \(coin.currentPrice ?? 00), 24H Lowest: \(coin.low24H ?? 0), Highest: \(coin.high24H ?? 0)"
        return cell!
    }
}
	
//String(responseArray[indexPath.row].current_price ?? 2.00005)
