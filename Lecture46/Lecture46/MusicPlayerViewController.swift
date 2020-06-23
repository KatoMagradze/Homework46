//
//  MusicPlayerViewController.swift
//  Lecture46
//
//  Created by Nika Kirkitadze on 6/22/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        cofngurePanGesture()
        setupPlayer()
    }
    
    private func setupPlayer() {
        let url = Bundle.main.url(forResource: "audio.mp3", withExtension: nil)!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                self.progressView.setProgress(Float(self.audioPlayer!.currentTime/self.audioPlayer!.duration), animated: true)
            }
            
        } catch let err {print(err.localizedDescription)}
    }

    private func cofngurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        let translateY = gesture.translation(in: gesture.view!).y
        
        switch  gesture.state {
        case .began:
            break
        case .changed:
            gesture.view!.transform = CGAffineTransform(translationX: 0, y: translateY)
            
        case .ended:
            if translateY > 200 {
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    gesture.view!.transform = .identity
                }
            }
        default:
            print("")
        }
    }
}
