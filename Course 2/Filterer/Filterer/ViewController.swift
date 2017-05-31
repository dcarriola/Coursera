//
//  ViewController.swift
//  Filterer
//
//  Created by Daniel Alejandro Carriola on 29.05.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet var editMenu: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var originalLbl: UILabel!
    
    // Class variables
    var originalImage: UIImage?
    var filteredImage: UIImage?
    var filter: Filter!
    var filterChosen: FilterName!
    let filters: [FilterName] = [.red, .green, .blue, .grayScale, .sepia]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide edit button until needed
        editBtn.isHidden = true
        
        // Disable compare button until needed
        compareBtn.isEnabled = false
        
        // Connect collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        originalLbl.isHidden = true
        originalImage = imageView.image
        filter = Filter(image: originalImage!)
        
        // Style menu
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false // I control the constraints, no need to do auto stuff
    }
    
    // Touch on image
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imageView {
                imageView.image = originalImage
                originalLbl.isHidden = false
            }
        }
    }
    
    // Touch was released
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imageView {
                imageView.image = filteredImage
                originalLbl.isHidden = true
            }
        }
    }
    
    // Adjust the value of the filter using the slider
    @IBAction func changeValue(_ sender: UISlider) {
    }
    
    // Show/hide slider view when clicked
    @IBAction func onEdit(_ sender: UIButton) {
    }
    
    // Show/hide filters's view
    @IBAction func onFilter(_ sender: UIButton) {
        if sender.isSelected {
            hideSecondaryView()
            sender.isSelected = false
            editBtn.isHidden = true
        } else {
            showSecondaryMenu()
            sender.isSelected = true
            editBtn.isHidden = false
        }
    }
    
    // Show filters's view with animation
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        // Layout
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        
        // Animation
        secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1
        }
    }
    
    // Hide filters's view with animation
    func hideSecondaryView() {
        // Animation
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { (success) in
            if success {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    // Display action sheet to choose a new photo source
    @IBAction func onNewPhoto(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { (action) in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Choose camera
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // Choose photo album
    func showAlbum() {
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        albumPicker.sourceType = .photoLibrary
        present(albumPicker, animated: true, completion: nil)
    }
    
    // Compare original and filtered images
    @IBAction func onCompare(_ sender: UIButton) {
        if sender.isSelected {
            imageView.image = filteredImage
            sender.isSelected = false
            originalLbl.isHidden = true
        } else {
            imageView.image = originalImage
            sender.isSelected = true
            originalLbl.isHidden = false
        }
    }
    
    // Show menu for sharing
    @IBAction func onShare(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
    
    // Change images between filtered and original
//    @IBAction func changeImage(_ sender: UIButton) {
//        if !sender.isSelected {
//            imageView.image = filteredImage
//            sender.isSelected = true
//        } else {
//            imageView.image = UIImage(named: "silvi")
//            sender.isSelected = false
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else { return UICollectionViewCell() }
        cell.configureCell(withFilter: filters[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteredImage = filter.applyFilter(withName: filters[indexPath.row])
        imageView.image = filteredImage
        filterChosen = filters[indexPath.row]
        
        // Enable compare
        imageView.isUserInteractionEnabled = true
        compareBtn.isEnabled = true
    }

    // MARK: - Image Picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            filter = Filter(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

