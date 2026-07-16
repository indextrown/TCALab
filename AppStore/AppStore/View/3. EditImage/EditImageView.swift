//
//  EditImageView.swift
//  AppStore
//
//  Created by 김동현 on 6/6/26.
//

import SwiftUI
import ComposableArchitecture
import SwiftData
import Photos

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 3)
    
    @Query private var users: [User]
    private var user: User? {
        users.first
    }
    @Environment(\.modelContext) var context
    
    var body: some View {
        ScrollView {
            VStack {
                Text("선택된 이미지")
                
                Group {
                    // 선택된 이미지
                    if let image = store.userImage {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(8)
            }
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(store.assets, id: \.localIdentifier) { asset in
                    let isSelectedImage = store.selectedPhoto?.id == asset.localIdentifier
                    AssetImageView(asset: asset, isSelected: isSelectedImage) { data in
                        // TODO: - onTap
                        store.send(.onSelectPhoto(id: asset.localIdentifier , data: data))
                    }
                    .clipped()
                    .cornerRadius(8)
                }
            }
            .padding(8)
        }
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    editImage(data: store.selectedPhoto?.data)
                }) {
                    Text("저장")
                }
            }
        })
        .alert(store: store.scope(state: \.$alert, action: \.alert))
        .onAppear {
            store.send(.onAppear(image: user?.imageData))
        }
    }
    
    func editImage(data: Data?) {
        guard let data = data else { return }
        user?.imageData = data
        do {
            try context.save()
            store.send(.onEditSuccess(data))
        } catch {
            store.send(.onEditFail(error.localizedDescription))
        }
    }
}

private struct AssetImageView: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: (Data) -> Void
    let imageWidth = (UIScreen.main.bounds.width - 16 - 20) / 3
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .onTapGesture {
                        if let data = image.jpegData(compressionQuality: 1.0) {
                            onTap(data) // 외부 전달
                        }
                    }
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .frame(width: imageWidth, height: imageWidth)
        .overlay(content: {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .frame(width: 20, height: 20)
            }
        })
        .onAppear {
            PhotoManager.fetchImage(asset: asset) { uiImage in
                image = uiImage
            }
        }
    }
}


//#Preview {
//    EditImageView()
//}
