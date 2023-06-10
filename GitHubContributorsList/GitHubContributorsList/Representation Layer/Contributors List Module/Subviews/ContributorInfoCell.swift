//
//  ContributorInfoCell.swift
//  GitHubContributorsList
//
//  Created by Viacheslav Embaturov on 18.05.2021.
//

import UIKit

class ContributorInfoCell: UITableViewCell, TransitionViewProtocol {
    
    //MARK: - outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var labelId: UILabel!


    //MARK: - class variables

    private var viewModel: ContributorCellViewModel?


    //MARK: -

    func configure(with viewModel: ContributorCellViewModel) {

        self.viewModel = viewModel
        viewModel.delegate = self
        self.labelLogin.text = viewModel.loginName
        self.labelId.text = viewModel.id

        viewModel.loadImageIfNeeded()
    }

    func didEndDisplay() {
        viewModel?.cancelImageLoading()
    }
}

extension ContributorInfoCell: ContributorCellViewModelDelegate {

    func cellImageReady(_ image: UIImage?) {
        self.avatarImageView.image = image
    }
}
