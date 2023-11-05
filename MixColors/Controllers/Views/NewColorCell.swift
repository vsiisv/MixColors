//
//  NewColorCell.swift
//  MixColors
//
//  Created by VASILY IKONNIKOV on 05.11.2023.
//

import UIKit

class NewColorCell: UICollectionViewCell {
	
	private let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
		addSubview(imageView)
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Style and Layout
private extension NewColorCell {
	func configure() {
		imageView.image = UIImage.init(systemName: "plus")
		imageView.tintColor = .gray
		backgroundColor = .superLightGray
		clipsToBounds = true
		layer.cornerRadius = 5
	}
	
	func setupConstraints() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
//			imageView.topAnchor.constraint(equalTo: topAnchor),
//			imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
//			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//			imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.heightAnchor.constraint(equalToConstant: 50),
			imageView.widthAnchor.constraint(equalToConstant: 50)
		])
	}
	
}
