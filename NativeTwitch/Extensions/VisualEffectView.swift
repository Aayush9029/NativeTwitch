//
//  VisualEffectView.swift
//  Neo
//
//  Created by Aayush Pokharel on 2023-11-07.
//

import SwiftUI

// MARK: - VisualEffectBlur

public struct VisualEffectBlur: View {
    private let effectSettings: EffectSettings

    public init(
        material: NSVisualEffectView.Material = .headerView,
        blendingMode: NSVisualEffectView.BlendingMode = .withinWindow,
        state: NSVisualEffectView.State = .followsWindowActiveState
    ) {
        self.effectSettings = EffectSettings(material: material, blendingMode: blendingMode, state: state)
    }

    public var body: some View {
        Representable(settings: effectSettings).accessibility(hidden: true)
    }

    static var hudWindow: VisualEffectBlur {
        VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow, state: .active)
    }
}

// MARK: - EffectSettings

struct EffectSettings {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    let state: NSVisualEffectView.State
}

// MARK: - Representable

extension VisualEffectBlur {
    struct Representable: NSViewRepresentable {
        let settings: EffectSettings

        func makeNSView(context: Context) -> NSVisualEffectView {
            let view = NSVisualEffectView()
            updateNSView(view, context: context)
            return view
        }

        func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
            nsView.material = settings.material
            nsView.blendingMode = settings.blendingMode
            nsView.state = settings.state
        }
    }
}

// MARK: - View Extension for Blurred Background

extension View {
    func blurredBackground(
        material: NSVisualEffectView.Material = .hudWindow,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        state: NSVisualEffectView.State = .followsWindowActiveState
    ) -> some View {
        background(VisualEffectBlur(material: material, blendingMode: blendingMode, state: state))
    }
}
