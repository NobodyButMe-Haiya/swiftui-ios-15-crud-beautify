//
//  FormView.swift
//  crud
//
//  Created by user on 16/09/2021.
//

import SwiftUI

struct FormView: View {
    // this era we call what state ?
    // for some developer might confuse to which   it's okay
    @State var name = ""
    @State var age = "";
    @State var personId = "";
    // this is for navigation purpose
    @State private var selection:String? = nil
    
    @State private var isNameEditing = false
    @State private var isAgeEditing = false
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: ListView(),
                tag:"home",
                selection:$selection){
                    EmptyView()
                }.isDetailLink(false)
            
            TextField("Name",text:$name)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .background(Color(.systemGray6))
            
            
            TextField("Age",text:$age)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
        }.padding(10)
            .navigationTitle("Save")
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selection = "home"
                    }, label: {
                        Image(systemName: "house")
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save();
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                }
            }
        
            .navigationBarBackButtonHidden(true)
    }
    func save() {
        let  url = URL(string:"http://localhost/php_tutorial/api.php")!
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "POST"
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false);
        // depend on what you want to put query parameter ?
        if personId.isEmpty {
            urlComponents?.queryItems = [
                URLQueryItem(name: "mode", value: "create"),
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "age", value: age),
                
                
            ];
        }else {
            urlComponents?.queryItems = [
                URLQueryItem(name: "mode", value: "update"),
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "age", value: age),
                URLQueryItem(name: "personId", value: personId),
                
            ];
        }
        // some people prefer whatever body one json request to body
        urlRequest.httpBody = Data((urlComponents?.url!.query!.utf8)!);
        
        let task  = URLSession.shared.dataTask(with: urlRequest){
            
            (data,res,error)  in
            
            if(error != nil){
                // xcode sometimes nasty comment without knowing what it want ?
                print(error!)
            }else{
                // okay we continue
                do {
                    // now we parse data before xcode complain nothing to catch
                    if let data = data {
                        let result = try JSONDecoder().decode(RespondModel.self, from: data)
                        // bind to model
                        if(result.success){
                            // we re direct to new navigation home if updated
                            selection = "home"
                        }
                    }else {
                        print ("Got Data meh ?");
                    }
                }catch let ExceptionError {
                    print("Exception Error lol : ",ExceptionError.localizedDescription)
                }
            }
        }
        task.resume();
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
