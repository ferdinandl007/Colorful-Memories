//
//  ViewController.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import IGListKit
import SPPermissions
import UIKit

class ViewController: UIViewController {
    var data = [ListDiffable]()

    var currentInteraction = Int()
    @IBOutlet var OverlayView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        collectionView.scrollsToTop = true
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 14, bottom: 50, right: 14)

        data.append(HeaderModel() as ListDiffable)
        if let userData = UserDefaults.standard.array(forKey: "userData") as? [Data] {
            data += userData.map { ImageModel(image: UIImage(data: $0, scale: 1) ?? UIImage(), isColor: true) as ListDiffable }
        }

        adapter.performUpdates(animated: true)

        // Do any additional setup after loading the view.
        IAPManager.shared.getProducts { result in
            switch result {
            case let .success(products): IAPManager.shared.products = products
                IAPManager.shared.products.sort { $0.localizedTitle.parseToInt() ?? 0 < $1.localizedTitle.parseToInt() ?? 0 }
            case let .failure(error): print(error)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestPermissions()
    }

    func requestPermissions() {
        if UserDefaults.standard.bool(forKey: "Permissions") { return }
        let permissions: [SPPermission] = [.notification, .camera, .photoLibrary]
        let controller = SPPermissions.dialog(permissions)
        controller.present(on: self)
        UserDefaults.standard.set(true, forKey: "Permissions")
    }

    func askForPermissions(permission: SPPermission) -> Bool {
        let permissions: [SPPermission] = [.camera, .photoLibrary].filter { !$0.isAuthorized && $0 == permission }
        if permissions.isEmpty { return false }
        let controller = SPPermissions.dialog(permissions)
        controller.present(on: self)
        return true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        adapter.reloadData(completion: nil)
    }

    func save() {
        let userData: [Data] = data.filter { $0 is ImageModel }.map {
            ($0 as! ImageModel).image.jpegData(compressionQuality: 1.0)!
        }
        UserDefaults.standard.set(userData, forKey: "userData")
    }

    func willStartLongProcess() {
        OverlayView.isHidden = false
    }

    func didFinishLongProcess() {
        OverlayView.isHidden = true
    }
}

extension ViewController: ListAdapterDataSource {
    func objects(for _: ListAdapter) -> [ListDiffable] {
        return data
    }

    func listAdapter(_: ListAdapter, sectionControllerFor object: Any) ->
        ListSectionController {
        if object is HeaderModel {
            return HedarSectionController()
        } else if object is ImageModel {
            return ImagesSectionController()
        }
        return ListSectionController()
    }

    func emptyView(for _: ListAdapter) -> UIView? {
        return nil
    }
}
