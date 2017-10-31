//: Playground - noun: a place where people can play

import UIKit

struct Persone{
    var name: String
    var age: Int
}

// MVC
class DetailController: UIViewController{
    var persone: Persone!
    var someButton: UIButton = UIButton()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        persone = Persone(name: "Mark", age: 29)

        someButton.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
    }

    @objc func didTapButton(){
        label.text = ""
    }
}

let model = Persone(name: "Make", age: 12)
let view = DetailController()
let controller = DetailController()

// MVP

protocol DetailView: class{
    func setUserName(name: String)
}

protocol DetailViewPresenter{
    init(detailView: DetailView, persone: Persone)
    func showUserName()
}

class DetailPresenter: DetailViewPresenter{
    weak var view: DetailView?
    let persone: Persone

    required init(detailView: DetailView, persone: Persone) {
        self.view = detailView
        self.persone = persone
    }

    func showUserName() {
        view?.setUserName(name: persone.name)
    }
}

class DetailViewController: UIViewController, DetailView{
    var presenter: DetailPresenter!
    var someButton: UIButton = UIButton()

    let nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        someButton.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
    }

    //MARK: Custom methods
    @objc func didTapButton(){
        presenter.showUserName()
    }

    //MARK: DetailView protocol methods
    func setUserName(name: String) {
        nameLabel.text = name
    }
}

let mvpModel = Persone(name: "", age: 12)
let mvpView = DetailViewController()
let mvpPresenter = DetailPresenter(detailView: mvpView, persone: mvpModel)
mvpView.presenter = mvpPresenter

//MVVM

protocol DetailViewModelDelegate: class{
    var name: String?{get}
    var nameDidChangeDelegate:((DetailViewModelDelegate) -> ())? {get set}

    init(persone: Persone)

    func showUserName()
}

class DetailViewModel: DetailViewModelDelegate{
    let persone: Persone!

    var name: String?{
        didSet{
            self.nameDidChangeDelegate?(self)
        }
    }

    var nameDidChangeDelegate: ((DetailViewModelDelegate) -> ())?

    required init(persone: Persone) {
        self.persone = persone
    }


    func showUserName() {
        self.name = persone.name
    }
}

class DDetailViewController: UIViewController{
    let nameLabel = UILabel()

    var viewModel: DetailViewModel?{
        didSet{
            self.viewModel?.nameDidChangeDelegate = {[weak self] viewModel in
                self?.nameLabel.text = self?.viewModel?.name
            }
        }
    }

    var someButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        someButton.addTarget(viewModel, action: #selector(self.didTapButton), for: .touchUpInside)
    }

    //MARK: Custom methods
    @objc func didTapButton(){

    }

}

