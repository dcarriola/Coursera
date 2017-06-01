//
//  ViewController.swift
//  Filterer
//
//  Created by Daniel Alejandro Carriola on 29.05.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet var editMenu: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var originalLbl: UILabel!
    @IBOutlet weak var slider: UISlider!    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        editMenu.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Touch on image
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imageView {
                crossFadeTransition(withImage: originalImage)
                originalLbl.isHidden = false
            }
        }
    }
    
    // Touch was released
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imageView {
                crossFadeTransition(withImage: filteredImage)
                originalLbl.isHidden = true
            }
        }
    }
    
    // Tap for zoom
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.zoomScale = 1.5 * self.scrollView.zoomScale
        }
    }
    
    // Adjust the value of the filter using the slider
    @IBAction func changeValue(_ sender: UISlider) {
        filteredImage = filter.applyFilter(withName: filterChosen, withIntensity: Int(sender.value))
        crossFadeTransition(withImage: filteredImage)
    }
    
    // Show/hide slider view when clicked
    @IBAction func onEdit(_ sender: UIButton) {
        if sender.isSelected {
            hideSecondaryView(editMenu)
            showSecondaryMenu(secondaryMenu)
            sender.isSelected = false
            slider.setValue(0, animated: false) // Reset slider
        } else {
            if filterBtn.isSelected {
                hideSecondaryView(secondaryMenu)
                showSecondaryMenu(editMenu)
                sender.isSelected = true
            }
        }
    }
    
    // Show/hide filters's view
    @IBAction func onFilter(_ sender: UIButton) {
        if sender.isSelected {
            hideSecondaryView(secondaryMenu)
            sender.isSelected = false
            editBtn.isHidden = true
        } else {
            showSecondaryMenu(secondaryMenu)
            sender.isSelected = true
            editBtn.isHidden = false
            editBtn.isEnabled = false
        }
    }
    
    // Show filters's view with animation
    func showSecondaryMenu(_ viewToShow: UIView) {
        view.addSubview(viewToShow)
        
        // Layout
        let bottomConstraint = viewToShow.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = viewToShow.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = viewToShow.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = viewToShow.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        
        // Animation
        viewToShow.alpha = 0
        UIView.animate(withDuration: 0.4) {
            viewToShow.alpha = 1
        }
    }
    
    // Hide filters's view with animation
    func hideSecondaryView(_ viewToHide: UIView) {
        // Animation
        UIView.animate(withDuration: 0.4, animations: {
            viewToHide.alpha = 0
        }) { (success) in
            if success {
                viewToHide.removeFromSuperview()
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
            crossFadeTransition(withImage: filteredImage)
            sender.isSelected = false
            originalLbl.isHidden = true
        } else {
            crossFadeTransition(withImage: originalImage)
            sender.isSelected = true
            originalLbl.isHidden = false
        }
    }
    
    // Show menu for sharing
    @IBAction func onShare(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
    
    // Add image with cross-fade transition
    func crossFadeTransition(withImage image: UIImage?) {
        UIView.transition(with: imageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
        }, completion: nil)

    }
    
    // Reset values
    func reset() {
        filteredImage = nil
        filterBtn.isSelected = false
        editBtn.isSelected = false
        editBtn.isHidden = true
        compareBtn.isEnabled = false
        hideSecondaryView(secondaryMenu)
        hideSecondaryView(editMenu)
        imageView.isUserInteractionEnabled = false
        slider.setValue(0, animated: false)
    }
    
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
        filterChosen = filters[indexPath.row]
        
        // Add image with cross-fade transition
        crossFadeTransition(withImage: filteredImage)
        
        // Enable buttons after choosing filter
        imageView.isUserInteractionEnabled = true
        compareBtn.isEnabled = true
        editBtn.isEnabled = filterChosen == .red || filterChosen == .blue || filterChosen == .green ? true : false
    }

    // MARK: - Image Picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            filter = Filter(image: image)
            
            // Reset buttons
            reset()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        reset()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Scroll View
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

