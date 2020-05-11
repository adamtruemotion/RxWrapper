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
    private var timer: Timer?

    init(repository: TodoRepository) {
        self.repository = repository
        super.init()
        print("RW init")
        repository.todoList.subscribe(onNext: {[weak self] list in
            print("RW list onNext")
            self?.invoke(invocation: { delegate in
                delegate.todoListChanged(list: list)
            })
        },
      onError: {_ in
          print("RW list error")
      }).disposed(by: disposeBag)
    }

    deinit {
        print("RW deinit")
    }
    public func refresh(userId: Int, completionHandler: ((Result<Void, Error>) -> Void)?) {
        repository.refresh(userId: userId).subscribe(onCompleted: {
            print("RW refresh on completed")
            completionHandler?(.success(()))
        }) { (error) in
            print("RW refresh error")
            completionHandler?(.failure(error))
        }.disposed(by: disposeBag)
    }
}
