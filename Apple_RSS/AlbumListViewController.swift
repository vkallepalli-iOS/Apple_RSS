//
//  AlbumListViewController.swift
//  Apple_RSS
//
//  Created by Vamsi Kallepalli on 8/16/20.
//  Copyright © 2020 Vamsi Kallepalli. All rights reserved.
//

import UIKit


class AlbumListViewController: UITableViewController {

    var navBarDefaultImage: UIImage?
    var albums = [Album]()
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: "albumCell")
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        self.tableView.separatorStyle = .none
        setLoadingScreen()
        setUpNavigation()
        getAlbums()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomNavigationBarSettings()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        cell.album = albums[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let row = indexPath.row
        let albumDetailVC = AlbumDetailViewController()
        albumDetailVC.albumDetails = albums[row]
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }

    func setUpNavigation() {
        navigationItem.title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
    }
    
    // MARK: - API CALL
    
    func getAlbums() {
        
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let feed = json["feed"] as? [String: Any] {
                        if let results = feed["results"] as? [[String : Any]] {
                            do {
                                let jsonResults = try JSONSerialization.data(withJSONObject: results)
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                self.albums = try decoder.decode([Album].self, from: jsonResults)
                                DispatchQueue.main.async {
                                    self.tableView.separatorStyle = .singleLine
                                    self.tableView.reloadData()
                                    self.removeLoadingScreen()
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setCustomNavigationBarSettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .compact)
        self.navigationController!.navigationBar.barTintColor = nil
        self.navigationController!.toolbar.barTintColor = nil
        self.navigationController!.toolbar.isTranslucent = true
        applyTransparentBackgroundToTheNavigationBar(0.97)
    }
    
    func applyTransparentBackgroundToTheNavigationBar(_ opacity: CGFloat) {
        var transparentBackground: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1),
                                               false,
                                               navigationController!.navigationBar.layer.contentsScale)
        let context = UIGraphicsGetCurrentContext()!
        //context.setFillColor(red: 1, green: 1, blue: 1, alpha: opacity)
        context.setFillColor(UIColor.systemBackground.withAlphaComponent(opacity).cgColor)
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        transparentBackground = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
       
        let navigationBarAppearance = self.navigationController!.navigationBar
        navigationBarAppearance.setBackgroundImage(transparentBackground, for: .default)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if (UIApplication.shared.applicationState == .inactive && self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                applyTransparentBackgroundToTheNavigationBar(0.97)
            }
        }
    }
    
    func traitCollectionDidChangeCustom(_ previousTraitCollection: UITraitCollection?) {
        self.traitCollectionDidChange(previousTraitCollection)
    }
    
    func setLoadingScreen() {

        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.view.frame.width / 2) - (width / 2)
        let y = (self.view.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading"
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        tableView.addSubview(loadingView)
    }

    func removeLoadingScreen() {

        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true

    }
}

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

