//
//  ViewController.swift
//  JsonAPI
//
//  Created by Kuliza-336 on 17/02/17.
//  Copyright © 2017 Kuliza-336. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let urlString = "http://www.omdbapi.com/?t=Game%20of%20Thrones&Season=1"
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var episode = [String]()
    var rel = [String]()
    var til = [String]()
    var imdb = [String]()
    var imdbrat = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
       
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        
       // downloadJsonWithURL()
        self.downloadJsonWithURL()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func downloadJsonWithURL() {
        
        let url = URL(string: urlString)
        
        var dowmloadTask = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        dowmloadTask.httpMethod = "GET"
       // DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error)  in
                if let myjson = try?JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    print(myjson?.value(forKey: "Episodes") ?? "No value fetched")
                    
                    if let episodeArry = myjson?.value(forKey: "Episodes") as? Array<Any> {
                        for eps in episodeArry {
                            if let epsdist = eps as? NSDictionary
                            {
                                if let name = epsdist.value(forKey: "Episode"){
                                self.episode.append(name as! String)
                                    print(self.episode)
                                }
                                if let name = epsdist.value(forKey: "Released"){
                                    self.rel.append(name as! String)
                                }
                                if let name = epsdist.value(forKey: "Title"){
                                    self.til.append(name as! String)
                                }
                                if let name = epsdist.value(forKey: "imdbID"){
                                    self.imdb.append(name as! String)
                                }
                                if let name = epsdist.value(forKey: "imdbRating"){
                                    self.imdbrat.append(name as! String)
                                }
                                
                               OperationQueue.main.addOperation(
                                    {
                                   self.tableView.reloadData()
                                })
                            }
                        }
                    }
                }
            }).resume()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.backgroundColor = UIColor.cyan
        cell.episode.text = episode[indexPath.row]
        cell.releaselab.text = rel[indexPath.row]
        cell.title.text = til[indexPath.row]
        cell.imdb.text = imdb[indexPath.row]
        cell.imdbrat.text = imdbrat[indexPath.row]
        
        return cell
    }
    
}
