//
// GenerativeShader.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

//
// GenerativePreview.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// A trivial SwiftUI view that renders a Metal shader into a whole
/// rectangle space, so it has complete control over rendering.
struct GenerativePreview: View {
    /// The initial time this view was created, so we can send
    /// elapsed time to the shader.
    @State private var start = Date.now

    /// The shader we're rendering.
    var shader: GenerativeShader

    var body: some View {
        VStack {
            TimelineView(.animation) { tl in
                let time = start.distance(to: tl.date)

                Rectangle()
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            shader.createShader(
                                elapsedTime: time,
                                size: proxy.size
                            )
                        )
                    }
            }
        }
    }
}

#Preview {
    GenerativePreview(shader: .sineBow)
}

/// A shader that generates its contents fully from scratch.
struct GenerativeShader: Hashable, Identifiable {
    /// The unique, random identifier for this shader, so we can show these
    /// things in a loop.
    var id = UUID()

    /// The human-readable name for this shader. This must work with the
    /// String-ShaderName extension so the name matches the underlying
    /// Metal shader function name.
    var name: String

    /// Some shaders need completely custom initialization, so this is effectively
    /// a trap door to allow that to happen rather than squeeze all sorts of
    /// special casing into the code.
    var initializer: ((_ time: Double, _ size: CGSize) -> Shader)?

    /// We need a custom equatable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    static func ==(lhs: GenerativeShader, rhs: GenerativeShader) -> Bool {
        lhs.id == rhs.id
    }

    /// We need a custom hashable conformance to compare only the IDs, because
    /// the `initializer` property blocks the synthesized conformance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Converts this shader to its Metal shader by resolving its name.
    func createShader(elapsedTime: Double, size: CGSize) -> Shader {
        if let initializer {
            return initializer(elapsedTime, size)
        } else {
            let shader = ShaderLibrary[dynamicMember: name.shaderName]
            return shader(
                .float2(size),
                .float(elapsedTime)
            )
        }
    }

    /// An example shader used for Xcode previews.
    static let example = sineBow

    static let animatedGradient = GenerativeShader(name: "AnimatedGradientFill")

    static let sineBow = GenerativeShader(name: "Sinebow")

    static let lightGrid = GenerativeShader(name: "Light Grid") { time, size in
        let shader = ShaderLibrary[dynamicMember: "lightGrid"]
        return shader(
            .float2(size),
            .float(time),
            .float(8),
            .float(3),
            .float(1),
            .float(3)
        )
    }
}

extension String {
    var shaderName: String {
        let camelCase = prefix(1).lowercased() + dropFirst()
        return camelCase.replacing(" ", with: "")
    }
}
