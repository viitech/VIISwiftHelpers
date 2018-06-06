//
//  FileManager.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import Foundation
import Photos

extension FileManager {
    
    static func createDirectoryIfNotExists(_ directoryName: String) -> (Bool, URL?) {
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let folderPath = documentsPath.appendingPathComponent(directoryName)!
        
        if (!FileManager.folderExists(url: folderPath)) {
            if (FileManager.createDirectory(url: folderPath)) {
                return (true, folderPath)
            }
        } else {
            return (true, folderPath)
        }
        
        return (false, nil)
    }
    
    static func fileExists(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static func folderExists(url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        if (isDirectory.boolValue) {
            return true
        }
        return false
    }
    
    fileprivate static func createDirectory(url: URL) -> Bool {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {}
        return false
    }
    
    static func getFileName(fromPath path: String) -> String {
        let url = URL(string: path)!
        return url.lastPathComponent
    }

    static func saveImage(image: UIImage) -> (Bool, URL?) {
        if let data = image.jpeg(.medium) {
            let folderExists: Bool, folderPath: URL?
            (folderExists, folderPath) = FileManager.createDirectoryIfNotExists("Saved Images")
            if folderExists {
                var finalPath = folderPath?.appendingPathComponent("savedImage.jpeg")
                var count = 0
                while(FileManager.fileExists(url: finalPath!)) {
                    count += 1
                    finalPath = folderPath?.appendingPathComponent("savedImage-\(count).jpeg")
                }
                try? data.write(to: finalPath!)
                return (folderExists, finalPath)
            } else {
                print("Couldn't make directory")
                return (false, nil)
            }
        } else {
            print("Couldn't get image data")
            return (false, nil)
        }
    }
    
    static func saveToCameraRoll(url: URL, isVideo: Bool = false, completion: ((_ complete: Bool)->Void)! = {_ in}) {
        print("URL FOR ASSET BEFORE")
                if !isVideo {
                    print("URL FOR ASSET")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)}) { completed, error in
                            if completed {
                                print("Asset created")
                                completion(true)
                            } else {
                                print(error as Any)
                                completion(false)
                            }
                    }
                } else {
                    print("URL FOR ASSET VID")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)}) { completed, error in
                            if completed {
                                print("Asset created")
                                completion(true)
                            } else {
                                print(error as Any)
                                completion(false)
                            }
                    }
                }
        
                
//        do {
//            try FileManager.default.moveItem(at: url, to: destinationURL)
//
//
//
//        } catch { print(error) }
    }
}
