////
////  DraggableButton.swift
////  sample_application2
////
////  Created by Fauzan Akmal Mahdi on 26/05/25.
////
//
//import Foundation
//import UIKit
//
//public class DraggableButton: UIButton {
//    private var initialCenter: CGPoint = .zero
//
//    public override init(frame: CGRect) {
//        super.init(frame: CGRect(x: 100, y: 300, width: 60, height: 60))
//        configure()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        configure()
//    }
//
//    private func configure() {
//        self.backgroundColor = .systemBlue
//        self.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
//        self.layer.cornerRadius = 30
//        self.clipsToBounds = true
//
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
//        self.addGestureRecognizer(pan)
//    }
//
//    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
//        guard let view = gesture.view else { return }
//        let translation = gesture.translation(in: view.superview)
//        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
//        gesture.setTranslation(.zero, in: view.superview)
//    }
//}
