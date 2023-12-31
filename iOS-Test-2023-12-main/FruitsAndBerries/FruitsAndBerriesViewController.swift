//
//  FruitsAndBerriesViewController.swift
//  iOS-Test
//

import UIKit

protocol FruitsAndBerriesDisplayLogic: AnyObject {
    func display(model: FruitsAndBerriesModels.Load.ViewModel)
}

final class FruitsAndBerriesViewController: UIViewController {
    public var interactor: FruitsAndBerriesBusinessLogic?
    public var router: FruitsAndBerriesRoutingLogic?
    private var viewModel: FruitsAndBerriesModels.Load.ViewModel?
    
    // MARK: - Properties
    private let ringView = UIRingLoaderView()
    private let refreshControl = UIRefreshControl()
    public lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(FruitTableViewCell.self, forCellReuseIdentifier: "FruitTableViewCell")
        return table
    }()
    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textColor = .systemGray5
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No items"
        return label
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.load(request: .init())
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemPink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    // MARK: - Common
    
    @objc func refreshButtonTapped() {
        self.ringView.startAnimating()
        emptyListLabel.alpha = 0
        tableView.alpha = 0
        interactor?.load(request: .init())
    }
    private func setupUI() {
        self.navigationItem.title = "Fruits and Berries"
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh_button"), style: .done, target: self, action: #selector(refreshButtonTapped))
        refreshButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = refreshButton
        
        view.addSubview(tableView)
        view.addSubview(emptyListLabel)
        view.addSubview(ringView)
        ringView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyListLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ringView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ringView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
        tableView.addSubview(refreshControl)
        tableView.separatorColor = .clear
        tableView.alpha = 0
        refreshControl.addTarget(self, action: #selector(refreshButtonTapped), for: .valueChanged)
        ringView.startAnimating()
        refreshControl.tintColor = .clear
    }
    
}
// MARK: - Table View Delegate & Data Source
extension FruitsAndBerriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FruitTableViewCell", for: indexPath) as? FruitTableViewCell else {
            return UITableViewCell()
        }
        if let item = viewModel?.items[indexPath.row] {
            cell.configure(with: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel?.items[indexPath.row] else { return }
        router?.navigateToDetails(item: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FruitsAndBerriesViewController: FruitsAndBerriesDisplayLogic {
    func display(model: FruitsAndBerriesModels.Load.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel = model
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            UIView.animate(withDuration: 0.5) {
                
                self.emptyListLabel.alpha = model.items.isEmpty ? 1 : 0
                self.tableView.alpha = model.items.isEmpty ? 0 : 1
            }
        }
        let timeAwait = model.items.isEmpty ? 0.5 : 0.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeAwait) { [weak self] in
            guard let self = self else { return }
            self.ringView.stopAnimating()
        }
    }
}

