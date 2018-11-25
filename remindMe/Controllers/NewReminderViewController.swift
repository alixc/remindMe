//
//  NewReminderViewController.swift
//  remindMe
//
//  Created by Yves Songolo on 11/23/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit

class NewReminderViewController: UIViewController {

    // - Mark: Properties
    var titleLabel: CustomLabel!
    var reminderNameTextFiled: CustomTextField!
    var reminderDescriptionTextView: UITextView!
    var typeEntryButton: CustomButton!
    var typeExitButton: CustomButton!
    var saveButton: CustomButton!
    var typeLabel: CustomLabel!
    var dateTimeLabel: CustomLabel!
    var dayPickerView: UIPickerView!
    var timeFromPickerView: UIDatePicker!
    var timeToPickerView: UIDatePicker!
    var doneButton: CustomButton!
    var mainView: UIView!
    var userGroup: Group!
    var newReminder: Reminder!
    var eventType = EventType.onEntry
    
    var pickedDay: String = "Monday"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        setupMainView()
        setupTitle()
        setupReminderTextField()
        setupTypeButton()
        setUpDateTimeLabel()
        setupDateSelectionPicker()
        setupDescriptionTextView()
        setupDoneButton()
        addSwipeToDismis()
    }
    
    func setupMainView(){
      
        mainView = UIView(frame: view.frame)
       view.addSubview(mainView)
        mainView.anchor(top: view.topAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        paddingTop: view.frame.height/10,
                        paddingLeft: 15,
                        paddingBottom: view.frame.height/10,
                        paddingRight: 15,
                        width: 0,
                        height: 0,
                        enableInsets: true)
        
        mainView.backgroundColor = UIColor.white
        mainView.layer.masksToBounds = false
        mainView.layer.cornerRadius = 10
    }
    
    func setupTitle(){
        titleLabel = CustomLabel(fontSize: 20, text: "New \(userGroup.name) Reminder", textColor: #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1))
        mainView.addSubview(titleLabel)
        titleLabel.anchor(top: mainView.topAnchor,
                          left: mainView.leftAnchor,
                          bottom: nil,
                          right: mainView.rightAnchor,
                          paddingTop: 10,
                          paddingLeft: 0,
                          paddingBottom: 0,
                          paddingRight: 0,
                          width: 0,
                          height: 0,
                          enableInsets: true)
        titleLabel.textAlignment = .center
    }
    

    func setupReminderTextField(){
        reminderNameTextFiled = CustomTextField(placeHolder: "Title", border: 1, cornerRadius: 5, borderColor: #colorLiteral(red: 0.07895455509, green: 0.1626217663, blue: 0.2949268222, alpha: 1), textColor: #colorLiteral(red: 0.07895455509, green: 0.1626217663, blue: 0.2949268222, alpha: 1), alignment: .left, borderStyle: .none)
        
        mainView.addSubview(reminderNameTextFiled)
        reminderNameTextFiled.anchor(top: titleLabel.bottomAnchor,
                                     left: mainView.leftAnchor,
                                     bottom: nil,
                                     right: mainView.rightAnchor,
                                     paddingTop: 30,
                                     paddingLeft: 10,
                                     paddingBottom: 0,
                                     paddingRight: 10,
                                     width: mainView.frame.width - 10,
                                     height: 0,
                                     enableInsets: true)
    
    }
    func setupTypeButton(){
        typeEntryButton = CustomButton(title: "Entry", fontSize: 12, titleColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), target: self, action: #selector(selectTypeButtonTapped(sender:)), event: .touchUpInside)
        typeEntryButton.tag = 1
        
        typeExitButton =  CustomButton(title: "Exit", fontSize: 12, titleColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), target: self, action: #selector(selectTypeButtonTapped(sender:)), event: .touchUpInside)
        typeExitButton.tag = 2
        
        dateTimeLabel = CustomLabel(fontSize: 14, text: "Reminder Type: ", textColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        
       
        let buttomStack = CustomStack.init(subview: [typeEntryButton,typeExitButton], alignment: .center, axis: .horizontal, distribution: .fillEqually)
        buttomStack.spacing = 10
        
         let stack = CustomStack(subview: [dateTimeLabel,buttomStack], alignment: .fill, axis: .horizontal, distribution: .fill)
        
        mainView.addSubview(stack)
        
        stack.anchor(top: reminderNameTextFiled.bottomAnchor,
                     left: mainView.leftAnchor,
                     bottom: nil,
                     right: mainView.rightAnchor,
                     paddingTop: 20,
                     paddingLeft: 10,
                     paddingBottom: 0,
                     paddingRight: 10,
                     width: 0,
                     height: 0,
                     enableInsets: true)
        dateTimeLabel.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5).isActive = true
   
        typeEntryButton.newLayerColor = #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1)
        typeEntryButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        typeExitButton.newLayerColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        typeExitButton.setTitleColor(#colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1), for: .normal)
    
    }
    
    func setUpDateTimeLabel(){
        let stack = mainView.subviews.last
        dateTimeLabel = CustomLabel(fontSize: 18, text: "Date and Time", textColor: #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1))
        mainView.addSubview(dateTimeLabel)
        dateTimeLabel.anchor(top: stack?.bottomAnchor,
                             left: mainView.leftAnchor,
                             bottom: nil,
                             right: mainView.rightAnchor,
                             paddingTop: 20,
                             paddingLeft: 10,
                             paddingBottom: 0,
                             paddingRight: 10,
                             width: 0,
                             height: 0,
                             enableInsets: true)
    }
    func  setupDateSelectionPicker(){
        
        dayPickerView = UIPickerView()
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
        timeFromPickerView = UIDatePicker()
        timeFromPickerView.datePickerMode = .time
        
        timeToPickerView = UIDatePicker()
        timeToPickerView.datePickerMode = .time
        
        let every = CustomLabel(fontSize: 12, text: "Every", textColor: #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1))
        every.textAlignment = .center
        let from = CustomLabel(fontSize: 12, text: "From", textColor: #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1))
        from.textAlignment = .center
    
        let to = CustomLabel(fontSize: 12, text: "To", textColor: #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1))
        to.textAlignment = .center
        
        let dayPickerStack = CustomStack.init(subview: [every,dayPickerView], alignment: .center, axis: .vertical, distribution: .fillProportionally)
         let timeFromStack = CustomStack.init(subview: [from,timeFromPickerView], alignment: .center, axis: .vertical, distribution: .fillProportionally)
        
         let timeToStack = CustomStack.init(subview: [to,timeToPickerView], alignment: .center, axis: .vertical, distribution: .fillProportionally)
        
        
                let stack = CustomStack(subview: [dayPickerStack,timeFromStack,timeToStack], alignment: .center, axis: .horizontal, distribution: .fill)
                mainView.addSubview(stack)
        
                stack.anchor(top: dateTimeLabel.bottomAnchor,
                             left: mainView.leftAnchor,
                             bottom: nil,
                             right: mainView.rightAnchor,
                             paddingTop: 10,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0,
                             enableInsets: true)
        
        dayPickerStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.2).isActive = true
        timeToStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.4).isActive = true
        
        timeFromStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.4).isActive = true
    }
    
    func setupDescriptionTextView(){
        reminderDescriptionTextView = UITextView()
        let stack = mainView.subviews.last
        let descriptionLabel = CustomLabel(fontSize: 12, text: "Description", textColor: #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1))
        let descStack = CustomStack(subview: [descriptionLabel,reminderDescriptionTextView], alignment: .leading, axis: .vertical, distribution: .fill)
        mainView.addSubview(descStack)
        descriptionLabel.heightAnchor.constraint(equalTo: descStack.heightAnchor, multiplier: 0.2).isActive = true
        reminderDescriptionTextView.heightAnchor.constraint(equalTo: descStack.heightAnchor, multiplier: 0.8).isActive = true
        
         reminderDescriptionTextView.widthAnchor.constraint(equalTo: descStack.widthAnchor, multiplier: 1).isActive = true
        reminderDescriptionTextView.layer.masksToBounds = false
        reminderDescriptionTextView.layer.cornerRadius = 10
        
        reminderDescriptionTextView.text = ""
        reminderDescriptionTextView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.09685359589)
        descStack.anchor(top: stack?.bottomAnchor,
                                            left: mainView.leftAnchor,
                                            bottom: nil,
                                            right: mainView.rightAnchor,
                                            paddingTop: 5,
                                            paddingLeft: 10,
                                            paddingBottom: 0,
                                            paddingRight: 10,
                                            width: 0/*mainView.frame.width - 10*/,
                                            height: mainView.frame.height / 6,
                                            enableInsets: true)
        
    }
    
    func setupDoneButton(){
        saveButton = CustomButton(title: "Save", fontSize: 12, titleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), target: self, action: #selector(actionButtonTapped(sender:)), event: .touchUpInside)
        saveButton.newLayerColor = #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1)
        let stack = mainView.subviews.last
        
        mainView.addSubview(saveButton)
        
        saveButton.anchor(top: stack?.bottomAnchor,
                          left: mainView.leftAnchor,
                          bottom: nil,
                          right: mainView.rightAnchor,
                          paddingTop: 30,
                          paddingLeft: mainView.frame.width / 4,
                          paddingBottom: 0,
                          paddingRight:  mainView.frame.width / 4,
                          width: 0,
                        height: 0,
            enableInsets: true)
    }
    
    @objc func actionButtonTapped(sender: CustomButton){
       
        
        let timeFrom = timeFromPickerView.date.timeToString()
        let timeTo = timeToPickerView.date.timeToString()
        guard let title = reminderNameTextFiled.text else {
            self.presentAlert(title: "No Title", message: "Reminder need a title")
            return
        }
        if title.count < 2{
            self.presentAlert(title: "No Title", message: "Reminder need a title")
            return
        }
        var reminder = Reminder.init(groupId: userGroup.id, id: "", name: title, type: eventType, day: pickedDay, longitude: userGroup.longitude, latitude: userGroup.latitude, timeFrom: timeFrom, timeTo: timeTo)
        guard let desc = reminderDescriptionTextView.text else {
            self.presentAlert(title: "No Description", message: "Reminder need a description")
            return
        }
        if desc.count < 2{
            self.presentAlert(title: "No Description", message: "Reminder need a description")
            return
        }
        
        reminder.description = desc
        
        ReminderServices.create(reminder) {
            DispatchQueue.main.async {
                
                 self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    func addSwipeToDismis() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMainViewDragged(_:)))
        mainView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleMainViewDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        if gestureRecognizer.state == .ended{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectTypeButtonTapped(sender: CustomButton){
        
        switch sender.tag{
        case 1:
            typeEntryButton.newLayerColor = #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1)
            typeEntryButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            typeExitButton.newLayerColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            typeExitButton.setTitleColor(#colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1), for: .normal)
            eventType = EventType.onEntry
        case 2:
            typeEntryButton.newLayerColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            typeEntryButton.setTitleColor(#colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1), for: .normal)
            
            typeExitButton.newLayerColor = #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1)
            typeExitButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
             eventType = EventType.onExit
            
        default: break
        }
    }
  
}




/// extension to handle picker view data source
extension NewReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return Constant.days.count
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.pickedDay = Constant.days[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Rockwell", size: 14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Constant.days[row]
        pickerLabel?.textColor = #colorLiteral(red: 0.1803921569, green: 0.368627451, blue: 0.6666666667, alpha: 1)
        return pickerLabel!
    }
    
}
