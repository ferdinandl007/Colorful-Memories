//
//  ImagesSectionController.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 31/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Alamofire
import IGListKit
import UIKit

class ImagesSectionController: ListSectionController {
    var model: ImageModel!

    var timer: Timer?

    var isProssesing = false

    var completed = 0.0 {
        didSet {
            self.cell.setProgress(completed)
        }
    }

    var cell: imageCell!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func removeCell() {
        guard let vc = viewController as? ViewController else { return }
        for i in 0 ..< vc.data.count {
            if let imageCell = vc.data[i] as? ImageModel {
                if imageCell.uuid == model.uuid {
                    vc.data.remove(at: i)
                    break
                }
            }
        }
        vc.save()
        vc.adapter.performUpdates(animated: true, completion: nil)
    }

    func ShowError(message: String) {
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = UIAlertController.Style.alert
        }

        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: alertStyle)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.removeCell()
        }
        alertController.addAction(action)
        guard let vc = viewController as? ViewController else { return }
        vc.present(alertController, animated: true, completion: nil)
    }
}

extension ImagesSectionController {
    override func numberOfItems() -> Int {
        return 2
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        print(context.containerSize.width)

        var width: CGFloat {
            return context.containerSize.width - 32
        }

        if index == 0 {
            let s = width / model.image.size.width
            let height = s * model.image.size.height
            return CGSize(width: width, height: height)
        }

        return CGSize(width: width, height: 50)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            cell = collectionContext!.dequeueReusableCell(withNibName: imageCell.reuseIdentifier, bundle: Bundle.main, for: self, at: index) as? imageCell

            if model.isColor {
                cell.setImage(image: model.image)
            } else {
                cell.config()
                sendImageToAI()
            }

            return cell!
        }
        let cell = collectionContext!.dequeueReusableCell(withNibName: ActionsCell.reuseIdentifier, bundle: Bundle.main, for: self, at: index) as! ActionsCell

        cell.delicate = self
        return cell
    }

    func sendImageToAI() {
        Networking.shared.prossessImage(image: model.image) { result in
            DispatchQueue.main.async {
                self.cell.setProgress(result.progress)
                if let error = result.error {
                    self.ShowError(message: error)
                }
                if let newImage = result.image {
                    self.cell.setImage(image: newImage)
                    self.model.image = newImage
                    self.model.isColor = true
                    guard let vc = self.viewController as? ViewController else { return }
                    vc.save()
                    let credets = UserDefaults.standard.integer(forKey: "credets") - 1
                    UserDefaults.standard.set(credets, forKey: "credets")
                }
            }
        }
    }

    override func didSelectItem(at _: Int) {}

    override func didUpdate(to object: Any) {
        model = object as? ImageModel
    }
}

extension ImagesSectionController: ActionsCellDelicate {
    func save() {
        UIImageWriteToSavedPhotosAlbum(model.image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func share() {
        let imageShare = [model.image]
        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController!.view
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = cell.image
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        viewController?.present(activityViewController, animated: true, completion: nil)
    }

    func trash() {
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = UIAlertController.Style.alert
        }

        let ac = UIAlertController(title: "You wish to delete?", message: nil, preferredStyle: alertStyle)
        let yes = UIAlertAction(title: "Yes!", style: .default) { _ in
            self.removeCell()
        }
        ac.addAction(UIAlertAction(title: "No", style: .default))
        ac.addAction(yes)
        viewController?.present(ac, animated: true)
    }

    @objc func image(_: UIImage, didFinishSavingWithError error: Error?, contextInfo _: UnsafeRawPointer) {
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = UIAlertController.Style.alert
        }

        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: alertStyle)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(ac, animated: true)
        }
    }
}
