//
//  NewToDoVC.swift
//  ToDoList(online)
//
//  Created by Fatimah Ayeidh (فاطمة عايض) on 14/05/1443 AH.
//

import UIKit

class NewToDoVC: UIViewController {
    
    var isCreation = true
    var editedToDo: ToDo?
    var editedTodoIndex:Int?
    
    @IBOutlet weak var todoImgView: UIImageView!
    @IBOutlet weak var mainEditBtn: UIButton!
    @IBOutlet weak var titleToDoTF: UITextField!
    @IBOutlet weak var detailsTodoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isCreation {
            mainEditBtn.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل المهمة"
            
            if let todo = editedToDo {
                titleToDoTF.text = todo.title
                detailsTodoTextView.text = todo.details
                todoImgView.image = todo.img
                
            }
        }
    }
    @IBAction func changeBtnClicked(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        
        present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func AddNewToDoBtn(_ sender: Any) {
        if isCreation {
            let todo = ToDo(title: titleToDoTF.text!, img: todoImgView.image
                            , details: detailsTodoTextView.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddedToDo"), object: nil , userInfo: ["AddedToDo":todo])
            //  message
            
            let alertController = UIAlertController(title: " تم الاضافة بنجاح", message:
                                                        " تأكيد الاضافة", preferredStyle:                     UIAlertController.Style.actionSheet)            // ok , cancel
            alertController.addAction(UIAlertAction(
                title: "نعم ",
                style: UIAlertAction.Style.default,
                handler: { Action in
                    // موضعه هنا ماراح ينقلك لحد ماتضغط نعم
                    self.tabBarController?.selectedIndex = 0
                    // الفايدة من هالكود لمن ارجع اكتب مهمة جديدة يكون انمسح الاكلام الاول ويكون التكست فيلد فاضي
                    self.titleToDoTF.text = ""
                    self.detailsTodoTextView.text = ""
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
            
            
        } else { // else, if the view controller is opend for edit (not for create)
            
            let todo = ToDo(title: titleToDoTF.text!, img: todoImgView.image, details: detailsTodoTextView.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentToDoedited"), object: nil , userInfo: ["editedTodo":todo , "editedTodoIndex" : editedTodoIndex]) // add index to notfication
            
            let alertController = UIAlertController(title: " تم التعديل بنجاح", message:
                                                        " تأكيد التعديل", preferredStyle:                     UIAlertController.Style.alert)            // ok , cancel
            alertController.addAction(UIAlertAction(
                title: "نعم ",
                style: UIAlertAction.Style.default,
                handler: { Action in
                    // موضعه هنا ماراح ينقلك لحد ماتضغط نعم
                    self.navigationController?.popViewController(animated: true)
                    // الفايدة من هالكود لمن ارجع اكتب مهمة جديدة يكون انمسح الاكلام الاول ويكون
                    
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
        
    }
    
}
extension NewToDoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        
        dismiss(animated: true, completion: nil)
        todoImgView.image = image
    }
    
    
}
