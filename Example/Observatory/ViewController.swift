//
//  ViewController.swift
//  Observatory
//
//  Created by RavenDeng on 10/05/2023.
//  Copyright (c) 2023 RavenDeng. All rights reserved.
//

import UIKit

enum LogModuleCases: CaseIterable {
    case plainLog
    case tracing
}

extension LogModuleCases {
    var moduleName: String {
        switch self {
        case .plainLog:
            return "plain_log_module"
        case .tracing:
            return "tracing"
        }
    }
}

class ViewController: UIViewController {
    
    private let cellIdentifier = "log_cell_identifier"
    
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Log function module select"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogModuleCases.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logModule = LogModuleCases.allCases[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = logModule.moduleName
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let logModule = LogModuleCases.allCases[indexPath.row]
        switch logModule {
        case .plainLog:
            let controller = LogSendViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .tracing:
            let controller = TracingDemoViewController()
            navigationController?.pushViewController(controller, animated: true)
            break
        }
        
    }
}

