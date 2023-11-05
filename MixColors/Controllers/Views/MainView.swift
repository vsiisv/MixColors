//
//  MainView.swift
//  MixColors
//
//  Created by VASILY IKONNIKOV on 01.11.2023.
//

import UIKit

final class MainView: UIView {
	private let layout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		return layout
	}()
	
	lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		return collectionView
	}()
	
	private lazy var viewColor: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 10
		view.backgroundColor = .cyan
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubviews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Style and Layout
private extension MainView {
	func addSubviews() {
		addSubview(viewColor)
		addSubview(collectionView)
	}
	
	func setupConstraints() {
		viewColor.translatesAutoresizingMaskIntoConstraints = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			viewColor.topAnchor.constraint(equalTo: topAnchor),
			viewColor.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			viewColor.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			viewColor.heightAnchor.constraint(equalToConstant: 128),
			
			collectionView.topAnchor.constraint(equalTo: viewColor.bottomAnchor),
			collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
			collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
