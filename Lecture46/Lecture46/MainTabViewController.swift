//
//  ViewController.swift
//  Lecture46
//
//  Created by Nika Kirkitadze on 6/22/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    let bottomMusicBar: BottomMusicBar = {
        let v = BottomMusicBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return v
    }()
    
    var efv: UIVisualEffectView?
    
    override func loadView() {
        super.loadView()
        view.addSubview(bottomMusicBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://gist.github.com/khanlou/6c0997ff781d8110703105948161872d
//         UIFont.familyNames.forEach({ familyName in
//                   let fontNames = UIFont.fontNames(forFamilyName: familyName)
//                   print(familyName, fontNames)
//               })
        
        setupBottomMusicBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupBottomMusicBar() {
        NSLayoutConstraint.activate([
            bottomMusicBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMusicBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomMusicBar.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
            bottomMusicBar.heightAnchor.constraint(equalToConstant: 77.33)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBottomMusicBar))
        bottomMusicBar.addGestureRecognizer(tapGesture)
    }
    
    @objc func onBottomMusicBar() {
        let playerVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        playerVC.modalPresentationStyle = .fullScreen
        self.present(playerVC, animated: true)
    }
}

class BottomMusicBar: UIView {
    
    let musicImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "img-cover"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let stopButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "ic-stop"), for: .normal)
        b.addTarget(self, action: #selector(onStop(_:)), for: .touchUpInside)
        return b
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "014 The Art of Communic... \nThe Futur"
        l.numberOfLines = 0
        
        let attrString = NSMutableAttributedString(string: "014 The Art of Communic...",
                                                   attributes:
            [NSAttributedString.Key.foregroundColor:UIColor.black,
            NSAttributedString.Key.font:UIFont(name: "Poppins-Bold", size: 17)!])
        
        let secondStr = NSAttributedString(string: "\nThe Futur", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black.withAlphaComponent(0.6),
        NSAttributedString.Key.font:UIFont(name: "Poppins-Medium", size: 13)!])
        
        attrString.append(secondStr)
        
        l.attributedText = attrString
        
        return l
    }()
    
    private var efv: UIVisualEffectView!
    private var isPaused = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        efv.frame = bounds
    }
    
    private func setupLayout() {
        let blur = UIBlurEffect(style: .light)
        efv = UIVisualEffectView(effect: blur)
        
        addSubview(efv)
        addSubview(musicImageView)
        addSubview(stopButton)
        addSubview(titleLabel)
        
        configureConstraints()
    }

    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            musicImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            musicImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            musicImageView.widthAnchor.constraint(equalToConstant: 54),
            musicImageView.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            stopButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 32),
            stopButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: musicImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func onStop(_ sender: UIButton) {
        let icon = isPaused ? UIImage(named: "ic-play") : UIImage(named: "ic-stop")
        sender.setImage(icon, for: .normal)
        
        isPaused.toggle()
    }
}
