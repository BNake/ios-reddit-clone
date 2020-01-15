//
//  PostsViewModel.swift
//  RedditClone
//
//  Created by Atiyeh, Brian (B.) on 9/10/19.
//  Copyright © 2019 Brian Atiyeh. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol PostViewable {
    var posts: BehaviorRelay<[Post]> { get }
    func fetchPosts(subreddit: String?)
}

class PostsViewModel: PostViewable {
    public var posts = BehaviorRelay<[Post]>(value: [])
    let postsService: PostsServicable
    let disposeBag = DisposeBag()
    
    init(postsService: PostsServicable) {
        self.postsService = postsService
    }
    
    public convenience init() {
        self.init(postsService: PostsService())
    }
    
    public func fetchPosts(subreddit: String?) {
        postsService.getPosts(subreddit: subreddit).subscribe(onNext: { [weak self] (response) in
            self?.posts.accept(response.posts)
        }, onError: { (error) in
            print("error!")
        }).disposed(by: disposeBag)
    }
    
    private func setPosts(response: RedditResponse) {
        posts.accept(response.posts)
    }
}
