//
//  FirstViewController.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/11/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit
import QuickLook


class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var tappedCell: FileCell?
    var files = File.loadFiles()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func addButtonDidTapped(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let createFolderAction = UIAlertAction(title: "Create Folder", style: .default,
                                               handler: { (_ ) in
                                                self.addFolderAlert()
        })
        let addPhotoAction = UIAlertAction(title: "Add Photo or Video", style: .default)
        let pasteClipboardAction = UIAlertAction(title: "Paste from clipboard", style: .default)
        let addNoteAction = UIAlertAction(title: "Add Note", style: .default)
        let addVoiceAction = UIAlertAction(title: "Add Voice Memo", style: .default)
        let addFileFromWeb = UIAlertAction(title: "Add File From Web", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(createFolderAction)
        optionMenu.addAction(addPhotoAction)
        optionMenu.addAction(pasteClipboardAction)
        optionMenu.addAction(addNoteAction)
        optionMenu.addAction(addVoiceAction)
        optionMenu.addAction(addFileFromWeb)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func addFolderAlert() {
        let alert = UIAlertController(title: "Add Folder", message: "insert folder's name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text {
                File.createFolder(title: title)
                self.files = File.loadFiles()
                self.collectionView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func contextMenu(url: URL, index: Int) -> UIMenu {
        var actions = [UIAction]()
        let rename = UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { _ in
            let alert = UIAlertController(title: "Change folder name", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
                if let newTitle = alert.textFields?[0].text {
                    do {
                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        let documentDirectory = paths[0]
                        let documentURL = URL(string: documentDirectory)!
                        let originPath = documentURL.appendingPathComponent(self.files[index].name)
                        let destinationPath = documentURL.appendingPathComponent(newTitle)
                        try FileManager.default.moveItem(at: originPath, to: destinationPath)
                        self.files = File.loadFiles()
                        self.collectionView.reloadData()
                    } catch {
                        print(error)
                    }
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }))
            self.present(alert, animated: true)
        }
        
        let addToFavorite = UIAction(title: "Add to favorite", image: UIImage(systemName: "star")) { _ in
            
        }
        
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            let controller = UIActivityViewController(activityItems: [self.files[index].url], applicationActivities: nil)
            controller.excludedActivityTypes = [.airDrop, .postToFacebook, .copyToPasteboard, .message, .postToTwitter, .markupAsPDF]
            self.present(controller, animated: true)
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            File.removeItem(url: url)
            self.files = File.loadFiles()
            self.collectionView.reloadData()
        }
        
        actions.append(addToFavorite)
        actions.append(rename)
        actions.append(share)
        actions.append(delete)
        
        return UIMenu(title: "", children: actions)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCell.reuseIdentifier, for: indexPath) as? FileCell
            else {
                return UICollectionViewCell()
        }
        cell.update(with: files[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let quickLookViewController = QLPreviewController()
        quickLookViewController.dataSource = self
        quickLookViewController.delegate = self
        tappedCell = collectionView.cellForItem(at: indexPath) as? FileCell
        quickLookViewController.currentPreviewItemIndex = indexPath.row
        present(quickLookViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { action in
            return self.contextMenu(url: self.files[indexPath.row].url, index: indexPath.row)
        })
    }
}

extension FirstViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        files[index]
    }
}

extension FirstViewController: QLPreviewControllerDelegate {
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        tappedCell?.thumbnailImageView
    }

    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        .updateContents
    }

    func previewController(_ controller: QLPreviewController, didUpdateContentsOf previewItem: QLPreviewItem) {
        guard let file = previewItem as? File else { return }
        DispatchQueue.main.async {
            self.tappedCell?.update(with: file)
        }
    }
}

