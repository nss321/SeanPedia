//
//  MovieDetailViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/12/25.
//
import Foundation

final class MovieDetailViewModel: BaseViewModel {
    
    var selectedMovie: MovieInfo? {
        return output.selectedMovie.value
    }
    
    var castingList: [CastInfo] {
        if let castingList = output.castingList.value {
            return castingList
        }
        return []
    }
    var posterList: [PosterImage] {
        if let posterPaths = output.movieImage.value?.posters {
            return posterPaths
        }
        return []
    }
    
    var isLiked: Bool? {
        return output.isLiked.value
    }
    
    struct Input {
        let selectedMovie: Observable<MovieInfo?> = .init(nil)
        let movieId: Observable<Int?> = .init(nil)
        let isLiked: Observable<Bool?> = .init(nil)
    }
    struct Output {
        let selectedMovie: Observable<MovieInfo?> = .init(nil)
        let movieImage: Observable<Images?> = .init(nil)
        let castingList: Observable<[CastInfo]?> = .init(nil)
        let isLiked: Observable<Bool?> = .init(nil)
    }
    
    let input: Input
    let output: Output
    
    init() {
        input = .init()
        output = .init()
        transform()
        print(#function)
    }
    
    func transform() {
        print(#function)
        input.selectedMovie.lazyBind { [weak self] movie in
            self?.output.selectedMovie.value = movie
            self?.fetchIsLiked()
            self?.input.movieId.value = movie?.id
        }
        input.movieId.lazyBind { [weak self] id in
            if let id {
                self?.callMovieImagesRequest(id: id)
                self?.callCreditRequest(id: id)
            } else {
                print(#function, "failed to unwrapping movie id. image request didn't complete.")
            }
        }
        input.isLiked.lazyBind { [weak self] isLiked in
            self?.output.isLiked.value = isLiked
        }
    }
    
    func makeFilePathList(images: Images) -> [String] {
        var filePaths: [String] = []
        if !images.backdrops.isEmpty {
            for i in (0..<images.backdrops.count) {
                if i == 5 { break }
                filePaths.append(images.backdrops[i].filePath)
            }
        }
        return filePaths
    }
    
    func callMovieImagesRequest(id: Int) {
        NetworkService.shared.callPhotoRequest(api: .images(id: id), type: Images.self) { [weak self] response in
            self?.output.movieImage.value = response
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }
    }
    
    func callCreditRequest(id: Int) {
        NetworkService.shared.callPhotoRequest(api: .credit(id: id), type: Credit.self) { [weak self] Credit in
            self?.output.castingList.value = Credit.cast
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }
    }
    
    func fetchIsLiked() {
        if let id = selectedMovie?.id {
            self.input.isLiked.value = UserDefaultsManager.shared.likedList.contains(id)
        }
    }
    
    func saveLikeState() {
        var likedList = UserDefaultsManager.shared.likedList
        print(UserDefaultsManager.shared.likedList)
        print("위에거는 likedList 초기화")
        
        guard let id = selectedMovie?.id, let isLiked = self.isLiked else {
            print(#function, "failed to unwrapping selected movie id. like state did roll back before tapped this movie.")
            return
        }
        
        let isContains = likedList.contains(id)
        
        if !isContains && !isLiked {
            return
        }
        
        if isContains && isLiked {
            return
        }
        
        // 삽입
        if !isContains && isLiked {
            likedList.append(id)
            UserDefaultsManager.shared.likedList = likedList
            print(UserDefaultsManager.shared.likedList)
//            print("위에거는 추가한 리스트 저장")
            return
        } else {
            // 삭제
            // isContatins && !isLiked
            if let index = likedList.firstIndex(of: id) {
                likedList.remove(at: index)
                UserDefaultsManager.shared.likedList = likedList
//                print("위에거는 삭제한 리스트 저장")
            } else {
                print(#function, "failed to find id in liked list. like remove task did canceled.")
            }
            return
        }
    }
    
    // TODO: 뷰에서 해당 로직 분리
//    func fetchMovieData(movie: MovieInfo) {
//        overview.text = movie.overview.isEmpty ? "요약 정보가 제공되지 않습니다." : movie.overview
//        var genre: [String] = []
//        
//        for i in 0..<movie.genre_ids.count {
//            if i > 1 {
//                break
//            } else {
//                genre.append("\(Genre.genreId(movie.genre_ids[i]))")
//            }
//        }
//        infoLabel.attributedText = configInfoLabel(date: movie.release_date, voteAvg: movie.vote_average, genre: genre)
//    }
}
