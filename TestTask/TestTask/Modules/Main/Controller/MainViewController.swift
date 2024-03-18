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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    //MARK: - Methods
    
    private func setupUI() {

    }
    
    //MARK: - Layout
    
    private func setupConstraints() {

    }
}
