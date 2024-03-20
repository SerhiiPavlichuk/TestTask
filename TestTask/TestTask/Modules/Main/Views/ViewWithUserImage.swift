//
//  ViewWithUserImage.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit
import SnapKit

protocol ViewWithUserImageDataSource: AnyObject {
    func imageFromLibrary(_ view: ViewWithUserImage) -> UIImage?
}

protocol ViewWithUserImageDelegate: AnyObject {
    func deletePressed()
    func savePressed()
}

final class ViewWithUserImage: CustomView {
    
    //MARK: - Constants
    
    private enum Constants {
        static let buttonHeightMultiplier = 0.096
        static let buttonBottomInset = 16
        static let buttonLeadingtrailingInset = 60
        static let parentCornerMultiplier = 0.038
    }
    
    //MARK: - Views

    let userImageView = UIImageView()
    
    private lazy var deleteButton: CircleButton = {
        let deleteButton = CircleButton(type: .delete)
        deleteButton.addAction(UIAction { [weak self] _ in self?.deleteButtonPressed()}, for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var saveButton: CircleButton = {
        let saveButton = CircleButton(type: .save)
        saveButton.addAction(UIAction { [weak self] _ in self?.saveButtonPressed()}, for: .touchUpInside)
        return saveButton
    }()
    
    //MARK: - Init
    
    weak var dataSource: ViewWithUserImageDataSource?
    weak var delegate: ViewWithUserImageDelegate?
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    override func setupUI() {
        backgroundColor = .clear
        clipsToBounds = true
        
        userImageView.contentMode = .scaleAspectFill
        
        addSubviews(
            userImageView,
            deleteButton,
            saveButton
        )
    }
    
    @MainActor
    func reloadData() async {
        configureUI()
    }
    
    private func configureUI() {
        guard let dataSource else { return }
        userImageView.image = dataSource.imageFromLibrary(self)
    }
    
    private func deleteButtonPressed() {
        delegate?.deletePressed()
    }
    
    private func saveButtonPressed() {
        delegate?.savePressed()
    }
    
    //MARK: - Layout
    
    override func setupLayout() {
        userImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(Constants.buttonHeightMultiplier)
            make.width.equalTo(deleteButton.snp.height)
            make.bottom.equalToSuperview().inset(Constants.buttonBottomInset)
            make.leading.equalToSuperview().inset(Constants.buttonLeadingtrailingInset)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(Constants.buttonHeightMultiplier)
            make.width.equalTo(deleteButton.snp.height)
            make.bottom.equalToSuperview().inset(Constants.buttonBottomInset)
            make.trailing.equalToSuperview().inset(Constants.buttonLeadingtrailingInset)
        }
    }
    
    override func setupSizes() {
        layer.cornerRadius = self.bounds.height * Constants.parentCornerMultiplier
        layer.cornerCurve = .continuous
        
    }
}
