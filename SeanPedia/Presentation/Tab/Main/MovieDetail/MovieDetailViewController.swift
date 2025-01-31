//
//  MovieDetailViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    
    let movieDetailView = MovieDetailView()
    var test = "" {
        didSet {
            self.navigationItem.title = test
        }
    }
    
    var selectedMovie: MovieInfo?
    
    override func loadView() {
        view = movieDetailView
    }
    
    override func configHierarchy() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        print(#function)
        
        guard let selectedMovie else {
            print(#function, "selected movie nil")
            return
        }
        movieDetailView.fetchMovieData(movie: selectedMovie)
        NetworkService.shared.callPhotoRequest(api: .images(id: selectedMovie.id), type: Images.self) { Images in
            let filePaths = Images.backdrops[0..<5]
            self.movieDetailView.configPages(data: filePaths.map { $0.file_path })
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }


        
//        movieDetailView.configPages(data: selectedMovie.)
    }
    
    override func configDelegate() {
        movieDetailView.backDropHorizontalScrollView.delegate = self
    }
    
    override func configNavigation() {
        navigationItem.title = selectedMovie?.title ?? ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }),
            menu: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            primaryAction: UIAction(handler: { _ in
                self.dismiss(animated: true) {
                    print("좋아요 💝")
                }
            }),
            menu: nil)
    }
    
    func fetchImages() {
        var backdrops: [UIImageView]
        var posters: [UIImageView]
//        NetworkService.shared.callPhotoRequest(api: ., type: <#T##Decodable.Type#>) { <#Decodable#> in
//            <#code#>
//        } failureHandler: { <#TMDBError#> in
//            <#code#>
//        }

    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        movieDetailView.backDropPageControl.currentPage = Int(pageIndex)
    }
}
