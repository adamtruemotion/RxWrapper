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

    init(repository: TodoRepository) {
        self.repository = repository
        repository.todoList.subscribe(onNext: {[weak self] list in
            self?.todoListChanged?(list.map { TodoModel(id: $0.id, title: $0.title, completed: $0.completed) })
        }).disposed(by: disposeBag)
    }
    
    func refresh(userId: Int, completionHandler: ((Result<Void, Error>) -> Void)?) {
        repository.refresh(userId: userId).subscribe(onCompleted: {
            completionHandler?(.success(()))
        }) { (error) in
            completionHandler?(.failure(error))
        }.disposed(by: disposeBag)
    }
    
}
