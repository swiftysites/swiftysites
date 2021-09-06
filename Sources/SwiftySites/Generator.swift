extension Site {

    /// Used to generate additional content items for the site.
    public struct Generator {

        /// Generates content items of the first content type.
        let generateA: ((Site) -> [A])?

        /// Generates content items of the second content type.
        let generateB: ((Site) -> [B])?

        /// Generates content items of the third content type.
        let generateC: ((Site) -> [C])?

        /// Generates content items of the fourth content type.
        let generateD: ((Site) -> [D])?

        /// Generates content items of the fifth content type.
        let generateE: ((Site) -> [E])?
    }

    /// Defines a generator for the first content type.
    ///
    /// - Parameters:
    ///   - generate: The function used to generate content of the corresponding content type from a ``Site`` instance.
    ///
    public static func generatorA(generate: @escaping (Site) -> [A]) -> Generator {
        Generator(generateA: generate, generateB: .none, generateC: .none, generateD: .none, generateE: .none)
    }

    /// Defines a generator for the second content type.
    ///
    /// See ``generatorA(generate:)`` for parameter descriptions.
    ///
    public static func generatorB(generate: @escaping (Site) -> [B]) -> Generator {
        Generator(generateA: .none, generateB: generate, generateC: .none, generateD: .none, generateE: .none)
    }

    /// Defines a generator for the third content type.
    ///
    /// See ``generatorA(generate:)`` for parameter descriptions.
    ///
    public static func generatorC(generate: @escaping (Site) -> [C]) -> Generator {
        Generator(generateA: .none, generateB: .none, generateC: generate, generateD: .none, generateE: .none)
    }

    /// Defines a generator for the fourth content type.
    ///
    /// See ``generatorA(generate:)`` for parameter descriptions.
    ///
    public static func generatorD(generate: @escaping (Site) -> [D]) -> Generator {
        Generator(generateA: .none, generateB: .none, generateC: .none, generateD: generate, generateE: .none)
    }

    /// Defines a generator for the fifth content type.
    ///
    /// See ``generatorA(generate:)`` for parameter descriptions.
    ///
    public static func generatorE(generate: @escaping (Site) -> [E]) -> Generator {
        Generator(generateA: .none, generateB: .none, generateC: .none, generateD: .none, generateE: generate)
    }
}
