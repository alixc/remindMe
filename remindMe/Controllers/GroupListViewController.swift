//
//  GroupListViewController.swift
//  remindMe
//
//  Created by Medi Assumani on 9/18/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//


import Foundation
import UIKit

class GroupListViewController: UIViewController{
// This View Controller class handles functionality to show the list of all the groups

    
    // Stack views variables
    var remindersDataStackView = UIStackView()
    var totalRemindersStackView = UIStackView()
    var totalRemindersOnEntryStackView = UIStackView()
    var totalRemindersOnExitStackView = UIStackView()
    var tableViewStackView = UIStackView()
    
    // UI Elements variables
    var totalRemindersBox = UIView()
    var totalRemindersOnEntryBox =  UIView()
    var totalRemindersOnExitBox = UIView()
    var totalReminderAmountLabel = UILabel()
    var totalReminderTextView = UITextView()
    var totalRemindersOnEntryAmountLable = UILabel()
    var totalRemindersOnEntryTextView = UITextView()
    var totalRemindersOnExitAmountLable = UILabel()
    var totalRemindersOnExitTextView = UITextView()
    
    

    let networkManager = NetworkManager.shared
    var userGroups = [Group](){
        didSet {
            DispatchQueue.main.async {
                self.groupListTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Set up
        self.view.backgroundColor = .white
        setUpNavigationBarItems()
        self.groupListTableView.delegate = self as? UITableViewDelegate
        self.groupListTableView.dataSource = self as? UITableViewDataSource
        groupListTableView.register(GroupListTableViewCell.self, forCellReuseIdentifier: Constant.groupTableViewCellIdentifier)
        //createDummyData()


        addViews()
        createRectangularViews()
        createCustomRemindersLabels()
        anchorTableView()
        anchorRemindersDataContainer()
        anchorTableViewContainer()
        anchorRemindersDataStackView()
        anchorTotalRemindersStackView()
        anchorEntriesReminderStackView()
        anchorExitReminderStackView()
        
        updateReminderLabels()
        fetchAllGroups()
        
        
        // Newtork set up
        
        //fetchAllGroups()
        //monitorReminders()

//        networkManager.reachability.whenUnreachable = { reachability in
//            self.showOfflinePage()
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DispatchQueue.main.async {
//            self.groupTableView.reloadData()
//        }
    }
    
    
//    fileprivate func showOfflinePage(){
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: Constant.offlinePageSegueIdentifier, sender: self)
//        }
//    }
    
    /// Makes api call and get all teh groups created by the user
    internal func fetchAllGroups(){
        GroupServices.index(completion: { (groups) in
            self.userGroups = groups!
        })
    }
    
    
    /// Updates all the reminders labels with proper numbers
    internal func updateReminderLabels(){
        var entryCounter = 0
        var exitCounter = 0
        var totalRemindersCountter = 0
        ReminderServices.index { (reminders) in
            guard let reminders = reminders else {return}
            
            reminders.forEach({ (reminder) in
                if reminder.type?.rawValue == "Entry" || reminder.type?.rawValue == "entry"{
                    entryCounter += 1
                    totalRemindersCountter += 1
                }else if  reminder.type?.rawValue == "Exit" || reminder.type?.rawValue == "exit"{
                    exitCounter += 1
                    totalRemindersCountter += 1
                }
            })
            
            DispatchQueue.main.async {
                self.totalRemindersOnEntryAmountLable.text = entryCounter.convertIntToString()
                self.totalRemindersOnExitAmountLable.text = exitCounter.convertIntToString()
                self.totalReminderAmountLabel.text = reminders.count.convertIntToString()
            }
        }
    }
    
    
    
//    fileprivate func monitorReminders(){
//        ReminderServices.index { (reminders) in
//            guard let reminders = reminders else {return}
//            GeoFence.shared.startMonitor(reminders, completion: { (true) in
//                print("Start Monitoring")
//            })
//        }
//    }

    // - MARK: MANUAL NAVIGATION
    
    /// Sets up home page title and nav bar items
    fileprivate func setUpNavigationBarItems(){

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

        // Styling the home page title
        titleLabel.text = "My Groups"
        titleLabel.textColor = .gray
        titleLabel.font = UIFont(name: "Rockwell", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.adjustsFontSizeToFitWidth = true
        
        // Styling the home page navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroupButtonTapped))
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.alpha = 0.0
    }
    
    ///
    @objc fileprivate func addGroupButtonTapped(){
        
        
    }
    
    
    // - MARK: UI ELEMENTS AND METHODS
    
    
//    func createDummyData(){
//
//        userGroups.append(Group(id: "123", name: "Home", latitude: 40.7128, longitude: 74.0060))
//        userGroups.append(Group(id: "123", name: "Office", latitude: 40.7128, longitude: 74.0060))
//        userGroups.append(Group(id: "123", name: "Personal", latitude: 40.7128, longitude: 74.0060))
//        userGroups.append(Group(id: "123", name: "Random", latitude: 40.7128, longitude: 74.0060))
//
//    }
//
    // The light cyan colored rectangular container that holds the reminders boxes
    private let remindersContainer: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightCyan
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // The lyan cyan colored rectangular container that holds the table view
    private let tableViewContainer: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightCyan
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // The table view that will contains the list og groups
    private let groupListTableView: UITableView = {
        
        let tableview = UITableView()
        tableview.backgroundColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    
    
    
    /// Adds the view on top of the root view of the view controller
    fileprivate func addViews(){
        view.addSubview(remindersContainer)
        view.addSubview(tableViewContainer)
    }
    
    /// Instanciates three UIViews variables of box shape that are placed on top of the home page
    fileprivate func createRectangularViews(){
        
        totalRemindersBox = makeCustomReminderBox(bColor: .white, borderWidth: 1.0, borderColor: UIColor.lightBlue.cgColor, cornerRadius: 15, clipsToBound: true, maskToBounds: true, shadowRadius: 1)
        
        totalRemindersOnEntryBox = makeCustomReminderBox(bColor: .white, borderWidth: 1.0, borderColor: UIColor.gloomyGreen.cgColor, cornerRadius: 15, clipsToBound: true, maskToBounds: true, shadowRadius: 1)
        
        totalRemindersOnExitBox = makeCustomReminderBox(bColor: .white, borderWidth: 1.0, borderColor: UIColor.gloomyYellow.cgColor, cornerRadius: 15, clipsToBound: true, maskToBounds: true, shadowRadius: 1)
    }
    
    /// Instanciate the labels that go inside the reminder data boxes on top of the home page
    fileprivate func createCustomRemindersLabels(){
        
        let customTotaReminderslLabelsTuple = makeCustomReminderLabels(labelText: "0", labelColor: UIColor.black, textViewBody: "Total Reminders", textViewSize: 12, textViewBodyColor: UIColor.gray)
        
        let customEntryRemindersLabelsTuple = makeCustomReminderLabels(labelText: "0", labelColor: UIColor.black, textViewBody: "Total on entry", textViewSize: 12, textViewBodyColor: UIColor.gray)
        
        let customExitReminderlLabelsTuple = makeCustomReminderLabels(labelText: "0", labelColor: UIColor.black, textViewBody: "Total on exit", textViewSize: 12, textViewBodyColor: UIColor.gray)
        
        
        totalReminderAmountLabel = customTotaReminderslLabelsTuple.0
        totalReminderTextView = customTotaReminderslLabelsTuple.1
        
        totalRemindersOnEntryAmountLable = customEntryRemindersLabelsTuple.0
        totalRemindersOnEntryTextView = customEntryRemindersLabelsTuple.1
        
        totalRemindersOnExitAmountLable = customExitReminderlLabelsTuple.0
        totalRemindersOnExitTextView = customExitReminderlLabelsTuple.1
    }
    
    
    
    /* Creates a custom view through peroperties passed as parameters
     @param :
     @return
     */
    fileprivate func makeCustomReminderBox(bColor: UIColor, borderWidth: CGFloat, borderColor: CGColor, cornerRadius: CGFloat, clipsToBound: Bool, maskToBounds: Bool, shadowRadius: CGFloat ) -> UIView{
        
        let customView = UIView()
        customView.backgroundColor = bColor
        customView.layer.borderWidth = borderWidth
        customView.layer.borderColor = borderColor
        customView.layer.cornerRadius = cornerRadius
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }
    
    /* Creates a custom label and textview through peroperties passed as parameters
     @param :
     @return
     */
    fileprivate func makeCustomReminderLabels(labelText: String, labelColor: UIColor, textViewBody: String, textViewSize: Int, textViewBodyColor: UIColor) -> (UILabel, UITextView){
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = labelColor
        label.text = labelText
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        let textview = UITextView()
        let attributedText = NSMutableAttributedString(string: textViewBody,
                                                       attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
                                                                    NSAttributedString.Key.foregroundColor: UIColor.gray])
        textview.attributedText = attributedText
        textview.textAlignment = .center
        textview.isEditable = false
        textview.isScrollEnabled = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        
        return (label,textview)
    }
    
    
    /// Anchors the light cyan colored rectangular container that holds the 3 reminders boxes
    fileprivate func anchorRemindersDataContainer(){
        
        remindersContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 300, height: 150, enableInsets: false)
    }
    
    /// Anchors the outer conatainer view that holds the table view
    fileprivate func anchorTableViewContainer(){
        
        tableViewContainer.anchor(top: remindersContainer.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0, enableInsets: false)
    }
    
    
    /// Anchors the stackview that will hold the three reminders squared boxes
    fileprivate func anchorRemindersDataStackView(){
        
        remindersDataStackView = UIStackView(arrangedSubviews: [totalRemindersBox,
                                                                totalRemindersOnEntryBox,
                                                                totalRemindersOnExitBox])
        
        remindersDataStackView.translatesAutoresizingMaskIntoConstraints = false
        remindersDataStackView.alignment = .center
        remindersDataStackView.distribution = .fillEqually
        remindersDataStackView.axis = .horizontal
        remindersContainer.addSubview(remindersDataStackView)
        
        remindersDataStackView.anchor(top: remindersContainer.topAnchor, left: remindersContainer.leftAnchor, bottom: remindersContainer.bottomAnchor, right: remindersContainer.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
        totalRemindersBox.anchor(top: remindersDataStackView.topAnchor, left: remindersDataStackView.leftAnchor, bottom: remindersDataStackView.bottomAnchor, right: totalRemindersOnEntryBox.leftAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
        totalRemindersOnEntryBox.anchor(top: remindersDataStackView.topAnchor, left: totalRemindersBox.rightAnchor, bottom: remindersDataStackView.bottomAnchor, right: totalRemindersOnExitBox.leftAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
        totalRemindersOnExitBox.anchor(top: remindersDataStackView.topAnchor, left: totalRemindersOnEntryBox.rightAnchor, bottom: remindersDataStackView.bottomAnchor, right: remindersContainer.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    }
    
    /// Anchors the view that holds the total reminders
    fileprivate func anchorTotalRemindersStackView(){
        
        totalRemindersStackView = UIStackView(arrangedSubviews: [totalReminderAmountLabel,
                                                                 totalReminderTextView])
        
        totalRemindersStackView.translatesAutoresizingMaskIntoConstraints = false
        totalRemindersStackView.alignment = .center
        totalRemindersStackView.axis = .vertical
        totalRemindersStackView.distribution = .fillEqually
        totalRemindersBox.addSubview(totalRemindersStackView)
        
        totalRemindersStackView.anchor(top: totalRemindersBox.topAnchor, left: totalRemindersBox.leftAnchor, bottom: totalRemindersBox.bottomAnchor, right: totalRemindersBox.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        totalReminderAmountLabel.centerXAnchor.constraint(equalTo: totalRemindersBox.centerXAnchor).isActive = true
        totalReminderTextView.centerXAnchor.constraint(equalTo: totalRemindersBox.centerXAnchor).isActive = true
    }
    
    /// Anchors the view that holds the reminders on entry
    fileprivate func anchorEntriesReminderStackView(){
        
        totalRemindersOnEntryStackView = UIStackView(arrangedSubviews: [totalRemindersOnEntryAmountLable,
                                                                        totalRemindersOnEntryTextView])
        
        totalRemindersOnEntryStackView.translatesAutoresizingMaskIntoConstraints = false
        totalRemindersOnEntryStackView.alignment = .center
        totalRemindersOnEntryStackView.axis = .vertical
        totalRemindersOnEntryStackView.distribution = .fillEqually
        totalRemindersOnEntryBox.addSubview(totalRemindersOnEntryStackView)
        
        totalRemindersOnEntryStackView.anchor(top: totalRemindersOnEntryBox.topAnchor, left: totalRemindersOnEntryBox.leftAnchor, bottom: totalRemindersOnEntryBox.bottomAnchor, right: totalRemindersOnEntryBox.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
        totalRemindersOnEntryAmountLable.centerXAnchor.constraint(equalTo: totalRemindersOnEntryBox.centerXAnchor).isActive = true
        totalRemindersOnEntryTextView.centerXAnchor.constraint(equalTo: totalRemindersOnEntryBox.centerXAnchor).isActive = true

    }
    
    /// Anchors the view that holds the reminders on exit
    fileprivate func anchorExitReminderStackView(){
        
        totalRemindersOnExitStackView = UIStackView(arrangedSubviews: [totalRemindersOnExitAmountLable,
                                                                        totalRemindersOnExitTextView])
        
        totalRemindersOnExitStackView.translatesAutoresizingMaskIntoConstraints = false
        totalRemindersOnExitStackView.alignment = .center
        totalRemindersOnExitStackView.axis = .vertical
        totalRemindersOnExitStackView.distribution = .fillEqually
        totalRemindersOnExitBox.addSubview(totalRemindersOnExitStackView)
        
        totalRemindersOnExitStackView.anchor(top: totalRemindersOnExitBox.topAnchor, left: totalRemindersOnExitBox.leftAnchor, bottom: totalRemindersOnExitBox.bottomAnchor, right: totalRemindersOnExitBox.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
        totalRemindersOnExitAmountLable.centerXAnchor.constraint(equalTo: totalRemindersOnExitBox.centerXAnchor).isActive = true
        totalRemindersOnExitTextView.centerXAnchor.constraint(equalTo: totalRemindersOnExitBox.centerXAnchor).isActive = true
        
    }
    
    /// Anchors the table view in the table view container view
    fileprivate func anchorTableView(){
        
        tableViewContainer.addSubview(groupListTableView)
        groupListTableView.anchor(top: tableViewContainer.topAnchor, left: tableViewContainer.leftAnchor, bottom: tableViewContainer.bottomAnchor, right: tableViewContainer.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0, enableInsets: false)
    }
}
