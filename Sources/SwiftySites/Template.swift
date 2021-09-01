extension Site {

    public struct Template {

        public static var defaultMatch: String {
            #"^.*$"#
        }

        public static var defaultIndex: String {
            "index"
        }

        public static var defaultSuffix: String {
            "html"
        }

        let match: String
        let exclude: String?
        let index: String?
        let suffix: String?
        let applyA: ((Site, A) -> String)?
        let applyB: ((Site, B) -> String)?

        init(match: String, exclude: String?, index: String?, suffix: String?, applyA: ((Site, A) -> String)?, applyB: ((Site, B) -> String)?) {
            self.match = match
            self.exclude = exclude
            self.index = index
            self.suffix = suffix
            self.applyA = applyA
            self.applyB = applyB
        }
    }

    public static func templateA(_ match: String = Template.defaultMatch, exclude: String? = .none, index: String? = Template.defaultIndex, suffix: String? = Template.defaultSuffix, apply: @escaping (Site, A) -> String) -> Template {
        Template(match: match, exclude: exclude, index: index, suffix: suffix, applyA: apply, applyB: .none)
    }

    public static func templateB(_ match: String = Template.defaultMatch, exclude: String? = .none, index: String? = Template.defaultIndex, suffix: String = Template.defaultSuffix, apply: @escaping (Site, B) -> String) -> Template {
        Template(match: match, exclude: exclude, index: index, suffix: suffix, applyA: .none, applyB: apply)
    }
}
