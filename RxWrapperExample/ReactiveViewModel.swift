import Foundation
import TrueMotionCommon
import RxSwift

class ReactiveViewModel {

    let todoList: Observable<[TodoItemViewModel]>
    private let repository: TodoRepository
    private let disposeBag = DisposeBag()

    init(repository: TodoRepository) {
        self.repository = repository
        self.todoList = repository.todoList.map {
            $0.map { todoModel in
                TodoItemViewModel(title: todoModel.title)
            }
        }.observeOn(MainScheduler.instance)
    }

    func refresh() {
        repository.refresh(userId: 1).subscribe().disposed(by: disposeBag)
    }
}

