//
//  ViewController.swift
//  marathon4task
//
//  Created by Vika on 11.11.24.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private var data: [(text: String, isSelected: Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        for i in 0..<30 {
            data.append((text: "\(i)", isSelected: false))
        }
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemGray6
        
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.title = "Task 4"
        let shuffleButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleData))
        navigationItem.rightBarButtonItem = shuffleButton
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = data[indexPath.row]
        cell.textLabel?.text = item.text
        cell.accessoryType = item.isSelected ? .checkmark : .none
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var selectedItem = data[indexPath.row]
        selectedItem.isSelected.toggle()
        
        if selectedItem.isSelected {
            data.remove(at: indexPath.row)
            data.insert(selectedItem, at: 0)
            
            // перемещение ячейки на первое место
            tableView.performBatchUpdates({
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            }, completion: { _ in
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            })
        } else {
            data[indexPath.row] = selectedItem // Если убираем галочку, просто обновляем ячейку без перемещения
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Actions
    
    @objc private func shuffleData() {
        
        let originalData = data // Запоминаем текущие индексы ячеек
        data.shuffle()
        
        tableView.performBatchUpdates({
            for i in 0..<data.count {
                let newIndex = data.firstIndex(where: { $0.text == originalData[i].text })!
                tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: newIndex, section: 0))
            }
        }, completion: nil)
    }
}

