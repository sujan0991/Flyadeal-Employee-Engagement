//
//  CustomMessageLabel.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 7/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

open class CustomMessageLabel: UILabel {
    
    // MARK: - Private Properties
    
    private lazy var layoutManager: NSLayoutManager = {
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(self.textContainer)
        return layoutManager
    }()
    
    private lazy var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer()
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.size = self.bounds.size
        return textContainer
    }()
    
    private lazy var textStorage: NSTextStorage = {
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(self.layoutManager)
        return textStorage
    }()
    

    
    private var isConfiguring: Bool = false
    
    // MARK: - Public Properties
    
//    open weak var delegate: MessageLabelDelegate?
    
//    open var enabledDetectors: [DetectorType] = [] {
//        didSet {
//            setTextStorage(attributedText, shouldParse: true)
//        }
//    }
    
    open override var attributedText: NSAttributedString? {
        didSet {
            setTextStorage(attributedText, shouldParse: true)
        }
    }
    
    open override var text: String? {
        didSet {
            setTextStorage(attributedText, shouldParse: true)
        }
    }
    
    open override var font: UIFont! {
        didSet {
            setTextStorage(attributedText, shouldParse: false)
        }
    }
    
    open override var textColor: UIColor! {
        didSet {
            setTextStorage(attributedText, shouldParse: false)
        }
    }
    
    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
            if !isConfiguring { setNeedsDisplay() }
        }
    }
    
    open override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
            if !isConfiguring { setNeedsDisplay() }
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        didSet {
            setTextStorage(attributedText, shouldParse: false)
        }
    }
    
    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            if !isConfiguring { setNeedsDisplay() }
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.horizontal
        size.height += textInsets.vertical
        return size
    }
    
    internal var messageLabelFont: UIFont?
    
    private var attributesNeedUpdate = false
    
  
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Open Methods
    
    open override func drawText(in rect: CGRect) {
        
        let insetRect = rect.inset(by: textInsets)
        textContainer.size = CGSize(width: insetRect.width, height: rect.height)
        
        let origin = insetRect.origin
        let range = layoutManager.glyphRange(for: textContainer)
        
        layoutManager.drawBackground(forGlyphRange: range, at: origin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: origin)
    }
    
    // MARK: - Public Methods
    
    public func configure(block: () -> Void) {
        isConfiguring = true
        block()
//        if attributesNeedUpdate {
//            updateAttributes(for: enabledDetectors)
//        }
        attributesNeedUpdate = false
        isConfiguring = false
        setNeedsDisplay()
    }
    
    // MARK: - Private Methods
    
    private func setTextStorage(_ newText: NSAttributedString?, shouldParse: Bool) {
        
        guard let newText = newText, newText.length > 0 else {
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }
        
        let style = paragraphStyle(for: newText)
        let range = NSRange(location: 0, length: newText.length)
        
        let mutableText = NSMutableAttributedString(attributedString: newText)
        mutableText.addAttribute(.paragraphStyle, value: style, range: range)
        
//        if shouldParse {
//            rangesForDetectors.removeAll()
//            let results = parse(text: mutableText)
//            setRangesForDetectors(in: results)
//        }
//
//        for (detector, rangeTuples) in rangesForDetectors {
//            if enabledDetectors.contains(detector) {
//                let attributes = detectorAttributes(for: detector)
//                rangeTuples.forEach { (range, _) in
//                    mutableText.addAttributes(attributes, range: range)
//                }
//            }
//        }
        
        let modifiedText = NSAttributedString(attributedString: mutableText)
        textStorage.setAttributedString(modifiedText)
        
        if !isConfiguring { setNeedsDisplay() }
        
    }
    
    private func paragraphStyle(for text: NSAttributedString) -> NSParagraphStyle {
        guard text.length > 0 else { return NSParagraphStyle() }
        
        var range = NSRange(location: 0, length: text.length)
        let existingStyle = text.attribute(.paragraphStyle, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle
        let style = existingStyle ?? NSMutableParagraphStyle()
        
        style.lineBreakMode = lineBreakMode
        style.alignment = textAlignment
        
        return style
    }
    
//    private func updateAttributes(for detectors: [DetectorType]) {
//
//        guard let attributedText = attributedText, attributedText.length > 0 else { return }
//        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
//
//        for detector in detectors {
//            guard let rangeTuples = rangesForDetectors[detector] else { continue }
//
//            for (range, _)  in rangeTuples {
//                let attributes = detectorAttributes(for: detector)
//                mutableAttributedString.addAttributes(attributes, range: range)
//            }
//
//            let updatedString = NSAttributedString(attributedString: mutableAttributedString)
//            textStorage.setAttributedString(updatedString)
//        }
//    }
    
  
    
    private func setupView() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Parsing Text
    
//    private func parse(text: NSAttributedString) -> [NSTextCheckingResult] {
//        guard enabledDetectors.isEmpty == false else { return [] }
//        let range = NSRange(location: 0, length: text.length)
//        var matches = [NSTextCheckingResult]()
//
//        // Get matches of all .custom DetectorType and add it to matches array
//        let regexs = enabledDetectors
//            .filter { $0.isCustom }
//            .map { parseForMatches(with: $0, in: text, for: range) }
//            .joined()
//        matches.append(contentsOf: regexs)
//
//        // Get all Checking Types of detectors, except for .custom because they contain their own regex
//        let detectorCheckingTypes = enabledDetectors
//            .filter { !$0.isCustom }
//            .reduce(0) { $0 | $1.textCheckingType.rawValue }
//        if detectorCheckingTypes > 0, let detector = try? NSDataDetector(types: detectorCheckingTypes) {
//            let detectorMatches = detector.matches(in: text.string, options: [], range: range)
//            matches.append(contentsOf: detectorMatches)
//        }
//
//        guard enabledDetectors.contains(.url) else {
//            return matches
//        }
//
//        // Enumerate NSAttributedString NSLinks and append ranges
//        var results: [NSTextCheckingResult] = matches
//
//        text.enumerateAttribute(NSAttributedString.Key.link, in: range, options: []) { value, range, _ in
//            guard let url = value as? URL else { return }
//            let result = NSTextCheckingResult.linkCheckingResult(range: range, url: url)
//            results.append(result)
//        }
//
//        return results
//    }
    
//    private func parseForMatches(with detector: DetectorType, in text: NSAttributedString, for range: NSRange) -> [NSTextCheckingResult] {
//        switch detector {
//        case .custom(let regex):
//            return regex.matches(in: text.string, options: [], range: range)
//        default:
//            fatalError("You must pass a .custom DetectorType")
//        }
//    }
    
    
    // MARK: - Gesture Handling
    
//    private func stringIndex(at location: CGPoint) -> Int? {
//        guard textStorage.length > 0 else { return nil }
//
//        var location = location
//
//        location.x -= textInsets.left
//        location.y -= textInsets.top
//
//        let index = layoutManager.glyphIndex(for: location, in: textContainer)
//
//        let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: nil)
//
//        var characterIndex: Int?
//
//        if lineRect.contains(location) {
//            characterIndex = layoutManager.characterIndexForGlyph(at: index)
//        }
//
//        return characterIndex
//
//    }
    
//    open func handleGesture(_ touchLocation: CGPoint) -> Bool {
//
//        guard let index = stringIndex(at: touchLocation) else { return false }
//
//        for (detectorType, ranges) in rangesForDetectors {
//            for (range, value) in ranges {
//                if range.contains(index) {
//                    handleGesture(for: detectorType, value: value)
//                    return true
//                }
//            }
//        }
//        return false
//    }
    
    // swiftlint:disable cyclomatic_complexity
//    private func handleGesture(for detectorType: DetectorType, value: MessageTextCheckingType) {
//
//        switch value {
//        case let .addressComponents(addressComponents):
//            var transformedAddressComponents = [String: String]()
//            guard let addressComponents = addressComponents else { return }
//            addressComponents.forEach { (key, value) in
//                transformedAddressComponents[key.rawValue] = value
//            }
//            handleAddress(transformedAddressComponents)
//        case let .phoneNumber(phoneNumber):
//            guard let phoneNumber = phoneNumber else { return }
//            handlePhoneNumber(phoneNumber)
//        case let .date(date):
//            guard let date = date else { return }
//            handleDate(date)
//        case let .link(url):
//            guard let url = url else { return }
//            handleURL(url)
//        case let .transitInfoComponents(transitInformation):
//            var transformedTransitInformation = [String: String]()
//            guard let transitInformation = transitInformation else { return }
//            transitInformation.forEach { (key, value) in
//                transformedTransitInformation[key.rawValue] = value
//            }
//            handleTransitInformation(transformedTransitInformation)
//        case let .custom(pattern, match):
//            guard let match = match else { return }
//            switch detectorType {
//            case .hashtag:
//                handleHashtag(match)
//            case .mention:
//                handleMention(match)
//            default:
//                handleCustom(pattern, match: match)
//            }
//        }
//    }
    // swiftlint:enable cyclomatic_complexity
    
//    private func handleAddress(_ addressComponents: [String: String]) {
//        delegate?.didSelectAddress(addressComponents)
//    }
//
//    private func handleDate(_ date: Date) {
//        delegate?.didSelectDate(date)
//    }
//
//    private func handleURL(_ url: URL) {
//        delegate?.didSelectURL(url)
//    }
//
//    private func handlePhoneNumber(_ phoneNumber: String) {
//        delegate?.didSelectPhoneNumber(phoneNumber)
//    }
//
//    private func handleTransitInformation(_ components: [String: String]) {
//        delegate?.didSelectTransitInformation(components)
//    }
//
//    private func handleHashtag(_ hashtag: String) {
//        delegate?.didSelectHashtag(hashtag)
//    }
//
//    private func handleMention(_ mention: String) {
//        delegate?.didSelectMention(mention)
//    }
//
//    private func handleCustom(_ pattern: String, match: String) {
//        delegate?.didSelectCustom(pattern, match: match)
//    }
    
}
