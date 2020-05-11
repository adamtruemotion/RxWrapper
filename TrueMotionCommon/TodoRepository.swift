import Foundation
import TrueMotionCore
import RxSwift

public protocol TodoRepository {
    func refresh(userId: Int) -> Completable
    var todoList: Observable<[TodoModel]> { get }
}

class TodoRepositoryImpl: TodoRepository {

    lazy private(set) var todoList: Observable<[TodoModel]> = todoListSubject.asObservable()
    private let todoListSubject = BehaviorSubject<[TodoModel]>(value: [])
    private let networkService: NetworkService = TMCore.networkService

    private var timer: Timer?
    private let disposeBag = DisposeBag()
    
    func refresh(userId: Int) -> Completable {
        let request: Single<[TodoModel]> = networkService.request(
            type: [TodoModel].self,
            endpoint: URL(string: "https://jsonplaceholder.typicode.com/users/1/todos")!,
            method: "GET"
        )
        .map {
            $0.map {(model) in
                TodoModel(id: model.id, title: model.title, completed: model.completed)
            }
        }
        .do(onSuccess: {[weak self] in
            print("Repository onSuccess side effect")
            self?.todoListSubject.onNext($0)
        }, onError: {_ in
            print("Repository onError side effect")
        })
        return request.asCompletable()
    }
}
