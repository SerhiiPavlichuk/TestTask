//
//  MainViewController.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    //MARK: - Constants
    
    private enum Constraints {
        static let leadingTrailingInset = 32
    }
    
    //MARK: - Views
    
    let viewWithUserImage = ViewWithUserImage()
    
    //MARK: - Properties
    
    let viewModel: MainViewModel
    
    //MARK: - Init
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubviews(
            viewWithUserImage
        )
    }
    
    private func initializeViews() {
        viewWithUserImage.dataSource = self
        viewWithUserImage.delegate = self
    }
    
    //MARK: - Layout
    
    private func setupConstraints() {
        viewWithUserImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraints.leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            make.height.equalToSuperview().multipliedBy(0.695)
        }
    }
}
