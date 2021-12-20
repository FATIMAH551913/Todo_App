//
//  ToDosVC.swift
//  ToDoList(online)
//
//  Created by Fatimah Ayeidh (فاطمة عايض) on 13/05/1443 AH.
//

import UIKit
import CoreData





class ToDosVC: UIViewController{
    
    
    @IBOutlet weak var todosTableView: UITableView!
    
    var todoArray:[ToDo] = []
    
    override func viewDidLoad() {
        self.todoArray = getTodos()
        super.viewDidLoad()
       
        // شرح عن  الايرور هاندل
        var m = Math()
        
        do {
            var r = try m.divide(num1: 40, num2: 0)
            print(r)
        }catch{
            let alert = UIAlertController(title: "Error", message: "can't devide by zero", preferredStyle: .alert)
            
            let Action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(Action)
            present(alert, animated: true, completion: nil)
        }// ينتهي الشرح هنا
        
        
        
        // New Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(addNewToDo), name: NSNotification.Name(rawValue: "AddedToDo")  , object: nil)
        // Eidt Todo notification
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentToDoedited), name: NSNotification.Name(rawValue: "CurrentToDoedited"), object: nil)
        // Delete Todo notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: NSNotification.Name(rawValue: "DeletToDo"), object: nil)
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
    }
    
    
    
    
    @objc func addNewToDo(notification : Notification){
        //     print("helow world")
        //     print(notification.userInfo!["AddedToDo"]) //انا هنا وصلت للفاليو (القيمة)
        if let mytodo = notification.userInfo?["AddedToDo"] as? ToDo {
            todoArray.append(mytodo)
            //            print(todoArray.count)
            todosTableView.reloadData()
            storeTodo(todo: mytodo)
        }
        
        
    }
    
    @objc func CurrentToDoedited(notification:Notification){
        if let td = notification.userInfo?["editedTodo"] as? ToDo {
            if let index = notification.userInfo?["editedTodoIndex"] as? Int {
                todoArray[index] = td
                todosTableView.reloadData()
            updateTodo(todo: td, index: index)
                
            }
        }
    }
    
    @objc func todoDeleted(notification:Notification){
        
        if let index = notification.userInfo?["deletIndex"] as? Int {
            todoArray.remove(at: index)
            todosTableView.reloadData()
            deleteTodo(index: index)
            
        }
        
    }
}



extension ToDosVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as!  ToDoCell
        
        cell.todoTitleLable.text = todoArray[indexPath.row].title
        
        if todoArray[indexPath.row].img != nil {
            cell.todoImgView.image = todoArray[indexPath.row].img
        } else {
            cell.todoImgView.image = UIImage(named: "15")
        }
        
        // ابي اخلي الصورة الدايرية
        cell.todoImgView.layer.cornerRadius = cell.todoImgView.frame.width / 2
        
        return cell
    }
    //تعطيني تفاصيل الصفحة لمن نضغط عليها
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // فايدة هذي الدالة تخفي التظليل من الخلية الي نضغطها
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //        print("Hellow World")
        //اسوي اوبجت من vc.
        let todoo = todoArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ToDoDetailsVC") as? ToDoDetailsVC
        
        if let viewController = vc {
            viewController.Todo = todoo // يعتمد علي المكان الي انضغط بالشريحة
            viewController.index = indexPath.row // نمرر الاندكس من صفحة التفاصيل
            
            //        present(viewController, animated: true, completion: nil)
            
            navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    func storeTodo(todo:ToDo) {
        //Refer to persistentContainer from appdelegate
        guard let appdeleget = UIApplication.shared.delegate as? AppDelegate else {return}
       
        //بكون جبنا مانجدكونتكست
    // يشير الي قاعدة البيانات
        //Create the context from persistentContainer
        let manageContext = appdeleget.persistentContainer.viewContext
        // نجيب القوالب الانتتي
        //Create new record with this User Entity
        guard  let todoentity = NSEntityDescription.entity(forEntityName: "Todo", in: manageContext)else {return}
        //Set values for the records for each key
        let todoObjectentity = NSManagedObject.init(entity: todoentity, insertInto: manageContext)
        todoObjectentity.setValue(todo.title, forKey: "title")
        todoObjectentity.setValue(todo.details, forKey: "details")
        // forkey from antity at Model
        do {
            try manageContext.save()
            print("======success=========")
        }catch{
            print("======error=========")
        }
        
    }
        func updateTodo(todo:ToDo ,index: Int){
            guard let appdeleget = UIApplication.shared.delegate as? AppDelegate  else {return}
             let mangContext = appdeleget.persistentContainer.viewContext
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            
            do {
               let result =  try mangContext.fetch(fetchRequest) as! [NSManagedObject]
            
                result[index].setValue(todo.title, forKey: "title")
                result[index].setValue(todo.details, forKey: "details")
                
                    try mangContext.save()
               
            }catch{
                
                print("======error=========")
            }
                 
        }
        
    }
    
    
    func deleteTodo(index: Int){
        guard let appdeleget = UIApplication.shared.delegate as? AppDelegate  else {return}
         let mangContext = appdeleget.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
           let result =  try mangContext.fetch(fetchRequest) as! [NSManagedObject]
        
         let todoToDelete = result[index]
            mangContext.delete(todoToDelete)
            
                try mangContext.save()
           
        }catch{
            
            print("======error=========")
        }
             
    }
    

    
    
    // فقط ترجع ارري الي نبغاها
    func getTodos() -> [ToDo] {
        var toodoo: [ToDo] = []
       guard let appdeleget = UIApplication.shared.delegate as? AppDelegate  else {return
          []}
        let mangContext = appdeleget.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
           let result =  try mangContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for managedTodo in result {
                print(managedTodo)
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                let todo = ToDo(title: title ?? "" , img: nil , details: details ?? "")
                toodoo.append(todo)
            }
        }catch{
            print("======error=========")
        }
        return toodoo
    
    }


