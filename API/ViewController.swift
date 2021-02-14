//
//  ViewController.swift
//  API
//
//  Created by MacBook on 25.12.2020.
//  Copyright © 2020 ZelimkhanEdilov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tabPhotoView: UITableView!
    
    var new = Networking()
    var availableNews: [Networking] = [] {
        didSet {
            tabPhotoView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
        tabPhotoView.delegate = self
        tabPhotoView.dataSource = self

    }
    
    
    func getPhotos() {
        let jsonUrl = "https://newsapi.org/v2/everything?q=bitcoin&from=2020-12-07&sortBy=publishedAt&apiKey=c01f88f2a4a1410a8a4b590737e13239"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {return}
            
            do {
                let mappedJson = try JSONDecoder().decode(Titless.self, from: data)
                DispatchQueue.main.async {
                    self?.availableNews = (mappedJson.articles ?? []).compactMap { $0 }
                }
            } catch let error {
                print(error)
            }
        }.resume()
  }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewNewsCell
        cell.labelNews.text = availableNews[indexPath.row].description
        cell.backgroundColor = .blue
        cell.labelNews.backgroundColor = .red
        cell.labelNews.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}

