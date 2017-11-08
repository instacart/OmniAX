//
//  AudioPlayer.swift
//  OmniAX
//
//  Created by Dan Loman on 10/30/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import AudioToolbox

enum Sound {
    case startRecording
    case stopRecording

    var id: SystemSoundID {
        switch self {
        case .startRecording:
            return 1110
        case .stopRecording:
            return 1111
        }
    }
}

final class AudioPlayer {
    static func play(sound: Sound) {
        AudioServicesPlaySystemSoundWithCompletion(sound.id, {
            print("🔔 Played system sound")
        })
    }
}
