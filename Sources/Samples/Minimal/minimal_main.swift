import SwiftySites

let minimal_basicSite = BasicSite(
    config: .init(title: "Minimal Site"),
    contentA: [minimal_homePage],
    contentB: [],
    globalTemplates: [minimal_homeTemplate],
    templatesA: [],
    templatesB: []
).render()
