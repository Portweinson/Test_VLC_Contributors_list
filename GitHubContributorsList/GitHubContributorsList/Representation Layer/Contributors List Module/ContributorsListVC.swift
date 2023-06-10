//
//  ContributorsListVC.swift
//  GitHubContributorsList
//
//  Created by Viacheslav Embaturov on 18.05.2021.
//

import UIKit


class ContributorsListVC: UITableViewController, ShowAlertProtocol {
    
    
    //MARK: -
    
    enum CellIdetifiers: String {
        case contributor = "ContributorCell"
    }
    
    enum Segue: String {
        case toDetail = "Contrib list to contrib details"
    }
    
    //MARK: - class variables

    private var viewModel = ContributorsListViewModel()
    weak var selectedCell: ContributorInfoCell?
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupNavigation()
        setupTableView()
        loadData()
    }

    // MARK: - Setup

    private func setupNavigation() {
        self.navigationController?.delegate = self
    }

    private func setupViewModel() {
        viewModel.delegate = self
    }

    private func setupTableView() {
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }

    
    // MARK: - Data loading

    @objc private func loadData() {
        viewModel.loadData()
    }

    private func handleError(_ error: ResponseError) {
        let title = "Something went wrong"
        let message = "Please try again later"
        let action = UIAlertAction(title: "Dismiss", style: .cancel)

        showAlert(with: title, message: message, actions: [action])
    }

    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contributorsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdetifiers.contributor.rawValue,
            for: indexPath) as? ContributorInfoCell else {
            return UITableViewCell()
        }

        let contributorCellViewModel = viewModel.contributorCellViewModel(at: indexPath.row)
        cell.configure(with: contributorCellViewModel)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cCell = cell as? ContributorInfoCell {
            cCell.didEndDisplay()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ContributorInfoCell {
            
            viewModel.selectContributor(at: indexPath.row)
            self.selectedCell = cell
            self.performSegue(withIdentifier: Segue.toDetail.rawValue, sender: nil)
        }
    }
    
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toDetail.rawValue, let data = viewModel.selectedContributor {
            if let vc = segue.destination as? ContributorDetailVC {
                let viewModel = ContributorDetailViewModel(login: data.login, image: selectedCell?.avatarImageView.image)
                vc.viewModel = viewModel
            }
        }
        super.prepare(for: segue, sender: sender)
    }
}


// MARK: - ContributorsListViewModelDelegate

extension ContributorsListVC: ContributorsListViewModelDelegate {
    func contributorsLoaded() {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl?.endRefreshing()
        }

    }

    func showError(_ error: ResponseError) {
        handleError(error)
    }
}



//MARK: - UINavigationControllerDelegate

extension ContributorsListVC: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            if let to = toVC as? TransitionViewProtocol,
               let fromView = self.selectedCell {
                return AvatarTransitionAnimator(duration: 0.35, fromView: fromView, toView: to)
            } else {
                return nil
            }
        case .pop:
            if let from = fromVC as? TransitionViewProtocol,
               let to = self.selectedCell {
                return AvatarTransitionAnimator(duration: 0.35, fromView: from, toView: to)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
