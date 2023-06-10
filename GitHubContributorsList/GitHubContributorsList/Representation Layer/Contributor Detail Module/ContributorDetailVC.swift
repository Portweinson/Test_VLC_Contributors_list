//
//  ContributorDetailVC.swift
//  GitHubContributorsList
//
//  Created by Viacheslav Embaturov on 18.05.2021.
//

import UIKit


struct ContributorDetailViewModel {
    let login: String
    let image: UIImage?
}


class ContributorDetailVC: UIViewController, TransitionViewProtocol {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var labelLogin: UILabel!
    
    
    //MARK: - Class Variables
    
    var viewModel: ContributorDetailViewModel?
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        avatarImageView.image = viewModel?.image
        labelLogin.text = viewModel?.login
    }
}
