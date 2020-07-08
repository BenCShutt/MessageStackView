//
//  MessageStackView.swift
//  MessageStackView
//
//  Created by Ben Shutt on 26/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

/// A `UIStackView` with a `PostManager` for posting, queueing and removing `UIView`s
open class MessageStackView: UIStackView, Poster {
    
    /// `PostManager` to manage posting, queueing, removing of `PostRequest`s
    public private(set) lazy var postManager: PostManager = {
        let postManager = PostManager(poster: self)
        postManager.isSerialQueue = false
        return postManager
    }()
    
    /// Default `MessageConfiguration` to apply to posted `UIView`s
    public var messageConfiguation = MessageConfiguration() {
        didSet {
            guard messageConfiguation.applyToAll else {
                return
            }
            
            // If the `messageConfiguation` has updated, update the current `UIView`s
            arrangedSubviewsExcludingSpace
                .compactMap { $0 as? MessageConfigurable }
                .forEach { $0.set(configuration: messageConfiguation) }
        }
    }
    
    // MARK: - Views
    
    /// This view is for smooth animations when there are no `arrangedSubviews`
    /// in the `UIStackView`.
    /// Otherwise the `UIStackView` can not determine it's width/height.
    /// With "no arranged subviews", we want to fix the width according to it's constraints,
    /// but have 0 height
    public lazy var spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// `NSLayoutConstraint` setting the constant of the height on the `spaceView`
    internal lazy var spaceViewHeightConstraint: NSLayoutConstraint = {
        return spaceView.heightAnchor.constraint(equalToConstant: 0)
    }()
    
    // MARK: - Init
    
    /// Default initializer
    public convenience init() {
        self.init(arrangedSubviews: [])
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0
        
        addSpaceView()
    }
    
    /// Invalidate on deinit
    deinit {
        postManager.invalidate()
    }
    
    // MARK: - ArrangedSubviews
    
    /// Add `spaceView` to the `arrangedSubviews`
    private func addSpaceView() {
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spaceViewHeightConstraint])
        addArrangedSubview(spaceView)
    }
    
    /// `arrangedSubviews` excluding `spaceView`
    public var arrangedSubviewsExcludingSpace: [UIView] {
        return arrangedSubviews.filter { $0 != spaceView }
    }
    
    // MARK: - Hidden
    
    /// Show or hide the given `view`
    ///
    /// - Parameters:
    ///   - view: `UIView` to hide or show
    ///   - hidden: `Bool` Hide or show
    ///   - animated: `Bool` Animate setting `isHidden`
    ///   - completion: Completion block to execute
    private func setView(
        _ view: UIView,
        hidden: Bool,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        guard animated else {
            view.isHidden = hidden
            completion()
            return
        }
        
        view.isHidden = !hidden
        layoutIfNeeded()
        UIView.animate(withDuration: .animationDuration, animations: {
            view.isHidden = hidden
            self.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
}

// MARK: - UIViewPoster

extension MessageStackView: UIViewPoster {
    
    /// Only remove if `self` is the `view.superview`
    /// - Parameter view: `UIView`
    func shouldRemove(view: UIView) -> Bool {
        return view.superview == self
    }
    
    /// Post `view`
    ///
    /// - Note:
    /// This `view` will be added to a `fill` distributed `UIStackView` so it's width will
    /// be determined the `UIStackView`.
    /// However it's height should be determined by the `view` itself.
    /// E.g. intrinsicContentSize, autolayout, explicit height...
    ///
    /// - Parameters:
    ///   - view: `UIView` to post
    ///   - animated: `Bool` should animate post
    ///   - completion: Closure to execute on completion
    func post(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        addArrangedSubview(view)
        if let configurable = view as? MessageConfigurable {
            configurable.set(configuration: messageConfiguation)
        }
        
        setView(view, hidden: false, animated: animated, completion: completion)
    }
    
    /// Remove posted `view`
    ///
    /// - Parameters:
    ///   - view: `UIView` to remove
    ///   - animated: `Bool` should animate remove
    ///   - completion: Closure to execute on completion
    func remove(
        view: UIView,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        setView(view, hidden: true, animated: animated) {
            // Apple docs say the stackView will remove it from its
            // arrangedSubviews list automatically when calling this method
            view.removeFromSuperview()
            
            completion()
        }
    }
}
