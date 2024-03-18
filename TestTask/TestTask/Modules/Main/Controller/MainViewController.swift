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
    
    private enum Constants {
        static let leadingTrailingInset = 32
        static let viewWithUserIamgeTopInset = 40
        static let viewWithUserImageHeightMultiplier = 0.695
        static let trashContainerBottomInset = 16
        static let trashContainerHeightMultiplier = 0.08
        static let noPermissionSize = 200
    }
    
    //MARK: - Views
    
    private let viewWithUserImage = ViewWithUserImage()
    private let trashContainerView = TrashContainerView()
    private let noPermissionsView = NoPermissionsView()
    
    //MARK: - Properties
    
    let viewModel: MainViewModel
    var isHavePermissions = true {
        didSet {
            changeUIAccordingPermissions()
        }
    }
    
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
        initialize()
   
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubviews(
            viewWithUserImage,
            trashContainerView,
            noPermissionsView
        )
        
        noPermissionsView.isHidden = true
    }
    
    private func initialize() {
        viewModel.vc = self
        viewWithUserImage.dataSource = self
        viewWithUserImage.delegate = self
        trashContainerView.dataSource = self
        trashContainerView.delegate = self
        noPermissionsView.delegate = self
    }
    
    private func changeUIAccordingPermissions() {
        viewWithUserImage.isHidden = !isHavePermissions
        trashContainerView.isHidden = !isHavePermissions
        noPermissionsView.isHidden = isHavePermissions
    }
    
    func openSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc private func appWillEnterForeground() {
        Task {
            await viewModel.askPermissions()
        }
    }
    
    //MARK: - Layout
    
    private func setupConstraints() {
        viewWithUserImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.viewWithUserIamgeTopInset)
            make.height.equalToSuperview().multipliedBy(Constants.viewWithUserImageHeightMultiplier)
        }
        
        trashContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.trashContainerBottomInset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
            make.height.equalToSuperview().multipliedBy(Constants.trashContainerHeightMultiplier)
        }
        
        noPermissionsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(Constants.leadingTrailingInset)
            make.height.equalTo(Constants.noPermissionSize)
        }
    }
}
