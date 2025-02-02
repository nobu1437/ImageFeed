//
//  ViewController.swift
//  ImageFeed
//
//  Created by Andrey Nobu on 25.01.2025.
//

import UIKit

class ImageListViewController: UIViewController {
    
    let imageArr: [String] = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19"]
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
    }

    func configCell(for cell: ImagesListCell) { }
}

