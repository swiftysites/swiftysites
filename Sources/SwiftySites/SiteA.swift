/// Use to define a site type with only one content type.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteA<Page>
/// ```
///
public typealias SiteA<A: Content> = Site<A, Never, Never, Never, Never>

/// Use to define a site type with two content types.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteB<Page, Post>
/// ```
///
public typealias SiteB<A: Content, B: Content> = Site<A, B, Never, Never, Never>

/// Use to define a site type with three content types.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteC<Page, Post, TopicPage>
/// ```
///
public typealias SiteC<A: Content, B: Content, C: Content> = Site<A, B, C, Never, Never>

/// Use to define a site type with four content types.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteD<Page, Article, CategoryIndex, SampleCode>
/// ```
///
public typealias SiteD<A: Content, B: Content, C: Content, D: Content> = Site<A, B, C, D, Never>
