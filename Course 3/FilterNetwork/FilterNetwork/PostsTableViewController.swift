
//
//  PostsTableViewController.swift
//  FilterNetwork
//
//  Created by Daniel Alejandro Carriola on 05.06.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    // Class variables
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPosts()
    }
    
    // Load all posts
    func loadPosts() {
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            do {
                posts = try container.viewContext.fetch(Post.fetchRequest())
                print(posts)
            } catch {
                print("Error")
            }
        }
        tableView.reloadData()
    }
    
    // Delete post
    func deletePost(at indexPath: IndexPath) {
        let post = posts[indexPath.row]
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            container.viewContext.delete(post)
            
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
            loadPosts()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IDCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        cell.configureCell(withPost: posts[indexPath.row])
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to delete this photo?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                self.deletePost(at: indexPath)
            }
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let detailVC = segue.destination as! DetailViewController
            detailVC.post = posts[indexPath.row]
        }
    }

}
