import Foundation
import RxSwift

public protocol TodoRepositoryAdapter: class {
    var todoListChanged: (([TodoModel]) -> Void)? { get set }
    func refresh(userId: Int, completionHandler: ((Result<Void, Error>) -> Void)?)
}

class TodoRepositoryAdapterImpl: TodoRepositoryAdapter {

    var todoListChanged: (([TodoModel]) -> Void)?
    var disposeBag = DisposeBag()
    let repository: TodoRepository
    let name: String

    init(repository: TodoRepository, name: String) {
        self.repository = repository
        self.name = name
        repository.todoList.subscribe(onNext: {[unowned self] list in
            print("\(self.name) list onNext")
            self.todoListChanged?(list.map { TodoModel(id: $0.id, title: $0.title, completed: $0.completed) })
        },
        onError: {[unowned self] _ in
            print("\(self.name) list error")
        }).disposed(by: disposeBag)
    }

    deinit {
         print("\(self.name) deinit")
    }
    func refresh(userId: Int, completionHandler: ((Result<Void, Error>) -> Void)?) {
        repository.refresh(userId: userId).subscribe(onCompleted: {[unowned self] in
            print("\(self.name) refresh completion")
            completionHandler?(.success(()))
        }, onError: { error in
            print("\(self.name) refresh failure")
            completionHandler?(.failure(error))
        }).disposed(by: disposeBag)
    }
    
}
