//
//  ViewController2.swift
//  MixColors
//
//  Created by VASILY IKONNIKOV on 01.11.2023.
//

import UIKit

class MainViewController: UIViewController {
	
	private var colors = [UIColor.redBase, UIColor.blueBase]
	private var selectedCellIndexPath: IndexPath?
	
	private let mainView = MainView()
	
	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		addSubViews()
		setupConstraints()
		setDelegateAndDatasource()
		updateViewColor()
    }
	
	override func viewWillLayoutSubviews() {
		mainView.collectionView.reloadData()
	}
	
	private func presentColorPicker(indexPath: IndexPath) {
		let colorPicker = UIColorPickerViewController()
		colorPicker.title = "Select Color"
		colorPicker.delegate = self
		colorPicker.selectedColor = colors[indexPath.row]
		colorPicker.modalPresentationStyle = .popover
		self.present(colorPicker, animated: true)
	}
	
	private func blendColors(colors: [UIColor]) -> UIColor? {
		var blendedRed: CGFloat = 0
		var blendedGreen: CGFloat = 0
		var blendedBlue: CGFloat = 0
		var blendedAlpha: CGFloat = 0
		
		for color in colors {
			guard let components = color.cgColor.components else {
				return nil
			}
			
			blendedRed += components[0]
			blendedGreen += components[1]
			blendedBlue += components[2]
			blendedAlpha += components[3]
		}
		
		let count = CGFloat(colors.count)
		blendedRed /= count
		blendedGreen /= count
		blendedBlue /= count
		blendedAlpha /= count
		
		return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
	}
	
	private func updateViewColor() {
		mainView.viewColor.backgroundColor = blendColors(colors: colors)
	}
	
	@objc private func longPressAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
		switch gestureRecognizer.state {
		case .began:
			guard let cell = gestureRecognizer.view as? UICollectionViewCell,
				  let indexPath = mainView.collectionView.indexPath(for: cell) else { return }
			showAlertController(with: indexPath)
		default:
			break
		}
	}
	
	private func showAlertController(with indexPath: IndexPath) {
		let alert = UIAlertController(title: "", message: "Do you want to delete this color?", preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
			self.removeColor(with: indexPath)
		}
		alert.addAction(cancelAction)
		alert.addAction(deleteAction)
		present(alert, animated: true)
	}
	
	private func removeColor(with indexPath: IndexPath) {
		guard indexPath.item < colors.count else { return }
		
		colors.remove(at: indexPath.row)
		
		if colors.count < 10, let lastCell = mainView.collectionView.cellForItem(at: IndexPath(item: colors.count, section: 0)) as? NewColorCell {
			lastCell.isHidden = false
		}
		
		mainView.collectionView.reloadData()
		updateViewColor()
	}
}

// MARK: - UIColorPickerDelegate
extension MainViewController: UIColorPickerViewControllerDelegate {
	func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
		if let indexPath = selectedCellIndexPath, indexPath.item < colors.count {
			let cell = mainView.collectionView.cellForItem(at: indexPath)
			cell?.backgroundColor = color
			colors[indexPath.row] = color
		}
		updateViewColor()
	}
}

// MARK: - UICollectionViewDelegate and Datasource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	private func setDelegateAndDatasource() {
		mainView.collectionView.delegate = self
		mainView.collectionView.dataSource = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return min(colors.count + 1, 10)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item == colors.count {
			return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! NewColorCell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
			configureColorCell(cell, for: indexPath)
			return cell
		}
	}
	
	// MARK: Configure Cell
	private func configureColorCell(_ cell: UICollectionViewCell, for indexPath: IndexPath) {
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
		cell.addGestureRecognizer(longPress)
		cell.clipsToBounds = true
		cell.layer.cornerRadius = 5
		cell.layer.borderWidth = 0.5
		cell.layer.borderColor = UIColor.gray.cgColor
		cell.backgroundColor = colors[indexPath.row]
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let isLastCell = indexPath.item == colors.count
		
		if isLastCell {
			addNewColor()
		} else {
			selectedCellIndexPath = indexPath
			presentColorPicker(indexPath: indexPath)
		}
	}
	
	// MARK: Add new color
	private func addNewColor() {
		colors.append(UIColor.grayBase)
		updateViewColor()
		mainView.collectionView.reloadData()
		
		if colors.count == 10, let lastCell = mainView.collectionView.cellForItem(at: IndexPath(item: colors.count, section: 0)) as? NewColorCell {
			lastCell.isHidden = true
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let sizeW = collectionView.frame.width / 6
		let sizeH = collectionView.frame.height / 3
		return CGSize(width: sizeW, height: sizeH)
	}
}

// MARK: - Style and Layout
private extension MainViewController {
	
	func setupView() {
		view.backgroundColor = .white
	}
	
	func addSubViews() {
		view.addSubview(mainView)
	}
	
	func setupConstraints() {
		mainView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
			mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
		])
	}
}
