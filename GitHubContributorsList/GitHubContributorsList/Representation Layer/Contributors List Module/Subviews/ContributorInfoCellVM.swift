//
//  ContributorInfoCellVM.swift
//  GitHubContributorsList
//
//  Created by Viacheslav Embaturov on 18.05.2021.
//

import UIKit

protocol ContributorCellViewModelDelegate: AnyObject {
    func cellImageReady(_ image: UIImage?)
}

class ContributorCellViewModel {

    //MARK: - class variables

    let contributor: Contributor
    weak var delegate: ContributorCellViewModelDelegate?
    private let avatarPlaceholder = UIImage(named: "icon-avatar-placeholder-80x80")

    var avatarUrl: URL? {
        return contributor.avatarUrl
    }

    var id: String {
        return String(contributor.id)
    }

    var loginName: String {
        return contributor.login
    }


    //MARK: - lifacycle

    init(contributor: Contributor) {
        self.contributor = contributor
    }


    // MARK: -

    func loadImageIfNeeded() {
        if let imgUrl = avatarUrl {
            ImageFetchingService.shared.fetchImage(with: imgUrl) { [weak self] image in
                self?.delegate?.cellImageReady(image ?? self?.avatarPlaceholder)
            }
        } else {
            self.delegate?.cellImageReady(self.avatarPlaceholder)
        }
    }

    func cancelImageLoading() {
        if let imgUrl = avatarUrl {
            ImageFetchingService.shared.cancelDownloadIfNeeded(for: imgUrl)
        }
    }
}
