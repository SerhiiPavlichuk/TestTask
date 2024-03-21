//
//  TrashContainerView.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit
import SnapKit

protocol TrashContainerViewDataSource: AnyObject {
    func countOfImages(_ view: TrashContainerView) -> Int?
}

protocol TrashContainerViewDelegate: AnyObject {
    func emptyTrashPressed()
}

final class TrashContainerView: CustomView {
    
    //MARK: - Constants
    
    private enum Constants {
        static let countLabelText = "0"
        static let countInfoLabelText = """
                                        images in
                                        the trash
                                        """
        static let countInfoLabelNumberOfLines = 2
        static let emptytrashButtontext = "Empty Trash"
        static let insetTen: CGFloat = 10
        static let countLabelLeadingInset = 20
        static let countInfoLabelLeadingInset = -10
        static let emptyTrashButtonInset = 12
        static let emptyTrashButtonWidthMultiplier = 0.5
        static let parentCornerMultiplier = 0.33
        static let countLabelFontSizeMultiplier = 0.36
        static let countInfoLabelFontSizeMultiplier = 0.194
    }
    
    //MARK: - Views
    
    private let countLabel = LabelBuilder()
        .setText(Constants.countLabelText)
        .build()
    
    private let countInfoLabel = LabelBuilder()
        .setText(Constants.countInfoLabelText)
        .setNumbersLines(Constants.countInfoLabelNumberOfLines)
        .build()
    
    private lazy var emptyTrashButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.emptytrashButtontext
        configuration.image = Images.emptyTrashImage.setImage()
        configuration.imagePadding = Constants.insetTen
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.insetTen,
            leading: Constants.insetTen,
            bottom: Constants.insetTen,
            trailing: Constants.insetTen
        )
        configuration.baseBackgroundColor = .trashButton
        let emptyTrashButton = UIButton(configuration: configuration)
        emptyTrashButton.semanticContentAttribute = .forceLeftToRight
        emptyTrashButton.addAction(UIAction {[weak self] _ in self?.emptyTrashButtonPressed()}, for: .touchUpInside)
        return emptyTrashButton
    }()
    
    //MARK: - Init
    
    weak var dataSource: TrashContainerViewDataSource?
    weak var delegate: TrashContainerViewDelegate?
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    override func setupUI() {
        backgroundColor = .trashMenu
        clipsToBounds = true
        
        addSubviews(
            countLabel,
            countInfoLabel,
            emptyTrashButton
        )
    }
    
    @MainActor
    func reloadData() async {
        configureUI()
    }
    
    private func configureUI() {
        guard let dataSource else { return }
        if let count = dataSource.countOfImages(self) {
            emptyTrashButton.isEnabled = count != .zero
            countLabel.text = String(count)
        }
    }
    
    private func emptyTrashButtonPressed() {
        delegate?.emptyTrashPressed()
    }
    
    //MARK: - Layout
    
    override func setupLayout() {
        super.setupLayout()
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constants.countLabelLeadingInset)
            
        }
        
        countInfoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(countLabel.snp.trailing).inset(Constants.countInfoLabelLeadingInset)
        }
        
        emptyTrashButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(Constants.emptyTrashButtonInset)
            make.width.equalToSuperview().multipliedBy(Constants.emptyTrashButtonWidthMultiplier)
        }
    }
    
    override func setupSizes() {
        layer.cornerRadius = self.bounds.height * Constants.parentCornerMultiplier
        layer.cornerCurve = .continuous
        countLabel.font = .systemFont(ofSize: self.bounds.height * Constants.countLabelFontSizeMultiplier, weight: .bold)
        countInfoLabel.font = .systemFont(ofSize: self.bounds.height * Constants.countInfoLabelFontSizeMultiplier, weight: .medium)
    }
}
