//
//  DTPagerController.swift
//  Pods
//
//  Created by tungvoduc on 15/09/2017.
//
//

import UIKit

/// PagerViewControllerDelegate
@objc public protocol DTPagerControllerDelegate: NSObjectProtocol {
    @objc optional func pagerController(_ pagerController: DTPagerController, didChangeSelectedPageIndex index: Int)
    @objc optional func pagerController(_ pagerController: DTPagerController, willChangeSelectedPageIndex index: Int, fromPageIndex oldIndex: Int)
    @objc optional func pagerController(_ pagerController: DTPagerController, pageScrollViewDidScroll: UIScrollView)
}

/// DTPagerController
/// Used to create a pager controller of multiple view controllers.
open class DTPagerController: UIViewController, UIScrollViewDelegate {

    /// scrollIndicator below the segmented control bar.
    /// Default background color is blue.
    open fileprivate(set) lazy var scrollIndicator: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.blue
        return bar
    }()

    /// Delegate
    @objc open weak var delegate: DTPagerControllerDelegate?

    /// Preferred height of segmented control bar.
    /// Default value is 44.
    /// If viewControllers has less than 2 items, actual height is 0.
    open var preferredSegmentedControlHeight: CGFloat = 44 {
        didSet {
            view.setNeedsLayout()
        }
    }

    /// Height of segmented control bar
    /// Get only
    open var segmentedControlHeight: CGFloat {
        return viewControllers.count <= 1 ? 0 : preferredSegmentedControlHeight
    }

    /// Preferred of scroll indicator.
    /// Default value is 2.
    /// If viewControllers has less than 2 items, actual height is 0.
    open var perferredScrollIndicatorHeight: CGFloat = 2 {
        didSet {
            // Update height and vertical position
            scrollIndicator.bounds.size.height = scrollIndicatorHeight
            scrollIndicator.frame.origin.y = segmentedControlHeight - scrollIndicatorHeight
        }
    }

    /// Height of segmented indicator
    /// Get only
    open var scrollIndicatorHeight: CGFloat {
        return viewControllers.count <= 1 ? 0 : perferredScrollIndicatorHeight
    }

    var previousPageIndex: Int = 0

    /// Automatically handle child view controllers' appearance transitions when switching between tabs
    /// If you don't want viewWillAppear/viewDidAppear/viewWillDisappear/viewDidDisappear of child view
    /// controllers to be called when switching tabs, this should be set to false.
    /// Default value is true
    open var automaticallyHandleAppearanceTransitions: Bool = true

    /// View controllers in Pager View Controller
    /// Get only.
    open var viewControllers: [UIViewController] {
        didSet {
            removeChildViewControllers(oldValue)
            setUpViewControllers()
        }
    }

    /// Current index of pager
    /// Setting selectedPageIndex before viewDidLoad is called will not have any effect.
    /// Update selectedPageIndex will perform animation.
    /// If you want to change page index without performing animation, use method setSelectedPageIndex(_: Int, animated: Bool).
    /// - seealso: setSelectedPageIndex(_: Int, animated: Bool)
    open var selectedPageIndex: Int {
        set {
            pageSegmentedControl.selectedSegmentIndex = newValue

            if newValue != previousPageIndex {
                pageSegmentedControl.sendActions(for: UIControl.Event.valueChanged)
            }
        }

        get {
            //pageSegmentedControl.selectedSegmentIndex can sometimes return -1, so return 0 instead
            return pageSegmentedControl.selectedSegmentIndex < 0 ? 0 : pageSegmentedControl.selectedSegmentIndex
        }
    }

    /// Normal text color in segmented control bar
    /// Default value is UIColor.lightGray
    public var textColor: UIColor = UIColor.lightGray {
        didSet {
            if viewIfLoaded != nil {
                updateSegmentedNormalTitleTextAttributes()
            }
        }
    }

    /// Selected text color in segmented control bar
    /// Default value is UIColor.black
    public var selectedTextColor: UIColor = UIColor.blue {
        didSet {
            if viewIfLoaded != nil {
                updateSegmentedSelectedTitleTextAttributes()
            }
        }
    }

    /// Normal text color in segmented control bar
    /// Default value is UIColor.lightGray
    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            if viewIfLoaded != nil {
                updateSegmentedNormalTitleTextAttributes()
            }
        }
    }

    /// Selected text color in segmented control bar
    /// Default value is UIColor.black
    public var selectedFont: UIFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            if viewIfLoaded != nil {
                updateSegmentedSelectedTitleTextAttributes()
            }
        }
    }

    /// Page segmented control
    open var pageSegmentedControl: UIControl & DTSegmentedControlProtocol

    /// Page scroll view
    /// This should not be exposed. Changing behavior of pageScrollView will destroy functionality of DTPagerController
    public private(set) lazy var pageScrollView: UIScrollView = {
        let pageScrollView = UIScrollView()
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.isPagingEnabled = true
        pageScrollView.scrollsToTop = false
        return pageScrollView
    }()

    /// Initializer
    /// - parameters:
    ///     - viewControllers: array of child view controllers displayed in pager controller.
    public init(viewControllers controllers: [UIViewController]) {

        pageSegmentedControl = DTSegmentedControl(items: [])
        viewControllers = controllers

        super.init(nibName: nil, bundle: nil)
    }

    /// Initializer
    /// - parameters:
    ///     - viewControllers: array of child view controllers displayed in pager controller.
    ///     - pageSegmentedControl: segmented control used in pager controller.
    public init(viewControllers controllers: [UIViewController], pageSegmentedControl segmentedControl: UIControl & DTSegmentedControlProtocol) {

        pageSegmentedControl = segmentedControl
        viewControllers = controllers

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        viewControllers = []
        pageSegmentedControl = DTSegmentedControl(items: [])

        super.init(coder: aDecoder)
    }

    deinit {
        unobserveScrollViewDelegate(pageScrollView)
    }

    override open func loadView() {
        super.loadView()
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        pageScrollView.delegate = self
        observeScrollViewDelegate(pageScrollView)

        setUpViewControllers()

        updateSegmentedTitleTextAttributes()

        // Add subviews
        view.addSubview(pageScrollView)
        view.addSubview(pageSegmentedControl)
        view.addSubview(scrollIndicator)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Update segmented control frame
        pageSegmentedControl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: segmentedControlHeight)

        // Scroll view
        setUpPageScrollView()

        // Update child view controllers' view frame
        for (index, viewController) in viewControllers.enumerated() {
            if let view = viewController.viewIfLoaded {
                view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: pageScrollView.bounds.width, height: pageScrollView.bounds.height)
            }
        }

        // Update scroll indicator's vertical position
        setUpScrollIndicator()
    }

    // MARK: Segmented control action
    @objc func pageSegmentedControlValueChanged() {
        performUpdate(with: selectedPageIndex, previousPageIndex: previousPageIndex)
    }

    /// Update selected tab with or without animation
    open func setSelectedPageIndex(_ selectedPageIndex: Int, animated: Bool) {
        performUpdate(with: selectedPageIndex, previousPageIndex: previousPageIndex, animated: animated)
    }

    // Update selected tab
    private func performUpdate(with selectedPageIndex: Int, previousPageIndex: Int, animated: Bool = true) {
        if selectedPageIndex != previousPageIndex {
            // Call delegate method before changing value
            delegate?.pagerController?(self, willChangeSelectedPageIndex: selectedPageIndex, fromPageIndex: previousPageIndex)

            let oldViewController = viewControllers[previousPageIndex]
            let newViewController = viewControllers[selectedPageIndex]

            if self.automaticallyHandleAppearanceTransitions {
                oldViewController.beginAppearanceTransition(false, animated: true)
                newViewController.beginAppearanceTransition(true, animated: true)
            }

            // Call these two methods to notify that two view controllers are being removed or added to container view controller (Check Documentation)
            if automaticallyHandleAppearanceTransitions {
                oldViewController.willMove(toParent: nil)
                addChild(newViewController)
            }

            let size = view.bounds.size
            let contentOffset = CGFloat(selectedPageIndex) * size.width
            let animationDuration = animated ? 0.5 : 0.0

            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 5, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                self.pageScrollView.contentOffset = CGPoint(x: contentOffset, y: 0)

                // Update status bar
                self.setNeedsStatusBarAppearanceUpdate()

            }, completion: { (_) -> Void in

                //Call delegate method after changing value
                self.delegate?.pagerController?(self, didChangeSelectedPageIndex: self.selectedPageIndex)
            })

            // Call these two methods to notify that two view controllers are already removed or added to container view controller (Check Documentation)
            if automaticallyHandleAppearanceTransitions {
                oldViewController.removeFromParent()
                newViewController.didMove(toParent: self)

                oldViewController.endAppearanceTransition()
                newViewController.endAppearanceTransition()
            }

            // Setting up new previousPageIndex for next change
            self.previousPageIndex =  selectedPageIndex
        }
    }

    // Remove all current child view controllers
    private func removeChildViewControllers(_ childViewControllers: [UIViewController]) {
        // Remove each child view controller and its view from parent view controller and its view hierachy
        for viewController in childViewControllers {
            if automaticallyHandleAppearanceTransitions {
                viewController.beginAppearanceTransition(false, animated: false)
            }

            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()

            if automaticallyHandleAppearanceTransitions {
                viewController.endAppearanceTransition()
            }
        }
    }

    // Setup new child view controllers
    // Called in viewDidLoad or each time a new array of viewControllers is set
    private func setUpViewControllers() {
        if viewIfLoaded != nil {
            // Setup page scroll view
            setUpPageScrollView()

            // Page segmented control
            var titles = [String]()

            for (_, viewController) in viewControllers.enumerated() {
                titles.append(viewController.title ?? "")
            }

            // Set up segmented control
            setUpSegmentedControl(viewControllers: viewControllers)

            let indexes = self.visiblePageIndexes()

            // Then add subview, we do this later to prevent viewDidLoad of child view controllers to be called before page segment is allocated.
            for (index, viewController) in viewControllers.enumerated() {
                // Add view controller's view if it must be visible in scroll view
                if let _ = indexes.firstIndex(of: index) {
                    // Add to call viewDidLoad if needed
                    viewController.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height - segmentedControlHeight)
                    pageScrollView.addSubview(viewController.view)

                    // This will call viewWillAppear
                    addChild(viewController)

                    // This will call viewDidAppear
                    viewController.didMove(toParent: self)
                }
            }

            // Scroll indicator
            setUpScrollIndicator()
        }
    }

    public func setTitle(_ title: String?, forSegmentAt segment: Int) {
        pageSegmentedControl.setTitle(title, forSegmentAt: segment)
    }

    public func setImage(_ image: UIImage?, forSegmentAt segment: Int) {
        pageSegmentedControl.setImage(image, forSegmentAt: segment)
    }

    func setUpPageScrollView() {
        let size = view.bounds.size

        // Updating pageScrollView's frame or contentSize will automatically trigger scrollViewDidScroll(_: UIScrollView) and update selectedPageIndex
        // We need to save the value of selectedPageIndex and update pageScrollView's horizontal content offset correctly.
        let index = selectedPageIndex
        pageScrollView.frame = CGRect(x: 0, y: segmentedControlHeight, width: size.width, height: size.height - segmentedControlHeight)
        pageScrollView.contentSize = CGSize(width: pageScrollView.frame.width * CGFloat(viewControllers.count), height: 0)
        pageScrollView.contentOffset.x = pageScrollView.frame.width * CGFloat(index)
    }

    /// Setup pageSegmentedControl
    /// This method is called every time new array of view controllers is set or in viewDidLoad.
    /// If you provide a custom segmented control, all of your setup could be here. For example, create a new custom segmented control based on number of items in viewControllers and set with new titles.
    open func setUpSegmentedControl(viewControllers: [UIViewController]) {

        // Only remove all segments if using UISegmentedControl
        if let pageSegmentedControl = pageSegmentedControl as? UISegmentedControl {
            pageSegmentedControl.removeAllSegments()
        }

        for (index, _) in viewControllers.enumerated() {
            // Only insert new segment if using default UISegmentedControl
            if let pageSegmentedControl = pageSegmentedControl as? UISegmentedControl {
                pageSegmentedControl.insertSegment(withTitle: "", at: index, animated: false)
            }

            // Call this method to setup appearance for every single segmented.
            updateAppearanceForSegmentedItem(at: index)
        }

        // Add target if needed
        if self != (pageSegmentedControl.target(forAction: #selector(pageSegmentedControlValueChanged), withSender: UIControl.Event.valueChanged) as? DTPagerController) {
            pageSegmentedControl.addTarget(self, action: #selector(pageSegmentedControlValueChanged), for: UIControl.Event.valueChanged)
        }

        selectedPageIndex = previousPageIndex
    }

    open func setUpScrollIndicator() {
        if viewControllers.count > 0 {
            scrollIndicator.frame.size = CGSize(width: view.bounds.width/CGFloat(viewControllers.count), height: scrollIndicatorHeight)
        }

        scrollIndicator.frame.origin.y = segmentedControlHeight - scrollIndicatorHeight
        updateScrollIndicatorHorizontalPosition(with: pageScrollView)
    }

    /// Use this method to set up appearance of segmented item at a certain index.
    /// If you use custom segmented control, for example, with image and title, here is where you can customize appearance of each segmented item.
    /// Please do not call super if you do not want the default behavior.
    /// If not overriden, title of current view controller will be used for segmented item.
    open func updateAppearanceForSegmentedItem(at index: Int) {
        if let title = viewControllers[index].title {
            pageSegmentedControl.setTitle(title, forSegmentAt: index)
        }
    }

    // MARK: UIScrollViewDelegate's method
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Disable animation
        UIView.setAnimationsEnabled(false)

        // Delegate
        delegate?.pagerController?(self, pageScrollViewDidScroll: scrollView)

        // Add child view controller's view if needed
        let indexes = self.visiblePageIndexes()

        for index in indexes {
            let viewController = viewControllers[index]
            viewController.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height - segmentedControlHeight)
            pageScrollView.addSubview(viewController.view)
        }

        // Enable animation back
        UIView.setAnimationsEnabled(true)

        // Update bar position
        updateScrollIndicatorHorizontalPosition(with: scrollView)

        // When content offset changes, check if it is closer to the next page
        var index: Int = 0
        if scrollView.contentOffset.x == 0 && scrollView.frame.size.width == 0 {
            index = 0
        } else {
            index = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        }

        // Update segmented selected state only
        if pageSegmentedControl.selectedSegmentIndex != index {
            pageSegmentedControl.selectedSegmentIndex = index
        }
    }

    // Update indicator center
    open func updateScrollIndicatorHorizontalPosition(with scrollView: UIScrollView) {
        let offsetRatio = scrollView.contentOffset.x / scrollView.contentSize.width

        updateScrollIndicator(with: offsetRatio, scrollView: scrollView)
    }

    /// Update scroll indicator with offset ratio
    open func updateScrollIndicator(with offsetRatio: CGFloat, scrollView: UIScrollView) {
        // let itemWidth = scrollView.frame.width/CGFloat(viewControllers.count)
        if viewControllers.count > 0 {
            scrollIndicator.center.x = (offsetRatio + 1 / (CGFloat(viewControllers.count) * 2 )) * scrollView.frame.width
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        selectedPageIndex = index
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let index = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
            selectedPageIndex = index
        }
    }

    // Observer
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        if let scrollView = object as? UIScrollView {
            if scrollView == pageScrollView {
                if keyPath == #keyPath(UIScrollView.delegate) {
                    if scrollView.delegate != nil {
                        fatalError("Cannot set delegate of pageScrollView to different object than the DTPagerController that owns it.")
                    }
                }
            }
        }
    }

    // Return page indexes that are visible
    private func visiblePageIndexes() -> [Int] {
        guard pageScrollView.bounds.width > 0, viewControllers.count > 0 else {
            return []
        }

        let offsetRatio = pageScrollView.contentOffset.x / pageScrollView.bounds.width

        if offsetRatio <= 0 {
            return [0]
        } else if offsetRatio >= CGFloat(viewControllers.count - 1) {
            return [viewControllers.count - 1]
        }

        let floorValue = Int(floor(offsetRatio))
        let ceilingValue = Int(ceil(offsetRatio))

        if floorValue == ceilingValue {
            return [floorValue]
        }

        return [floorValue, ceilingValue]
    }

    // MARK: Segmented control setup
    func updateSegmentedNormalTitleTextAttributes() {
        pageSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor], for: .normal)
        pageSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor.withAlphaComponent(0.5)], for: [.normal, .highlighted])
    }

    func updateSegmentedSelectedTitleTextAttributes() {
        pageSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: selectedFont, NSAttributedString.Key.foregroundColor: selectedTextColor], for: .selected)
        pageSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: selectedFont, NSAttributedString.Key.foregroundColor: selectedTextColor.withAlphaComponent(0.5)], for: [.selected, .highlighted])
    }

    func updateSegmentedTitleTextAttributes() {
        updateSegmentedNormalTitleTextAttributes()
        updateSegmentedSelectedTitleTextAttributes()
    }

    // Observe delegate value changed to disallow that
    // Called in viewDidLoad
    func observeScrollViewDelegate(_ scrollView: UIScrollView) {
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.delegate), options: NSKeyValueObservingOptions.new, context: nil)
    }

    func unobserveScrollViewDelegate(_ scrollView: UIScrollView) {
        // observeScrollViewDelegate is called in viewDidLoad
        // check if viewDidLoad has been called before remove observer
        if viewIfLoaded != nil {
            scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.delegate), context: nil)
        }
    }

}
