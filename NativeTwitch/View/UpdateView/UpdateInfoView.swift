//
//  UpdateInfoView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import SwiftUI

struct UpdateInfoView: View {
    let update: UpdateModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                HStack{
                    Text("What's new in NativeTwitch \(update.version) build \(update.build)?")
                        .bold()
                        .italic()
                    Spacer()
                    NeatButton(title: "Open Releases", symbol: "globe")
                        .onTapGesture {
                            NSWorkspace.shared.open(URL(string: "https://github.com/Aayush9029/NativeTwitch/releases")!)
                        }
                }
                Divider()
                
                VStack{
                    HStack{
                        Text(update.title)
                            .font(.title.bold())
                        Spacer()
                    }
                    
                    Divider()
                    
                    ForEach(update.image, id:\.self){imageDetail in
                        HStack{
                            Text(imageDetail.title)
                                .bold()
                            Spacer()
                        }
                        AsyncImage(url: URL(string: imageDetail.image)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image("streamer-image-placeholder")
                                .resizable()
                                .scaledToFill()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2)
                                .shadow(color: Color.pink.opacity(0.75), radius: 5)
                        )
                        .padding(5)
                        Text(imageDetail.imageDescription)
                            .foregroundColor(.secondary)
                        Divider()
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInfoView(update: exampleUpdateModel)
            .frame(width: 500, height: 500)
    }
}
