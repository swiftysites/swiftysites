/// All custom content needs to comply to this protocol in order to be part of any ``Site`` definition.
public protocol Content {

    /// This content's path within the site.
    var path: String { get }
}
