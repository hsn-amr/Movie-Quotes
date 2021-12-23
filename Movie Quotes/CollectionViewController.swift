//
//  ViewController.swift
//  Movie Quotes
//
//  Created by administrator on 23/12/2021.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    let mainUrl = "https://api.tvmaze.com/search/shows?q=cars"
    
    var shows = [Show]()
    let columnLayout = ColumnFlowLayout(
           cellsPerRow: 3,
           minimumInteritemSpacing: 10,
           minimumLineSpacing: 10,
           sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       )

       override func viewDidLoad() {
           super.viewDidLoad()
           
           requestApi(url: mainUrl)
           collectionView.collectionViewLayout = columnLayout
           collectionView.contentInsetAdjustmentBehavior = .always
           collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "keywordCell")
           
       }
    
    func requestApi(url: String){
        let url = URL(string: url)
        let session = URLSession.shared
        
        session.dataTask(with: url!, completionHandler: {
            data, respons, error in
            
            guard let myData = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([WelcomeElement].self, from: myData)
                for r in result{
                    self.shows.append(r.show)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("API Request Error")
            }
        }).resume()
    }
    
    func requestImage(url: String,completion: @escaping (Result<UIImage, Error>)->()) {
        
        let url = URL(string: url)
        let session = URLSession.shared
        
        session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }else{
                guard let myData = data else {return}
                
                completion(.success(UIImage(data: myData)!))
            }
            
        }).resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        let show = shows[indexPath.row]
        cell.movieLabel.text = show.name
        requestImage(url: show.image.medium, completion: {
            result in
            switch result{
            case let .success(image):
                DispatchQueue.main.async {
                    cell.movieImageView.image = image
                }
            default:
                    print("image error")
            }
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let summaryView = storyboard?.instantiateViewController(withIdentifier: "Summary") as! SummaryViewController
        summaryView.summary = shows[indexPath.row].summary
        navigationController?.present(summaryView, animated: true, completion: nil)
    }


}

