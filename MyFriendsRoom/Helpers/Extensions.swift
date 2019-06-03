//
//  Extensions.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 03.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageusingCacheWithUrlString(urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)!
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error
            //URLSession.shared.dataTaskWithURL(url!, completionHandler: {(data, response, error)
            in
            if error != nil{
                print(error)
                return
            }
            DispatchQueue.main.async{
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                
                    self.image = downloadedImage
                }
            }
            
            }.resume()
    }
}
