//
//  OptionalImageView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 11/07/2023.
//

import SwiftUI

struct OptionalImageView: View {

    let data: Data?
    
    var body: some View {

        if let data = data, let uiImage = UIImage(data: data){
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            EmptyView()
        }
    }
}
/*
 struct OptionalImageView_Previews: PreviewProvider {
 static var previews: some View {
 OptionalImageView()
 }
 }
 */
