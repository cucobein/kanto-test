//
//  KantoLaunchScreenViewController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit
import Lottie

final class KantoLaunchScreenViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var containerView: UIView!
    var animationFinishedHandler: (() -> Void)?

    private let animationView = AnimationView()
    private let animationDuration = TimeInterval(3.0)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.addSubview(animationView)
        animationView.center(to: containerView)
        let containerViewSize = containerView.frame.size
        animationView.setSize(containerViewSize.width, containerViewSize.height)
        animationView.playAnimation(.launch, loopMode: .playOnce)
        _ = Timer.scheduledTimer(timeInterval: animationDuration,
                                 target: self,
                                 selector: #selector(self.completionHandler),
                                 userInfo: nil,
                                 repeats: false)
    }

    @objc
    private func completionHandler() {
        self.animationFinishedHandler?()
    }
}
