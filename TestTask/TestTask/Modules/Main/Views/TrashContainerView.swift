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
    
    //MARK: - Views
    
    private let countLabel = LabelBuilder()
        .setText("0")
        .build()
    
    private let countInfoLabel = LabelBuilder()
        .setText("""
                    images in
                    the trash
                 """)
        .setNumbersLines(2)
        .build()
    
    private lazy var emptyTrashButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Empty Trash"
        configuration.image = Images.emptyTrashImage.setImage()
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
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
#warning("logic")
        if let count = dataSource.countOfImages(self) {
            emptyTrashButton.isEnabled = count != .zero
            
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
            make.leading.equalToSuperview().inset(20)
            
        }
        
        countInfoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(countLabel.snp.trailing).inset(-10)
        }
        
        emptyTrashButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(12)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    override func setupSizes() {
        layer.cornerRadius = self.bounds.height * 0.33
        layer.cornerCurve = .continuous
        countLabel.font = .systemFont(ofSize: self.bounds.height * 0.36, weight: .bold)
        countInfoLabel.font = .systemFont(ofSize: self.bounds.height * 0.194, weight: .medium)
    }
}
