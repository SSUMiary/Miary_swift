//
//  SettingsViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 13..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseAuth
import GameKit
class SettingsViewController: UITableViewController {

    @IBOutlet var userProfile : UIImageView!
    @IBOutlet var userName : UILabel!
    @IBOutlet var caption : UILabel!
    var captionArr : [String] = ["너무 애쓰지 않았으면 해.\n이미 일어나 버린 일들과\n일어나지 않은 것들에 대한 걱정과\n어쩔 수 없었던 선택과 그로 인한 결과들에.\n생각만으로 해결되지 않는 고민들과\n답이 되어 돌아오지 않는 질문들과\n이해할 수 없는 모든 문제들에 대해."
        ,
        "관계를 지키는 법은 간단해.\n조금만 덜 오해하고\n조금만 더 이해하고\n조금만 덜 의심하고\n조금만 더 믿어주면 돼.",
        
        "시간이\n약이라는데\n너무 쓰다.",
        
        "사람들이 떠나가는 걸\n한 때는 너무 두려워했었다.\n그렇지만 참 고마운 일이 아닐 수 없다.\n자연스레 걸러지는 것이다.\n남을 사람과 떠날 사람",
        
        "뭘 잘해야지.\n소중한 사람이 아니야.\n그냥 너 자체로\n소중한 사람이야.",
        
        "이미 나를 떠나버린 사람 때문에\n너무 오랜 시간 마음 아파하지 말자.\n나를 사랑해주고\n걱정해주는 사람도 많은데.",
        
        "하지만 들어주는 사람도\n참고 있을 뿐,\n똑같이 토닥임이 필요한\n나약한 사람이다.",
        
        "다들 아닌 척 살아가지만\n지금 이 순간에도\n남모르는 고민과 상처들로\n힘들어하고 있다는 걸 알아.",
        
        "솔직해야 하는 순간에\n솔직하지 못해서.\n이해받지 못하고\n이해하기만 해야 해서.\n당신 참 힘들었겠다.\n그 모든 것들을 참아내느라.",
        
        "왜 항상 내가 애정을 가지고\n소중하게 아끼는 것들은\n모두 잃어버리고 마는지.",
        
        "우리가 신호등을 기다릴 수 있는 이유는\n곧 바뀔 거란 걸 알기 때문이다.\n그러니 힘들어도 조금만 참자.\n곧 바뀔거야.\n좋게.",
        
        "맞춰 주려고 노력하면\n막해도 되는지 알더라.",
        
        "그 사람한테 난 늘 2순위라고\n그 사람의 태도와 행동이\n그렇게 말해 주었다.",
        
        "걱정은 짧고 굵게\n기쁨은 가늘고 길게",
        
        "왜 그런 날 있잖아요.\n누군가 날 꼭 안아주면\n펑펑 울 것만 같은 날.\n그런데 안아줄 사람마저 없어서\n더 서러운 날.",
        
        "살짝 스친 다정함에\n공연히 마음을 줘버린 내 탓.",
        
        "너를 고작 그 정도로밖에\n생각하지 않는 사람에게는\n너도 그 사람을\n딱 그 정도로만 생각해주기.",
        
        "사랑스러운 사람아,\n오늘 하루는 걱정에 잠기지 않기를.\n시답지 않은 말들에 휩싸이지 않기를.\n눈물로 지새우는 밤이 아니라면 좋겠다.",
        
        "기다리겠다는 말이\n누군가에게 부담이 아닌,\n언제라도 돌아갈 곳이 있다는\n든든한 위안이 되길.",
        
        "노력해도 안 되는 것에\n더이상 매달리지 않기로 했다.\n나를 믿지 않는 사람은\n진실을 이야기해도 나를 믿지 않을 거고\n내 마음을 이해하기 싫은 사람은\n진심을 보여줘도\n내 마음을 이해하지 않을테니까.",
        
        "넘어지지 않는 사람은 없어.\n단, 다시 일어나는 사람만이\n앞으로 나아가는 법을 배우는 거야.",
        
        "흘러가는 시간에 연연하지 말고\n사소한 걱정들에 휩쓸리지 말고\n잠시 스칠 인연에 상처받지 말고\n당신이 머무를 곳에는\n예쁘고 좋은 바람만 불기를.",
        
        "남들보다 잘하려고\n고민하지 마라.\n지금의 나보다\n잘하려고 애쓰는 게 더 중요하다.",
        
        "명심해.\n말도 안 되는 핑계로\n오늘 너를 울린 그 사람은\n내일 또 다른 핑계로\n또다시 너를 울릴 수도 있다는 걸.",
        
        "어디 아픈 덴 없니? 많이 힘들었지?\n난 걱정 안 해도 돼.\n너만 괜찮으면 돼.\n가슴이 시릴 때, 아무도 없을 때\n늘 여기로 오면 돼.",
        
        "애매한 관계를 \n끊어내지 못하는 것만큼\n미련한 건 없는 것 같다.",
        
        "너무 신경쓰지마.\n너무 매달리지마.\n너무 불안해하지마.\n어쩔 수 없었잖아.\n네 잘못이 아니잖아.",
        
        "좋은 일도 없는데\n그렇다고 나쁜 일도 없다.\n이렇게 심심한 날\n작은 기쁨을 느끼기엔\n더할나위 없이 좋다.\n심심하고 고요한 이 순간이\n고맙고 고맙다.",
        
        "단 1분이라도\n버티기 힘들다고 생각될 때,\n당장 포기하고 싶은 마음이 들 때가\n당신의 수준이 달라지는\n정말 중요한 순간이다.",
        
        "아무것도 아니라고\n생각했던 사람이\n아무도 생각할 수 없는 일을\n해내거든요.",
        
        "왠지 오늘은\n나에게\n큰 행운이\n생길 것 같아.",
        
        "당신이\n두려워 하는 일을\n매일 하라.",
        
        "인생이 어차피 불안한거라면\n자유롭게라도 살자!",
        
        "꿈이 있으면\n누구나 별이 될 수 있지만,\n아무나 별이 될 수는 없다.",
        
        "현재 상태에 대해\n자기 연민에 빠지는 것은\n에너지 낭비일 뿐 아니라\n최악의 습관이다.",
        
        "계획이 따르지 않은 목적은\n단지 “희망사항”일 뿐이다.",
        
        "하루종일 행복할 순 없지만\n행복한 순간이\n한 번도 없는 하루는 없잖아.",
        
        "하고 싶은 일 한 가지를 위해\n하기 싫은 일 열 가지를 하며\n사는 게 인생이다."]
    
    @IBAction func onLogoutButtonClicked(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "startingPoint")
            self.present(nextVC, animated: true, completion: nil)
            print(#function)
        }
        catch{}
    }
    
    func getCaptionFromServer(){
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        MiaryLoginManager.instance.getUserProfile { (image) in
            
            self.userProfile.image = image
            self.userProfile.updateConstraintsIfNeeded()
        }
        self.userName.text = Auth.auth().currentUser?.displayName
        let index = arc4random_uniform(39)
        self.caption.text = captionArr[Int(index)]
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
