//
//  ContentView.swift
//  JsonSwiftUI
//
//  Created by Владимир Ширяев on 12.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var posts: [Post] = []
    
    var body: some View {
        NavigationView {
            List (posts){ post in
                HStack {
                    ImageURL(urlString: post.url)
                    
                    Text(post.title)
                        .font(.headline)
                }
            }
            .onAppear(){
                Api().getPost{ (posts) in
                    self.posts = posts
                }
            }
            .navigationTitle("Image")
        }
    }
}

struct Post: Codable, Identifiable {
    var id : Int
    var title: String
    var url: String
}

class Api{
    func getPost(completion: @escaping ([Post]) -> ()){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data!)
                
                DispatchQueue.main.async {
                    completion(posts)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}

struct ImageURL: View{
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data:data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .padding(2)
        } else {
            Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding(2)
                .background(.gray)
                .onAppear{
                    getData()
                }
        }
    }
    private func getData() {
        guard let url = URL(string: urlString)
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            self.data = data
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
