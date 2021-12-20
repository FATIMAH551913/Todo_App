//
//  ToDoDetailsVC.swift
//  ToDoList(online)
//
//  Created by Fatimah Ayeidh (فاطمة عايض) on 13/05/1443 AH.
//

import UIKit

class ToDoDetailsVC: UIViewController {
    
    //راح اعرف todo التي يتم ارسالها من الشاشة السابقة
    var Todo: ToDo!
    // for editing:
    var index : Int!
    
    @IBOutlet weak var todoTextDetailsLbl: UILabel!
    @IBOutlet weak var todoTitleDetailsLbl: UILabel!
    @IBOutlet weak var todoImgView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Todo.img != nil {
            todoImgView.image = Todo.img
        }else {
            todoImgView.image = UIImage(named: "15")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentToDoedited), name: NSNotification.Name(rawValue: "CurrentToDoedited"), object: nil)
        
        
        setupUI()
        
    }
    @IBAction func deleteButtonClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeletToDo"), object: nil, userInfo: ["deletIndex": index])
        
        let alertController = UIAlertController(title: " تم التعديل بنجاح", message:
                                                    " تأكيد التعديل", preferredStyle:                     UIAlertController.Style.alert)            // ok , cancel
        alertController.addAction(UIAlertAction(
            title: "نعم ",
            style: UIAlertAction.Style.destructive,  //destructive red text for remove
            handler: { Action in
                // موضعه هنا ماراح ينقلك لحد ماتضغط نعم
                self.navigationController?.popViewController(animated: true)
                // الفايدة من هالكود لمن ارجع اكتب مهمة جديدة يكون انمسح الاكلام الاول ويكون التكست فيلد فاضي
                
            }
        ))
        
        alertController.addAction(UIAlertAction(
            title: "لا ",
            style: UIAlertAction.Style.cancel,
            handler: { Action in
            }
        ))
        //present
        present( alertController, animated: true) {
            
            
            
        }
        
    }
    
    @IBAction func editToDoBtn(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NewToDoVC") as? NewToDoVC {
            
            viewController.isCreation = false
            viewController.editedToDo = Todo
            viewController.editedTodoIndex = index
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    @objc func CurrentToDoedited(notification:Notification){
        if let td = notification.userInfo?["editedTodo"] as? ToDo {
            self.Todo = td
            setupUI()
            
        }
    }
    
    // كان ضروري اخلي سيت اب تحت الفنكشن الي استدعيها فيها مباشرة
    func setupUI(){
        todoTextDetailsLbl.text = Todo.details
        todoTitleDetailsLbl.text = Todo.title
        todoImgView.image = Todo.img
        
        
    }
    
}
