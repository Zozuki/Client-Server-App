//
//  PhotoService.swift
//  Lesson1B2
//
//  Created by user on 26.07.2021.
//

import UIKit

class PhotoService {
    
    private static let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    
    private static let cacheImagesURL: URL? = {
        let path = "Images"
        
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let imagesFolderURL = cacheDirectory.appendingPathComponent(path, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: imagesFolderURL.path) {
            try? FileManager.default.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: [:])
        }
        
        return imagesFolderURL
    }()
    
    private var memoryImageCache: [String: UIImage] = [:]
    
    // MARK: - Private Methods
    
    private func getFilePath(at url: URL) -> String? {
        let hashName = url.lastPathComponent
        return Self.cacheImagesURL?.appendingPathComponent(hashName).path
    }
    
    private func saveImageToCache(_ image: UIImage, with url: URL) {
        guard let filePath = self.getFilePath(at: url) else { return }
        let imageData = image.pngData()
        FileManager.default.createFile(atPath: filePath, contents: imageData)
    }
    
    private func getImageFromCache(at url: URL) -> UIImage? {
        guard let filePath = self.getFilePath(at: url) else { return nil }
        
        guard let modificationDate = try? FileManager.default.attributesOfItem(atPath: filePath)[.modificationDate] as? Date else {
            return nil
        }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= Self.cacheLifeTime,
              let image = UIImage(contentsOfFile: filePath) else {
            return nil
        }
        
        DispatchQueue.main.async {
            self.memoryImageCache[filePath] = image
        }
        
        return image
    }
    
    
    private var container: DataReloadable
    
    init(container: DataReloadable) {
        self.container = container
    }
}

extension PhotoService {
    private func loadPhoto(at indexPath: IndexPath, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                guard let filePath = self.getFilePath(at: url) else { return }
                self.memoryImageCache[filePath] = image
            }
            
            self.saveImageToCache(image, with: url)
            
            DispatchQueue.main.async {
                self.container.reloadRows(at: [indexPath])
            }
        }.resume()
    }
    
    func getPhoto(at indexPath: IndexPath, url: URL) -> UIImage? {
        if let filePath = self.getFilePath(at: url),
           let image = self.memoryImageCache[filePath] {
            return image
        } else if let image = self.getImageFromCache(at: url) {
            return image
        } else {
            loadPhoto(at: indexPath, url: url)
            return nil
        }
    }
}

protocol DataReloadable {
    func reloadRows(at indexPaths: [IndexPath])
}

extension PhotoService {
    class Table: DataReloadable {
        
        unowned let tableView: UITableView
        
        init(tableView: UITableView) {
            self.tableView = tableView
        }
        
        func reloadRows(at indexPaths: [IndexPath]) {
            tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    class Collection: DataReloadable {
        unowned let collectionView: UICollectionView
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
        }
        
        func reloadRows(at indexPaths: [IndexPath]) {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}

