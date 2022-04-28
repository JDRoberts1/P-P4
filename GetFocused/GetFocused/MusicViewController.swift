//
//  MusicViewController.swift
//  RobertsJeanai_GetFocusedWatch
//
//  Created by Nai Roberts on 4/23/22.
//

import Foundation
import UIKit
import AVFoundation

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var player: AVAudioPlayer!
    var timer: Timer!
    var isPlaying : Bool = false
    
    
    var displayTime = 5.0
    var musicList = ["Classical Piano", "Lofi Hiphop", "Lofi Sounds", "Ocean Sounds","Piano e Violin", "Rain Sounds", "Soft Piano", "Synth and Piano", "LoFi", "Piano", "Sonata No.1 in F-Minor" ]
    var selectedSong : String!
    var elapsedTime : TimeInterval!
    var index : Int = 0
    
    var contentConfig : UIListContentConfiguration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(musicList.count)
        musicList.sort()
        
        
        // Do any additional setup after loading the view.
        //timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(labelDisplay), userInfo: nil, repeats: true)
        
        if selectedSong != nil{
            playSong()
        }
        
    }
    
    // MARK: Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playLastSong(_ sender: Any) {
        if index > 0{
            index = index - 1
        }
        else if index == 0 {
            index = musicList.count - 1
        }
        
        playSong()
    }
    
    
    @IBAction func playNextSong(_ sender: Any) {
        
        if index < musicList.count - 1{
            index = index + 1
        }
        else if index == musicList.count - 1 {
            index = 0
        }
        
        playSong()
         
    }
    
    @IBAction func backToTimer(_ sender: Any) {
        
        isPlaying = player.isPlaying
        
        if player.isPlaying{
            
            let formatter = DateComponentsFormatter()

            formatter.allowedUnits = .second
            
            elapsedTime = Double(formatter.string(from: player.currentTime)!)
            
        }
        
        performSegue(withIdentifier: "unwindToTimer", sender: sender)
    }
    
    
    // MARK: TableVIew Configuration
    // TableView Row Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicList.count
    }
    
    // Cell Creation, Configuration and Display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MUSIC_CELL_ID_1", for: indexPath)
        
        contentConfig = cell.defaultContentConfiguration()
        
        
        let mCell = musicList[indexPath.row]
        
        contentConfig.text = mCell.description
        
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    // MARK: Cell Selection Action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        index = indexPath.row
        playSong()
        
    }
    
    // MARK: Play Action Button
    @IBAction func playMusic(_ sender: Any) {
        
        if player.isPlaying == false{
            
            player.play()
            
            
        }
        else if player.isPlaying == true{
            
            player.pause()
            
        }
        
        
        
    }
    
    // MARK: Now Playing Label Change Function
    @objc func labelDisplay(){
        
        displayTime -= 1.0
        
        if displayTime <= 0{
            timer.invalidate()
            timer = nil
            
            // Hide instruction label
            //instructLabel.isHidden = true
        }
        
    }
    
    func playSong(){
        
        print(index)
        let selectedCell = musicList[index]
        
        selectedSong = selectedCell.description
        nowPlayingLabel.text = selectedSong
        
        if let url = Bundle.main.url(forResource: selectedSong, withExtension: ".mp3"){
            player = try! AVAudioPlayer(contentsOf: url)
            player.play()
        }
        else{
            print("doesnt work")
        }
    }
    
    
    
}
