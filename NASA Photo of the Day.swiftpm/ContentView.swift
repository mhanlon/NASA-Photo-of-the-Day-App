import SwiftUI

struct ContentView: View {
    @State var photoInfo: PhotoInfo?
    @State var photoDate: Date = Date()
    var body: some View {
        VStack {
            AsyncImage(url: photoInfo?.url) { phase in
                if let image = phase.image {
                    image.resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.square")
                } else {
                    ProgressView()
                }
            }
            .cornerRadius(10)
            Text(photoInfo?.title ?? "No image yet...")
                .font(.title)
            ScrollView {
                Text(photoInfo?.description ?? "")
                    .font(.body)
            }
            HStack {
                Text(photoInfo?.copyright ?? "")
                    .font(.caption)
                Spacer()
            }
            HStack {
                DatePicker("Date:", selection: $photoDate, in: Date().addingTimeInterval(-((60 * 60 * 24) * 100))...Date(), displayedComponents: .date)
                Button {
                    Task {
                        photoInfo = try? await PhotoInfoController().fetchPhotoInfo(for: photoDate)
                    }
                } label: {
                    Text("Fetch Photo")
                }
            }
        }
        .task {
            photoInfo = try? await PhotoInfoController().fetchPhotoInfo()
        }
    }
}
