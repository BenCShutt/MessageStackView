//
//  ToastViewController.swift
//  Example
//
//  Created by Ben Shutt on 02/06/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
import UIKit
import MessageStackView

class ToastViewController: UIViewController {

    /// `Toast` to post at the bottom of the screen
    private lazy var toast = Toast()

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        toast.addTo(
            view: view,
            layout: .bottom,
            constrainToSafeArea: true
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfterNow(time: .seconds(1)) { [weak self] in
            self?.toast.post(message: "This is a toast!")
        }
    }
}
