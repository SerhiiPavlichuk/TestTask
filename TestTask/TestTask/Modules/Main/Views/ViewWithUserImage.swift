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

final class ViewWithUserImage: UIView {
    
    //MARK: - Views

    private let userImageView = UIImageView()
    
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
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    
    //MARK: - Methods
    
    private func setupUI() {
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
        
        if let image = dataSource.imageFromLibrary(self) {
            userImageView.image = image
        } else {
            
        }
    }
    
    private func deleteButtonPressed() {
        delegate?.deletePressed()
    }
    
    private func saveButtonPressed() {
        delegate?.savepresed()
    }
    
    private func setupLayout() {
        layer.cornerRadius = self.bounds.height * 0.038
        layer.cornerCurve = .continuous
        
        userImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.096)
            make.width.equalTo(deleteButton.snp.height)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(60)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.096)
            make.width.equalTo(deleteButton.snp.height)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(60)
        }
    }
}
