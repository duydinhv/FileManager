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
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFile: [File] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
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
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    // MARK: Context menu and action sheet
    func addFolderAlert() {
        let alert = UIAlertController(title: "Add Folder", message: "insert folder's name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text {
                File.createFolder(title: title)
                self.collectionView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func contextMenu(url: URL, indexPath: IndexPath) -> UIMenu {
        var actions = [UIAction]()
        let rename = UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { _ in
            let alert = UIAlertController(title: "Change document name", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?[0].text = File.files[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
                if let newTitle = alert.textFields?[0].text {
                    File.renameFile(oldName: File.files[indexPath.row].name, newName: newTitle)
                    self.collectionView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        let addToFavorite = UIAction(title: "Add to favorite", image: UIImage(systemName: "star")) { _ in
            File.files[indexPath.row].isFavorite = true
        }
        
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            let controller = UIActivityViewController(activityItems: [File.files[indexPath.row].url], applicationActivities: nil)
            controller.excludedActivityTypes = [.airDrop, .postToFacebook, .copyToPasteboard, .message, .postToTwitter, .markupAsPDF]
            self.present(controller, animated: true)
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            File.removeItem(url: url)
            File.files = File.loadFiles()
            self.collectionView.reloadData()
        }
        
        actions.append(addToFavorite)
        actions.append(rename)
        actions.append(share)
        actions.append(delete)
        
        return UIMenu(title: "", children: actions)
    }
    
    // MARK: Search func
    func filterContentForSearchText(_ searchText: String) {
        filteredFile = File.files.filter { (file: File) -> Bool in
            return file.name.lowercased().contains(searchText.lowercased())
        }
        self.collectionView.reloadData()
    }
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFile.count
        }
        return File.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCell.reuseIdentifier, for: indexPath) as? FileCell
            else {
                return UICollectionViewCell()
        }
        let file: File
        if isFiltering {
            file = filteredFile[indexPath.row]
        } else {
            file = File.files[indexPath.row]
        }
        cell.nameLabel.text = file.name
        file.generateThumbnail { image in
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = image
            }
        }
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
            return self.contextMenu(url: File.files[indexPath.row].url, indexPath: indexPath)
        })
    }
}

extension FirstViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        File.files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        File.files[index]
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

extension FirstViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
