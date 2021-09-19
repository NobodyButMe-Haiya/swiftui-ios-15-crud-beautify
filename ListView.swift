// this is the end swift ui .. it's seem simple but not.. it had a lot of weird bugs also
// we hope ios 15 can more simplify the code :P ..


import SwiftUI
struct RespondModel: Decodable {
    let success:Bool
    let message:String
}
struct ReadModel: Decodable {
    let success:Bool
    let message:String
    let data:[DataModel]
}
struct DataModel: Decodable {
    let personId:String
    let name:String
    let age:String
}
// next video will be the form ..  if you understand whatever in on appear should
/// be same with the form .  
struct ListView: View {
    // empty array
    @State var dataModel  = [DataModel]();
    @State var preserveDataModel  = [DataModel]();
    @State private var selection:String? = nil
    @State private var searchText = ""

    var body: some View {
        
   
            HStack  {
                NavigationLink(
                    destination: FormView(),
                    tag:"form",
                    selection:$selection){
                        EmptyView()
                    }.isDetailLink(false)
                if #available(iOS 15.0, *) {
                    List {
                        ForEach(dataModel, id:\.personId){
                            
                            item in
                            
                            NavigationLink(
                                destination:FormView(name:item.name, age:item.age,personId :item.personId),
                                label: {
                                    VStack (alignment: .leading ){
                                        HStack {
                                            Image(systemName: "person.circle")
                                            Text(item.name).font(.headline)
                                            
                                        }
                                        Spacer().frame(height:10)
                                        HStack{
                                            Image(systemName: "number")
                                            Text(item.age).font(.subheadline)
                                        }
                                    }
                                })
                            
                        }.onDelete(perform:{
                            indexSet in
                            // sometimes xcode fast sometimes slow.. we no idea also :(
                            // they realy need to improved auto complete  and basic fold also
                            let personId = String(indexSet.map {
                                self.dataModel[$0].personId
                            }[0]);
                            delete(personId: personId)
                            
                        })
                        
                        
                        // sometimes it appear sometimes not kinda hard xcode
                    }
                    .searchable(text: $searchText)
                    .onChange(of: searchText){
                        searchText in
                        
                        if !searchText.isEmpty {
                            dataModel = dataModel.filter { $0.name.lowercased().contains(searchText.lowercased())
                            }
                        }else{
                            // re-define data model on preserve value
                            dataModel  = preserveDataModel
                        }
                    }
                    .refreshable {
                        // as mention two option either want to refresh or page
                        // now we take all because too low.
                        // if over 500 record then paging append the current data
                        read()
                    }
                    .navigationTitle("List")
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.large)
                    
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems( trailing: Button(action: {
                        selection = "form"
                    }, label: {
                        Image(systemName: "plus")
                    }))
                    
                    .onAppear(){
                        read()
                    }
                } else {
                    // Fallback on earlier versions
                    List {
                        ForEach(dataModel, id:\.personId){
                            
                            item in
                            
                            NavigationLink(
                                destination:FormView(name:item.name, age:item.age,personId :item.personId),
                                label: {
                                    VStack (alignment: .leading ){
                                        HStack {
                                            Image(systemName: "person.circle")
                                            Text(item.name).font(.headline)
                                            
                                        }
                                        Spacer().frame(height:10)
                                        HStack{
                                            Image(systemName: "number")
                                            Text(item.age).font(.subheadline)
                                        }
                                    }
                                })
                            
                        }.onDelete(perform:{
                            indexSet in
                            // sometimes xcode fast sometimes slow.. we no idea also :(
                            // they realy need to improved auto complete  and basic fold also
                            let personId = String(indexSet.map {
                                self.dataModel[$0].personId
                            }[0]);
                            delete(personId: personId)
                            
                        })
                        
                        
                        // sometimes it appear sometimes not kinda hard xcode
                    }
                    .navigationTitle("List")
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.large)
                    
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems( trailing: Button(action: {
                        selection = "form"
                    }, label: {
                        Image(systemName: "plus")
                    }))
                    
                    .onAppear(){
                        read()
                    }
                }
            }
  
    }
    func read() {
        // we short the code to many .. confuse
        
        let  url = URL(string:"http://localhost/php_tutorial/api.php")!
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "POST"
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false);
        // depend on what you want to put query parameter ?
        urlComponents?.queryItems = [
            URLQueryItem(name: "mode", value: "read"),
        ];
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
                        let result = try JSONDecoder().decode(ReadModel.self, from: data)
                        // bind to model
                        dataModel = result.data
                        // for original value of search
                        preserveDataModel = dataModel
                    }else {
                        print ("Got Data meh ?");
                    }
                }catch let JsonError {
                    print("JSON ERROR lol : ",JsonError.localizedDescription)
                }
            }
        }
        task.resume();
    }
    func delete(personId:String) {
        let  url = URL(string:"http://localhost/php_tutorial/api.php")!
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "POST"
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false);
        // depend on what you want to put query parameter ?
        urlComponents?.queryItems = [
            URLQueryItem(name: "mode", value: "delete"),
            URLQueryItem(name: "personId", value: personId),
            
        ];
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
                            // we can removed the line only but if co-concurency user better delete em all .
                            read();
                        }
                    }else {
                        print ("Got Data meh ?");
                    }
                }catch let ExceptionError {
                    print("Exception ERROR lol : ",ExceptionError.localizedDescription)
                }
            }
        }
        task.resume();
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
