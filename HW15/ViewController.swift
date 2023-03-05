//
//  ViewController.swift
//  HW15
//
//  Created by Павел on 14.02.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private let cellIdentifier = "Cell"
    private var array: [TextModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        view.backgroundColor = .systemBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tableView.snp.top)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: array[indexPath.row])
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        APIServise.getData(bySearch: text) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let json):
                var array: [TextModel] = []
                for model in json {
                    guard
                        let description = model["description"] as? String,
                        let title = model["title"] as? String,
                        let image = model["image"] as? String
                    else {
                        continue
                    }
                    let textModel = TextModel(title: title, description: description, image: image)
                    array.append(textModel)
                }
                self?.array = array
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
