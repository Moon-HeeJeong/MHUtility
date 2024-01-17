////
////  CoreDataManager.swift
////  MHAPI
////
////  Created by LittleFoxiOSDeveloper on 1/8/24.
////
//
//import SwiftUI
//import Combine
//import CoreData
//
//class UserInfoData{
//    var userID: String?
//    var loginToken: String?
//    var nickname: String?
//    var fuID: String?
//    
//    init(userID: String?, loginToken: String?, nickname: String?, fuID: String?) {
//        self.userID = userID
//        self.loginToken = loginToken
//        self.nickname = nickname
//        self.fuID = fuID
//    }
//}
//
////class UserDataManager: ObservableObject {
////    private var cancellables: Set<AnyCancellable> = []
////
////    @Published var nickname: String?
////
////    init() {
////
////        // Combine을 사용하여 코어 데이터의 변경 사항을 감지
////
//////        let fetchRequest = UserEntity.fetchRequest()
////
//////        CoreDataStack.shared.container.viewContext.publisher(for: <#T##KeyPath<NSManagedObjectContext, Value>#>)
//////            .sink { [weak self] username in
//////                self?.nickname = username
////////                self?.userData = UserInfoData(userID: "idid", nickname: username, loginToken: "tokennn", fuID: "fuidid")
//////            }
//////            .store(in: &cancellables)
////    }
////
////    // 로그인 시 코어 데이터에 사용자 정보 저장
////    func saveUserData(nickname: String){
////        let context = CoreDataStack.shared.container.viewContext
////        var userEntity = UserInfoCoreData(context: context)
////        userEntity.nickname = nickname
////
////        CoreDataStack.shared.saveContext(nickname: nickname)
////    }
//////
//////    func login(userID: String) {
//////        // 로그인 시 코어 데이터에 사용자 정보 저장
//////        let context = CoreDataStack.shared.container.viewContext
//////        let userEntity = UserEntity(context: context)
//////        userEntity.userID = userID
//////
//////        CoreDataStack.shared.saveContext()
//////    }
////
//////    func logout() {
//////        // 로그아웃 시 코어 데이터에서 사용자 정보 삭제
//////        let context = CoreDataStack.shared.persistentContainer.viewContext
//////
//////        do {
//////            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
//////            let users = try context.fetch(fetchRequest)
//////            for user in users {
//////                context.delete(user)
//////            }
//////
//////            CoreDataStack.shared.saveContext()
//////        } catch {
//////            print("Error deleting user data: \(error.localizedDescription)")
//////        }
//////    }
////}
//
//struct CoreDataStack {
//    //세가지 클래스를 포함하는 Stack
//    //    모델(데이터 구조) - NSManagedObjectModel
//    //    컨텍스트(데이터 현황) - NSManagedObjectContext
//    //    저장소 관리자( DB에 접근해 CRUD를 대신해줌) - NSPersistentStoreCoordinator
//    
//    static var shared = CoreDataStack()
//    
//    let container: NSPersistentContainer
//    
//    init(){
//        //컨테이너 만들고 로드
//        self.container = NSPersistentContainer(name: "MHDataModel")
//        
//        self.container.loadPersistentStores { NSPersistentStoreDescription, error in
//            if let error = error as NSError?{
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//    
//    func saveUserData(userID: String, nickname: String, loginToken: String, fuID: String) {
//        
//        self.deleteData()
//        
//        let context = container.viewContext
//        
//        //데이터 넣기
//        let entity =  UserInfoCoreData(context: context)
//        
//        entity.setValue(userID, forKey: "userID")
//        entity.setValue(nickname, forKey: "nickname")
//        entity.setValue(loginToken, forKey: "loginToken")
//        entity.setValue(fuID, forKey: "fuID")
//        
//        //        let entity = NSEntityDescription.entity(forEntityName: "UserInfoCoreData", in: context)
//        //        if let entity = entity{
//        //            let userInfo = NSManagedObject(entity: entity, insertInto: context)
//        //            userInfo.setValue(nickname, forKey: "nickname")
//        //        }
//        
//        //데이터 저장
//        self.saveContext()
//    }
//    
//    func getUserData() -> UserInfoData? {
//        let data = try? self.container.viewContext.fetch(UserInfoCoreData.fetchRequest())
//        
//        if let data = data?.first {
//            return UserInfoData(userID: data.userID, loginToken: data.loginToken, nickname: data.nickname, fuID: data.fuID)
//        }
//        return nil
//    }
//    
//    //NSManagedObject:UserInfoCoreData
////    func getEntity(obj: NSManagedObject.Type)-> (NSManagedObject.self)?{ //프로토콜로 안되남..
//    func getEntity()-> UserInfoCoreData?{
//        let request = UserInfoCoreData.fetchRequest()//obj.fetchRequest()//
////        request.fetchLimit = 1
//
//        let context = self.container.viewContext
//        let entity = try? context.fetch(request).first
//        return entity
//    }
//    
//    func deleteData(){
//        let context = self.container.viewContext
//        
//        if let entity = self.getEntity(){
//            context.delete(entity)
//        }
//        
//        self.saveContext()
//    }
//    
//    //context에 넣어진 데이터 저장
//    func saveContext(){
//        let context = container.viewContext
//        
//        do{
//            try context.save()
//        }catch let e{
//            context.rollback()
//            fatalError("Error: \(e.localizedDescription)")
//        }
//    }
//    
//
//}
//
////struct ContentView: View {
////    @EnvironmentObject var userManager: UserDataManager
////
////    var body: some View {
////        if let nickname = userManager.nickname {
////            Text("Welcome, \(nickname)")
////        } else {
////            LoginView()
////        }
////    }
////}
////
////struct LoginView: View {
////    @EnvironmentObject var userManager: UserDataManager
////    @State private var username = ""
////
////    var body: some View {
////        VStack {
////            TextField("Username", text: $username)
////            Button("Log in") {
////
////                userManager.saveUserData(nickname: username)
////            }
////        }
////    }
////}
//
//
////실사용 예제
//
////struct ExampleView: View {
////    @Environment(\.managedObjectContext) private var viewContext
////
////    @FetchRequest(
////        sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.userID, ascending: true)],
////        animation: .default)
////    private var items: FetchedResults<UserEntity>
////
////    var body: some View {
////        Text("fff")
////    }
////}
