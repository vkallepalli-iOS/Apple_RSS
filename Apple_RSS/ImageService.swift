//
//  ImageService.swift
//  Apple_RSS
//
//  Created by Vamsi Kallepalli on 8/18/20.
//  Copyright © 2020 Vamsi Kallepalli. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURl, error in
            var donwloadedImage : UIImage?
            
            if let data = data {
                donwloadedImage = UIImage(data: data)
            }
            
            if(donwloadedImage != nil) {
                cache.setObject(donwloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(donwloadedImage)
            }
        }
        dataTask.resume()
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
