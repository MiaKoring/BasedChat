import SwiftUI
import RealmSwift

struct CreateStickerView: View {
    
    //MARK: - Body
    
    var body: some View {
        Form {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: "x.circle.fill")
                            .font(.title2)
                            .onTapGesture {
                                imageData = nil
                                self.image = nil
                            }
                    }
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .overlay {
                        StickerPicker(image: $image, imageData: $imageData)
                    }
            }
            Section(header: Text("Name"), footer: Text("You can't change the name later")) {
                TextField("Name", text: $textInput)
            }
            Button {
                startCreation()
            } label: {
                Text("Create")
            }
        }
        .sheet(isPresented: $showAddToCollection) {
            if let sticker {
                AddToCollectionView(stickerHash: sticker.hash, stickerType: sticker.type, stickerName: sticker.name)
            } else {
                ContentUnavailableView("Something went wrong", systemImage: "exclamationmark.triangle")
            }
        }
        .alert("Please select an image", isPresented: $imageEmptyAlert) {
            AlertCloseButton(displayed: $imageEmptyAlert)
        }
        .alert("Please enter a name", isPresented: $nameEmptyAlert) {
            AlertCloseButton(displayed: $nameEmptyAlert)
        }
        .alert("A sticker with this image already exists", isPresented: $stickerExists) {
            Button {
                create()
                stickerExists = false
            } label: {
                Text("Yes")
            }
            AlertCloseButton(text: "No", displayed: $creationError)
        } message: {
            Text("Do you wan't to continue anyways?")
        }
        .alert("An Error occured while creating Sticker", isPresented: $creationError) {
            AlertCloseButton(displayed: $creationError)
        }
        .alert("Sticker created successfully", isPresented: $addToCollections) {
            Button {
                showAddToCollection = true
                addToCollections = false
            } label: {
                Text("Yes")
            }
            Button {
                dismiss()
            } label: {
                Text("No")
            }
        } message: {
            Text("Do you want to add the sticker to collections?")
        }
        .onChange(of: showAddToCollection) {
            if !showAddToCollection { dismiss() }
        }
    }
    
    //MARK: - Parameters
    
    @Environment(\.dismiss) var dismiss
    @State var image: Image? = nil
    @State var imageData: Data? = nil
    @State var textInput: String = ""
    @State var showAddToCollection: Bool = false
    @State var imageEmptyAlert: Bool = false
    @State var nameEmptyAlert: Bool = false
    @State var stickerExists: Bool = false
    @State var creationError: Bool = false
    @State var addToCollections = false
    @State var sticker: SendableSticker? = nil
    @ObservedResults(Sticker.self) var stickers
}
