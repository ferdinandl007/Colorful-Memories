//
//  HedarSectionController.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Alamofire
import Haptica
import IGListKit
import PixelEditor
import PokerCard
import StoreKit
import UIKit
import WeScan
import YPImagePicker

class HedarSectionController: ListSectionController {
    var model: HeaderModel!
    let processingQueue = DispatchQueue(label: "store")

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = 22
        minimumInteritemSpacing = 22
    }

    func showAlert(for products: [SKProduct]) {
        guard let message = products.first?.localizedDescription else { return }
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = UIAlertController.Style.alert
        }

        let alertController = UIAlertController(title: "Buy now",
                                                message: message + ". One credit equals one processed image",
                                                preferredStyle: alertStyle)
        for product in products {
            guard let price = IAPManager.shared.getPriceFormatted(for: product) else { return }
            alertController.addAction(UIAlertAction(title: "\(product.localizedTitle) for \(price)", style: .default, handler: { _ in
                if !self.purchase(product: product) {
                    self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
                }

            }))
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
    }

    func showSingleAlert(withMessage message: String) {
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = UIAlertController.Style.alert
        }
        let alertController = UIAlertController(title: "Colorful Memories", message: message, preferredStyle: alertStyle)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
    }

    func purchase(product: SKProduct) -> Bool {
        guard let vc = viewController as? ViewController else { return false }
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            vc.willStartLongProcess()
            IAPManager.shared.buy(product: product) { result in
                vc.didFinishLongProcess()
                DispatchQueue.main.async {
                    switch result {
                    case .success: self.updateAppDataWithPurchasedProduct(product)
                    case let .failure(error): self.ShowError(message: error.localizedDescription)
                    }
                }
            }
            return true
        }
    }

    func updateAppDataWithPurchasedProduct(_ product: SKProduct) {
        let credets = UserDefaults.standard.integer(forKey: "credets")
        if let newCredets = product.localizedTitle.parseToInt() {
            UserDefaults.standard.set(credets + newCredets, forKey: "credets")
        }
        guard let vc = viewController as? ViewController else { return }
        vc.adapter.reloadData(completion: nil)
    }

    func ShowError(message: String) {
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = UIAlertController.Style.alert
        }

        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: alertStyle)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
        }
        alertController.addAction(action)
        guard let vc = viewController as? ViewController else { return }
        vc.present(alertController, animated: true, completion: nil)
    }
}

extension HedarSectionController {
    override func numberOfItems() -> Int {
        return 3
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }

        if index != 0 {
            return CGSize(width: (context.containerSize.width - 51) / 2, height: 88)
        }

        return CGSize(width: context.containerSize.width - 32, height: 88)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            let hedarCell = collectionContext!.dequeueReusableCell(withNibName: HeaderCell.reuseIdentifier, bundle: Bundle.main, for: self, at: index) as! HeaderCell
            hedarCell.config()
            return hedarCell
        } else if index == 1 {
            let cell = collectionContext!.dequeueReusableCell(withNibName: itemCell.reuseIdentifier, bundle: Bundle.main, for: self, at: index) as! itemCell
            if #available(iOS 13.0, *) {
                cell.config(image: UIImage(systemName: "camera.on.rectangle.fill")!, label: "Library")
            } else {
                // Fallback on earlier versions
                cell.config(image: #imageLiteral(resourceName: "yp_multiple"), label: "Library")
            }
            return cell
        }

        let cell = collectionContext!.dequeueReusableCell(withNibName: itemCell.reuseIdentifier, bundle: Bundle.main, for: self, at: index) as! itemCell

        if #available(iOS 13.0, *) {
            cell.config(image: UIImage(systemName: "camera.viewfinder")!, label: "Scan Image")
        } else {
            // Fallback on earlier versions
            cell.config(image: #imageLiteral(resourceName: "yp_multiple"), label: "Scan Image")
        }

        return cell
    }

    override func didSelectItem(at index: Int) {
        Haptic.impact(.light).generate()
        let credets = UserDefaults.standard.integer(forKey: "credets")
        if index == 1 {
            if credets > 0 {
                var config = YPImagePickerConfiguration()
                config.shouldSaveNewPicturesToAlbum = false
//                config.showsPhotoFilters = false
                config.startOnScreen = YPPickerScreen.library
                config.screens = [.library]
                let picker = YPImagePicker(configuration: config)
                picker.didFinishPicking { [unowned picker] items, _ in
                    if let photo = items.singlePhoto {
                        guard let vc = self.viewController as? ViewController else { return }
                        let image = ImageModel(image: photo.image, isColor: false)
                        vc.data.insert(image as ListDiffable, at: 1)
                        vc.adapter.performUpdates(animated: true, completion: nil)
                        print(vc.data)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                viewController?.present(picker, animated: true, completion: nil)
            } else {
                ShowError(message: "Out of credits please purchase more credits")
            }

        } else if index == 2 {
            if credets > 0 {
                let scannerViewController = ImageScannerController()
                guard let vc = viewController as? ViewController else { return }
                scannerViewController.imageScannerDelegate = vc
                viewController?.present(scannerViewController, animated: true)
            } else {
                ShowError(message: "Out of credits please purchase more credits")
            }
        } else {
            print("buy more!")
            showAlert(for: IAPManager.shared.products)
        }
    }

    override func didUpdate(to object: Any) {
        model = object as? HeaderModel
    }
}

extension ViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        scanner.dismiss(animated: true)
        print(error)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        let scanimage = results.croppedScan.image
        let image = ImageModel(image: scanimage, isColor: false)
        data.insert(image as ListDiffable, at: 1)
        adapter.performUpdates(animated: true, completion: nil)
        scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
}
