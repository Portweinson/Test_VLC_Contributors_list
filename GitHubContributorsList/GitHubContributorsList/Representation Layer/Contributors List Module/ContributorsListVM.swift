//
//  ContributorsListVM.swift
//  GitHubContributorsList
//
//  Created by Viacheslav Embaturov on 18.05.2021.
//

import Foundation

protocol ContributorsListViewModelDelegate: AnyObject {
    func contributorsLoaded()
    func showError(_ error: ResponseError)
}

class ContributorsListViewModel {

    //MARK: - class variables

    weak var delegate: ContributorsListViewModelDelegate?

    private let networkClient = ContributorsNetworkClient()
    private var isDataFetchInProgress = false
    private var contributors = [Contributor]()

    var contributorsCount: Int {
        return contributors.count
    }
    private(set) var selectedContributor: Contributor?


    //MARK: - lifecycle

    deinit {
        ImageFetchingService.shared.cancelDownloads()
    }

    //MARK: -

    func loadData() {
        guard !isDataFetchInProgress else { return }

        isDataFetchInProgress = true
        delegate?.contributorsLoaded()

        networkClient.allContributors { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let data):
                    self?.contributors = data
                case .failure(let error):
                    self?.delegate?.showError(error)
                }

                self?.isDataFetchInProgress = false
                self?.delegate?.contributorsLoaded()
            }
        }
    }

    func contributorCellViewModel(at index: Int) -> ContributorCellViewModel {
        let contributor = contributors[index]
        return ContributorCellViewModel(contributor: contributor)
    }

    func selectContributor(at index: Int) {
        selectedContributor = self.contributors[index]
    }
}
