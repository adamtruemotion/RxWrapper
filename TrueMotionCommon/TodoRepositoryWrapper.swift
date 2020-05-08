import Foundation
import RxSwift
import TrueMotionCore

public protocol TodoRepositoryWrapper: class, MulticastDelegate where T == TodoRepositoryWrapperDelegate {
    func refresh(userId: Int, completionHandler: ((Result<Void, Error>) -> Void)?)
}

public protocol TodoRepositoryWrapperDelegate: class {
    func todoListChanged(list: [TodoModel])
}

public class TodoRepositoryWrapperImpl: MulticastDelegateImpl<TodoRepositoryWrapperDelegate>, TodoRepositoryWrapper {

    private let repository: TodoRepository
    private let disposeBag = DisposeBag()

    init(repository: TodoRepository) {
        self.repository = repository
        super.init()
        repository.todoList.subscribe(onNext: {[weak self] list in
            self?.invoke(invocation: { delegate in
                delegate.todoListChanged(list: list)
            })
        }).disposed(by: disposeBag)
    }

    public func refresh(userId: Int, completionHandler: ((Result<Void, Error>) -> Void)?) {
        repository.refresh(userId: userId).subscribe(onCompleted: {
            completionHandler?(.success(()))
        }) { (error) in
            completionHandler?(.failure(error))
        }.disposed(by: disposeBag)
    }
}
