//
//   Math.swift
//  ToDoList(online)
//
//  Created by Fatimah Ayeidh (فاطمة عايض)on 15/05/1443 AH.
//

import Foundation
//هذا الكلاس نسوي علشان نستدعي اي ملف ابغى

class DivBy0Error : Error {
    
}

class Math {
    func divide(num1: Int , num2: Int) throws -> Int {
        
        if num2 == 0 {
            let error = DivBy0Error()
            throw error
        }
        return num1 / num2
    }
    
}
// بدل ما اعالج الخطا في الداله نفسها ويصير كرش ويخرجك من البرنامج هذي الدالة تساعدني في اظهار اليرت للمستخدم باظهار الايررور
