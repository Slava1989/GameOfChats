//
//  Extension.swift
//  GamgeOfChats
//
//  Created by Veaceslav Chirita on 10/10/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

var cacheDictionary: [String: Data] = [:]

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String?) {
        
        guard let urlString = urlString else { return }
        
        let url = URL(string: urlString)
        
        if cacheDictionary[urlString] == nil {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    cacheDictionary[urlString] = data!
                    self.image = UIImage(data: data!)
                }
                
            }.resume()
        } else {
            let data = cacheDictionary[urlString]
            self.image = UIImage(data: data!)
        }
    }
}
