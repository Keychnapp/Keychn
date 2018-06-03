//
//  VimeoVideoExtractor.swift
//  Keychn
//
//  Created by Rohit Kumar on 03/06/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

import UIKit
import HCVimeoVideoExtractor

public class VimeoVideoExtractor: NSObject {

    @objc public func absoluteVimeoURL(with videoURL:String, completion: @escaping(_ videoURL: URL) -> Void) {
        if let url = URL.init(string: videoURL) {
            HCVimeoVideoExtractor.fetchVideoURLFrom(url: url) { (vimeoVideo, error) in
                if let videoDetails =  vimeoVideo,
                    let extractedVideoURL = videoDetails.videoURL[.Quality1080p] {
                    print("Extracted URL \(extractedVideoURL)")
                    completion(extractedVideoURL)
                }
            }
        }
        
    }
    
}
