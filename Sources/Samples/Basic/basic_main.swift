import SwiftySites

let basicSite = BasicSite(
    config: .init(title: "My Site"),
    contentA: [basic_homePage, basic_aboutPage, basic_contactPage],
    contentB: [],
    globalTemplates: [basic_homeTemplate],
    templatesA: [basic_pageTemplate],
    templatesB: []
).render()
