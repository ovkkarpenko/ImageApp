//
//  NetworkManager.swift
//  ImageApp
//
//  Created by Oleksandr Karpenko on 13.12.2020.
//

import UIKit
import Foundation

class NetworkManager {
    
    private var downloadTask: URLSessionDownloadTask?
    var delegate: URLSessionDownloadDelegate
    
    init(delegate: URLSessionDownloadDelegate) {
        self.delegate = delegate
    }
    
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue.main
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: operationQueue)
        
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    func abort() {
        downloadTask?.cancel()
    }
    
    func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    func getURLFromString(_ str: String) -> URL? {
        return URL(string: str)
    }
    
    func getUIImageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
