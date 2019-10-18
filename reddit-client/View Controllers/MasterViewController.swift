//
//  MasterViewController.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/16/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var more: Bool = true
    private var after: String?
    private var detailViewController: DetailViewController? = nil
    private var posts = [Post]()

    @IBOutlet private weak var tableView: UITableView!

    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView!.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let post = posts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.post = post
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Private Methods

    private func initGUI() {
        title = NSLocalizedString("Reddit Posts", comment: "")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.register(UINib(nibName: PostCell.defaultIdentifier(), bundle: Bundle.main), forCellReuseIdentifier: PostCell.defaultIdentifier())
        tableView.addSubview(refreshControl)
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        loadPosts(refreshing: true)
    }

    @objc private func refreshData() {
        loadPosts(refreshing: true)
    }

    private func loadPosts(refreshing: Bool) {
        PostStore.posts(size: nil, after: after, completion: { [weak self] (posts, after, error) in
            self?.after = after
            if refreshing {
                self?.more = true
                self?.posts.removeAll()
                self?.posts = posts
            } else {
                self?.posts.append(contentsOf: posts)
            }
            DispatchQueue.main.async {
                guard let sself = self else {
                    return
                }
                sself.tableView.reloadSections(IndexSet([0]), with: .fade)
                if refreshing {
                    sself.refreshControl.endRefreshing()
                }
            }
            if posts.isEmpty {
                self?.more = false
            }
        })
    }

    @IBAction func dismissAll(_ sender: Any) {
        posts.removeAll()
        tableView.reloadSections(IndexSet([0]), with: .fade)
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostCell.rowHeight()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.defaultIdentifier(), for: indexPath) as? PostCell else {
            fatalError()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PostCell {   
            let post = posts[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.post = post
            cell.didTapDismissPost = { [weak self] cell in
                self?.posts.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self?.tableView.reloadSections(IndexSet([0]), with: .fade)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? PostCell else {
            fatalError()
        }
        posts[indexPath.row].read = true
        let post = posts[indexPath.row]
        cell.post = post
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

}

