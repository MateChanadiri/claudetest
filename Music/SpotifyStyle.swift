import SwiftUI

// MARK: - Spotify design tokens
// NOTE: Color(hex:) already exists in CoverArt.swift (nonisolated). Do NOT redeclare it here.
enum Spotify {
    nonisolated static let background    = Color(hex: "#121212")
    nonisolated static let card          = Color(hex: "#1F1F1F")
    nonisolated static let cardRaised    = Color.white.opacity(0.10)
    nonisolated static let green         = Color(hex: "#1ED760")
    nonisolated static let textPrimary   = Color.white
    nonisolated static let textSecondary = Color(hex: "#B3B3B3")

    nonisolated static let pageTitleFont  = Font.system(size: 26, weight: .bold, design: .rounded)
    nonisolated static let rowTitleFont   = Font.system(size: 16, weight: .bold, design: .rounded)
    nonisolated static let rowSubFont     = Font.system(size: 13, weight: .regular, design: .rounded)
    nonisolated static let shelfTitleFont = Font.system(size: 21, weight: .bold, design: .rounded)
    nonisolated static let tabFont        = Font.system(size: 11, weight: .semibold)
}

// MARK: - Song row (title + artist + "...")
struct SpotifySongRow: View {
    let title: String
    let subtitle: String
    var leadingNumber: Int? = nil
    var artwork: AnyView? = nil
    var onTap:   () -> Void = {}
    var onMore:  () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            if let n = leadingNumber {
                Text("\(n)")
                    .font(.system(size: 15))
                    .foregroundStyle(Spotify.textSecondary)
                    .frame(width: 22, alignment: .trailing)
            }
            if let art = artwork {
                art
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Spotify.rowTitleFont)
                    .foregroundStyle(Spotify.textPrimary)
                    .lineLimit(1)
                Text(subtitle)
                    .font(Spotify.rowSubFont)
                    .foregroundStyle(Spotify.textSecondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Spotify.textSecondary)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Shelf (title + "Show all" + horizontal scroll)
struct SpotifyShelf<Item: Identifiable, Content: View>: View {
    let title: String
    let items: [Item]
    var showAll: () -> Void = {}
    @ViewBuilder var content: (Item) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(Spotify.shelfTitleFont)
                    .foregroundStyle(Spotify.textPrimary)
                Spacer()
                Button("Show all", action: showAll)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Spotify.textSecondary)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(items) { item in
                        content(item).frame(width: 140)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Gradient header for detail pages
struct SpotifyGradientHeader<Cover: View>: View {
    let title: String
    let subtitle: String
    let tint: Color
    var isArtist: Bool = false
    @ViewBuilder var cover: () -> Cover
    var onDownload: () -> Void = {}
    var onAdd:      () -> Void = {}
    var onShuffle:  () -> Void = {}
    var onMore:     () -> Void = {}
    var onPlay:     () -> Void = {}

    var body: some View {
        VStack(spacing: 16) {
            coverContent

            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Spotify.textPrimary)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(Spotify.rowSubFont)
                    .foregroundStyle(Spotify.textSecondary)
            }
            .padding(.horizontal, 24)

            HStack(spacing: 22) {
                Button(action: onDownload) { Image(systemName: "arrow.down.circle") }
                Button(action: onAdd)      { Image(systemName: "plus.circle") }
                Button(action: onShuffle)  { Image(systemName: "shuffle") }
                Button(action: onMore)     { Image(systemName: "ellipsis") }
                Spacer()
                Button(action: onPlay) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(width: 56, height: 56)
                        .background(Spotify.green)
                        .clipShape(Circle())
                }
            }
            .font(.system(size: 22, weight: .regular))
            .foregroundStyle(Spotify.textPrimary)
            .padding(.horizontal, 24)
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [tint.opacity(0.85), Spotify.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        )
    }

    // Artist → circle, album/playlist → 4pt rounded square.
    // Uses ViewBuilder instead of a type-erased AnyShape (avoids Swift 6 Sendable complaint).
    @ViewBuilder
    private var coverContent: some View {
        if isArtist {
            cover()
                .frame(width: 220, height: 220)
                .clipShape(Circle())
                .shadow(radius: 20, y: 10)
                .padding(.top, 40)
        } else {
            cover()
                .frame(width: 220, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                .shadow(radius: 20, y: 10)
                .padding(.top, 40)
        }
    }
}

// MARK: - Spotify screen wrapper
struct SpotifyScreen<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        ZStack {
            Spotify.background.ignoresSafeArea()
            content()
        }
        .tint(Spotify.green)
        .toolbarBackground(Spotify.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
