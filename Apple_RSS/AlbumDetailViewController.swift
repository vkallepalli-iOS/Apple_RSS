//
//  AlbumDetailViewController.swift
//  Apple_RSS
//
//  Created by Vamsi Kallepalli on 8/16/20.
//  Copyright © 2020 Vamsi Kallepalli. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    var albumDetails: Album? {
        didSet {
            guard let albumItem = albumDetails else {return}
            if let name = albumItem.name {
                albumNameLabel.text = name
            }
            if let albumUrl = albumItem.artworkUrl100 {
                let url :URL = NSURL(string: albumUrl)! as URL
                //albumImageView.load(url:url)
                ImageService.getImage(withURL: url, completion: {image in
                    self.albumImageView.image = image
                })
            }
            if let artistName = albumItem.artistName {
                artistNameLabel.text = "\(artistName) "
            }
            
            if let genres : [Genre] = albumItem.genres {
                var genreList : [String] = []
                for genre in genres {
                    genreList.append(genre.name!)
                }
                var genresPlusReleaseDate = (genreList.map{String($0)}).joined(separator: "/")
                
                if let releaseDate = albumItem.releaseDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: releaseDate){
                        dateFormatter.dateFormat = "MMM dd, yyyy"
                        genresPlusReleaseDate.append(" - \(dateFormatter.string(from: date))")
                    }
                }
                    genreNameLabel.text = genresPlusReleaseDate
            }
            if let copyright = albumItem.copyright {
                copyrightLabel.text = copyright
            }
        }
    }
    
    let albumImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    let albumNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = UIColor.init(named: "ThemeColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor =  .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let copyrightLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.textColor =  .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goToStoreButton:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("See on iTunes Store", for: .normal)
        button.setTitleColor(UIColor.init(named: "ThemeColor"), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.init(named: "ButtonColor")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomNavigationBarSettings()
        
        goToStoreButton.addTarget(self, action: #selector(navigateTo(sender:)), for: .touchUpInside)
        
        setUpLayouts()
    }
    
    @objc func navigateTo(sender: UIButton) {
        if let albumUrl = albumDetails?.url {
            let url :URL = NSURL(string: albumUrl)! as URL
            UIApplication.shared.open(url)
        }
    }
    
    func setUpLayouts() {
        
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(albumImageView)
        
        albumImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.size.width))
        
        view.addSubview(albumNameLabel)
        albumNameLabel.anchor(top: albumImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 10, right: 20), size: .init(width: 0, height: 0))
        
        view.addSubview(artistNameLabel)
        artistNameLabel.anchor(top: albumNameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 5, right: 20), size: .init(width: 0, height: 0))
        
        view.addSubview(genreNameLabel)
        genreNameLabel.anchor(top: artistNameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 5, right: 20), size: .init(width: 0, height: 0))
        
        view.addSubview(copyrightLabel)
        copyrightLabel.anchor(top: genreNameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 5, right: 20), size: .init(width: 0, height: 0))
        
        view.addSubview(goToStoreButton)
        goToStoreButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 50))

    }
    
    func setCustomNavigationBarSettings() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
}

