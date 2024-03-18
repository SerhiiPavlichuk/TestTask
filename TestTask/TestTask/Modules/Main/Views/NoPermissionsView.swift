//
//  NoPermissionsView.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit
import SnapKit

protocol NoPermissionsViewDelegate: AnyObject {
    func showSettings()
}

final class NoPermissionsView: CustomView {
    
    //MARK: - Constants
    
    private enum Constants {
        static let infoLabelText = """
                                    Sorry we can't get photos,
                                    enyway you can give
                                    acces in settings
                                   """
        static let infoLabelNumberOfLines = 4
        static let goToSettingsButtonTitle = "Go to settings"
        static let goToSettingsButtonContentsInset: CGFloat = 10
        static let leadingTrailingInset = 50
        static let goToSettingsButtonWidthMultiplier = 0.5
        static let goToSettingsButtonTopOffset = 20
    }
    
    //MARK: - Views
    
    private let infoLabel = LabelBuilder()
        .setText(Constants.infoLabelText)
        .setNumbersLines(Constants.infoLabelNumberOfLines)
        .setTextAligtment(.center)
        .setTextColor(.white)
        .build()
    
    private lazy var goSettingsButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.goToSettingsButtonTitle
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.goToSettingsButtonContentsInset,
            leading: Constants.goToSettingsButtonContentsInset,
            bottom: Constants.goToSettingsButtonContentsInset,
            trailing: Constants.goToSettingsButtonContentsInset
        )
        configuration.baseBackgroundColor = .trashButton
        let goSettingsButton = UIButton(configuration: configuration)
        goSettingsButton.addAction(UIAction {[weak self] _ in self?.goSettingsButtonPressed()}, for: .touchUpInside)
        return goSettingsButton
    }()
    
    //MARK: - Init
    
    weak var delegate: NoPermissionsViewDelegate?
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    
    override func setupUI() {
        backgroundColor = .clear

        addSubviews(
            infoLabel,
            goSettingsButton
        )
    }
    
    private func goSettingsButtonPressed() {
        delegate?.showSettings()
    }
    
    //MARK: - Layout
    
    override func setupLayout() {
        super.setupLayout()
        infoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.leadingTrailingInset)
        }
        
        goSettingsButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.leadingTrailingInset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Constants.goToSettingsButtonWidthMultiplier)
            make.top.equalTo(infoLabel.snp.bottom).offset(Constants.goToSettingsButtonTopOffset)
        }
    }
}
