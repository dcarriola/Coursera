//
//  DetailViewController.swift
//  FilterNetwork
//
//  Created by Daniel Alejandro Carriola on 05.06.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    // Class variables
    var post: Post!

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Long tap gesture 
        let longTapGesture = UILongPressGestureRecognizer(target: self , action: #selector(self.onShare(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longTapGesture)
        
        // Tap to zoom
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGesture)
        
        scrollView.zoomScale = 0.25
        
        updateView()
    }
    
    // Add info to view
    func updateView() {
        imageView.clipsToBounds = true
        
        titleLbl.text = post.title
        
        // Format date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateLbl.text = formatter.string(from: post.date! as Date)
        
        if let data = Data(base64Encoded: post.image!, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: data)
            imageView.image = image
        }
        
        let image = post.like == true ? UIImage(named: "heart-full") : UIImage(named: "heart-empty")
        likeBtn.setImage(image, for: .normal)
    }
    
    // Zoom when double tapped
    func onTap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.scrollView.zoomScale = 1.5 * self.scrollView.zoomScale
        }
    }
    
    // Delete post
    func deletePost() {
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            container.viewContext.delete(post)
            
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Show alert before deletion
    @IBAction func onDelete(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to delete this photo?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.deletePost()
        }
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Change button and save like/dislike
    @IBAction func onLike(_ sender: UIButton) {
        post.setValue(!post.like, forKey: "like")
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        updateView()
    }
    
    // Show sharing menu
    @IBAction func onShare(_ sender: UIBarButtonItem) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Scroll View
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
