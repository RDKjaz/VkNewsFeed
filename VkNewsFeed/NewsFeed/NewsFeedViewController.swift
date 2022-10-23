//
//  NewsFeedViewController.swift
//  VkNewsFeed
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

    var interactor: NewsFeedBusinessLogic?

    private var feedViewModel = FeedViewModel(cells: [])

    @IBOutlet weak var table: UITableView!
    private var titleView = TitleView()
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: Setup

    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        viewController.interactor = interactor
        interactor.presenter      = presenter
        presenter.viewController  = viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        setup()
        setupTopBar()
        setupTable()
        
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUser)
    }
    
    /// Setup top bar
    private func setupTopBar() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    /// Setup table
    private func setupTable() {
        table.register(NewsFeedCell.self, forCellReuseIdentifier: String(describing: NewsFeedCell.self))
        table.backgroundColor = .clear
        table.separatorStyle = .none
        
        table.addSubview(refreshControl)
    }

    func displayData(viewModel: ViewModelData) {
        switch viewModel {
        case .displayNewsFeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            table.reloadData()
            refreshControl.endRefreshing()
        case .displayUser(userViewModel: let userViewModel):
            titleView.set(userViewModel: userViewModel)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatchNews)
        }
    }
    
    /// Refresh news feed
    @objc func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsFeedCell.self), for: indexPath) as? NewsFeedCell else { return UITableViewCell() }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedViewModel.cells[indexPath.row].sizes.totalHeight
    }
}

// MARK: - NewsFeedCellDelegate

extension NewsFeedViewController: NewsFeedCellDelegate {

    func revealPost(for cell: NewsFeedCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]

        interactor?.makeRequest(request: .revealPost(postId: cellViewModel.postId))
    }
}
