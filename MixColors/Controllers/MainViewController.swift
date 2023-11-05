//
//  ViewController2.swift
//  MixColors
//
//  Created by VASILY IKONNIKOV on 01.11.2023.
//

import UIKit

class MainViewController: UIViewController {
	
	private var array = [UIColor.redBase, UIColor.blueBase]
	private var selectedCellIndexPath: IndexPath?

	private let mainView = MainView()
	
	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		addSubViews()
		setupConstraints()
		setDelegateAndDatasource()
		setViewColor()
    }
	
	override func viewWillLayoutSubviews() {
		mainView.collectionView.reloadData()
	}
	
	private func presentColorPicker(cellColor: UIColor) {
		let colorPicker = UIColorPickerViewController()
		colorPicker.title = "Select Color"
//		colorPicker.supportsAlpha = false
		colorPicker.delegate = self
		colorPicker.selectedColor = cellColor
		colorPicker.modalPresentationStyle = .popover
//		colorPicker.popoverPresentationController?.sourceItem = self.navigationItem.rightBarButtonItem
//		self.navigationController?.pushViewController(colorPicker, animated: true)
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
	
	private func setViewColor() {
		mainView.viewColor.backgroundColor = blendColors(colors: array)
	}
	
	@objc private func longPressAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
		switch gestureRecognizer.state {
		case .began:
			guard let cell = gestureRecognizer.view as? UICollectionViewCell else { return }
			alertController(cell: cell)
		default:
			break
		}
	}
	
	private func alertController(cell: UICollectionViewCell) {
		let alert = UIAlertController(title: "Delete", message: "Do you want to delete this cell?", preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
			if let indexPath = self.mainView.collectionView.indexPath(for: cell) {
				self.array.remove(at: indexPath.row)
				self.mainView.collectionView.deleteItems(at: [indexPath])
				self.setViewColor()
			}
		}
		alert.addAction(cancelAction)
		alert.addAction(deleteAction)
		present(alert, animated: true)
	}
}

// MARK: - UIColorPickerDelegate
extension MainViewController: UIColorPickerViewControllerDelegate {
	func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
		let selectedColor = viewController.selectedColor
		if let indexPath = selectedCellIndexPath, indexPath.item != array.count {
			let cell = mainView.collectionView.cellForItem(at: indexPath)
			cell?.backgroundColor = selectedColor
			array[indexPath.row] = selectedColor
		}
		setViewColor()
	}
}

// MARK: - UICollectionViewDelegate and Datasource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	private func setDelegateAndDatasource() {
		mainView.collectionView.delegate = self
		mainView.collectionView.dataSource = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return array.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item == array.count {
			return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! NewColorCell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
			let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
			cell.addGestureRecognizer(longPress)
			cell.clipsToBounds = true
			cell.layer.cornerRadius = 5
			cell.layer.borderWidth = 0.5
			cell.layer.borderColor = UIColor.gray.cgColor
			cell.backgroundColor = array[indexPath.row]
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		if indexPath.item != array.count {
			selectedCellIndexPath = indexPath
			presentColorPicker(cellColor: (cell?.backgroundColor)!)
		} else {
			array.append(UIColor.grayBase)
			setViewColor()
			collectionView.reloadData()
			if array.count == 10 && cell is NewColorCell {
				cell?.isHidden = true
			}
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
