import Foundation
import TrueMotionCommon
import RxSwift

class ReactiveViewModel {

    let todoList: Observable<[TodoItemViewModel]>
    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
        self.todoList = repository.todoList.map {
            $0.map { todoModel in
                TodoItemViewModel(title: todoModel.title)
            }
        }.observeOn(MainScheduler.instance)
    }

    func refresh() -> Completable {
        return repository.refresh(userId: 1).observeOn(MainScheduler.instance)
    }
}

