//
//  MovieDetailViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    
    private let movieDetailView = MovieDetailView()
    private var group = DispatchGroup()
    var selectedMovie: MovieInfo?
    private var castingList: [CastInfo] = []
    private var posterList: [PosterImage] = []
    
    override func loadView() {
        view = movieDetailView
    }
    
    override func configView() {
        print(#function)
        
        guard let selectedMovie else {
            print(#function, "selected movie nil")
            return
        }
        movieDetailView.fetchMovieData(movie: selectedMovie)
        
        group.enter()
        NetworkService.shared.callPhotoRequest(api: .images(id: selectedMovie.id), type: Images.self) { Images in
            let filePaths = Images.backdrops[0..<5]
            self.movieDetailView.configPages(data: filePaths.map { $0.file_path })
            self.posterList = Images.posters
            self.group.leave()
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }

        group.enter()
        NetworkService.shared.callPhotoRequest(api: .credit(id: selectedMovie.id), type: Credit.self) { Credit in
            self.castingList = Credit.cast
            self.group.leave()
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }

        group.notify(queue: .main) {
            self.movieDetailView.castCollectionView.reloadData()
            self.movieDetailView.posterCollectionView.reloadData()
        }
        
    }
    
    override func configDelegate() {
        movieDetailView.backDropHorizontalScrollView.delegate = self
        movieDetailView.castCollectionView.delegate = self
        movieDetailView.castCollectionView.dataSource = self
        movieDetailView.posterCollectionView.dataSource = self
        movieDetailView.posterCollectionView.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
}

extension MovieDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case movieDetailView.backDropHorizontalScrollView:
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            movieDetailView.backDropPageControl.currentPage = Int(pageIndex)
            break
        default:
            break
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case movieDetailView.castCollectionView:
            return castingList.count
        case movieDetailView.posterCollectionView:
            return posterList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        switch collectionView {
        case movieDetailView.castCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell
            cell.config(item: castingList[item])
            return cell
            
        case movieDetailView.posterCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell
            cell.config(item: posterList[item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case movieDetailView.castCollectionView:
            return CGSize(width: screenWidth / 2.5, height: 40)
        case movieDetailView.posterCollectionView:
            return CGSize(width: screenWidth / 3.5, height: screenHeight * 0.2 )
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
}
