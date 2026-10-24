import SwiftUI

// Generic track artwork. Replace body with your real artwork loader if you have one.
struct TrackArtwork: View {
    let track: Track
    var size: CGFloat = 48
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#3A3A3A"), Color(hex: "#1F1F1F")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Text(String(track.title.prefix(1)))
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

// Generic artist avatar (circle).
struct ArtistAvatar: View {
    let name: String
    var size: CGFloat = 48
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#4A4A4A"), Color(hex: "#1F1F1F")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Text(String(name.prefix(1)))
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundStyle(.white.opacity(0.8))
        }
        .clipShape(Circle())
    }
}