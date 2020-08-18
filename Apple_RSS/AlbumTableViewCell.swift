//
//  AlbumTableViewCell.swift
//  Apple_RSS
//
//  Created by Vamsi Kallepalli on 8/10/20.
//  Copyright © 2020 Vamsi Kallepalli. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class AlbumTableViewCell: UITableViewCell {
    
    var album:Album? {
        didSet {
            guard let albumItem = album else {return}
            if let name = albumItem.name {
                albumNameLabel.text = name
            }
            if let albumUrl = albumItem.artworkUrl100 {
                let url :URL = NSURL(string: albumUrl)! as URL
                ImageService.getImage(withURL: url, completion: {image in
                    self.albumImageView.image = image
                })
            }
            if let artistName = albumItem.artistName {
                artistNameLabel.text = artistName
            }
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let albumImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 3
        img.clipsToBounds = true
        return img
    }()
    
    let albumNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor =  .gray
        //label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(albumImageView)
        containerView.addSubview(albumNameLabel)
        containerView.addSubview(artistNameLabel)
        self.contentView.addSubview(containerView)
        
        albumImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        albumImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:15).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant:50).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.albumImageView.trailingAnchor, constant:15).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-15).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        albumNameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        albumNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        albumNameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        artistNameLabel.topAnchor.constraint(equalTo:self.albumNameLabel.bottomAnchor).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo:self.albumNameLabel.bottomAnchor).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
