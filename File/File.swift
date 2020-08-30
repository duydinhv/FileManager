//
//  File.swift
//  File Manager & Browser
//
//  Created by DUY on 8/28/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit
import QuickLook

class File: NSObject {
    
    var isFavorite: Bool = false
    let url: URL

    init(url: URL) {
        self.url = url
    }

    var name: String {
        url.deletingPathExtension().lastPathComponent
    }
}

// MARK: - QLPreviewItem
extension File: QLPreviewItem {
    var previewItemURL: URL? {
        url
    }
}

// MARK: - QuickLookThumbnailing
extension File {
    func generateThumbnail(completion: @escaping (UIImage) -> Void) {
        // 1
        let size = CGSize(width: 128, height: 102)
        let scale = UIScreen.main.scale

        // 2
        let request = QLThumbnailGenerator.Request(
          fileAt: url,
          size: size,
          scale: scale,
          representationTypes: .all)

        // 3
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { thumbnail, _, error in
          if let thumbnail = thumbnail {
            completion(thumbnail.uiImage)
          } else if let error = error {
            // Handle error
            print(error)
          }
        }
      }
}

// MARK: - Helper extension
extension File {
    static func loadFiles() -> [File] {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }

        let urls: [URL]
        do {
            urls = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print("url \(urls)")
        } catch {
          fatalError("Couldn't load files from documents directory")
        }
        
        return urls.map { File(url: $0) }
    }
    
    static func removeItem(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            fatalError()
        }
    }
    
    static func createFolder(title: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let documentUrl = URL(string: documentsDirectory)!
        let dataPath = documentUrl.appendingPathComponent(title)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString.replacingOccurrences(of: "%20", with: " "), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("error \(error.localizedDescription)")
            }
        }
    }
}

extension File {
    static func copyResourcesToDocumentsIfNeeded() {
        guard UserDefaults.standard.bool(forKey: "didCopyResources") else {
          let files = [
            Bundle.main.url(forResource: "Cover Charm", withExtension: "docx"),
            Bundle.main.url(forResource: "Light Charm", withExtension: "pdf"),
            Bundle.main.url(forResource: "Parapluie Spell", withExtension: "txt"),
            Bundle.main.url(forResource: "Water Spell", withExtension: "html"),
            Bundle.main.url(forResource: "Dark Magic", withExtension: "zip")
          ]
          files.forEach {
            guard let url = $0 else { return }
            do {
              let newURL = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
              try FileManager.default.copyItem(at: url, to: newURL)
            } catch {
              print(error.localizedDescription)
            }
          }

          UserDefaults.standard.set(true, forKey: "didCopyResources")
          return
        }
    }
}
