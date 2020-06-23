//
//  ExploreViewController.swift
//  Lecture46
//
//  Created by Kato on 6/23/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    let apiservice = APIServices()
   
    var topArtists : TopArtists?
    var topArtistArray = [Artist]()
    //var imagesArray = [Image]()
    
    @IBOutlet weak var topArtistsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topArtistsCollectionView.delegate = self
        topArtistsCollectionView.dataSource = self
        
        apiservice.fetchArtists { (topArtists) in
 
            for topArtist in topArtists.artists.artist {
                self.topArtistArray.append(topArtist)
            }
            
            DispatchQueue.main.async {
                self.topArtistsCollectionView.reloadData()
            }
            print(self.topArtistArray)
        }
        
    }
    
}
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topArtistArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_artists_cell", for: indexPath) as! TopArtistsCell
        
        var imagesURL = ""
        
        for img in topArtistArray[indexPath.row].image {
            if img.size == Size.medium {
                imagesURL = img.text
                break
            }
        }
        
        imagesURL.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.topArtistImageView.image = image
            }
        }
        
        return cell
    }
    
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width / 2
        
        return CGSize(width: itemWidth - 20 - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension String {
    
    func downloadImage(completion: @escaping (UIImage?) -> ()) {

        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
    
}
