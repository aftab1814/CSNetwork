import Foundation
import UIKit

public class ACCSuspiciousDeviceDetection {
    
    public init() {
        
    }
    private enum JailbreakCheck: CaseIterable {
        case existenceOfSuspiciousFiles
        case restrictedDirectoriesWriteable
        case fork
        case symbolicLinks
    }
    
    public var amIJailBroken: Bool {
        isSimulator ? false : performChecks()
    }
    
    // isSimulator - Returns true if it is run on Simulator
    private var isSimulator: Bool {
        SimulatorChecker.amIRunInSimulator()
    }
    
    private func performChecks() -> Bool {
        var result = false
        for check in JailbreakCheck.allCases {
            switch check {
            case .existenceOfSuspiciousFiles:
                result = isSuspiciousFilesPresentInTheDirectory()
                if result {
                    return result
                }
            case .restrictedDirectoriesWriteable:
                result = canRestrictedDirectoriesWriteable()
                if result {
                    return result
                }
            case .fork:
                result = systemForkCall()
                if result {
                    return result
                }
            case .symbolicLinks:
                result = checkSymbolicLinks()
                if result {
                    return result
                }
            }
        }
        return result
    }
    
    // Array - filesPathToCheck
    private var filesPathToCheck: [String] {
        return [
            "/var/mobile/Library/Preferences/ABPattern",
            "/usr/lib/ABDYLD.dylib",
            "/usr/lib/ABSubLoader.dylib",
            "/usr/sbin/frida-server",
            "/etc/apt/sources.list.d/electra.list",
            "/etc/apt/sources.list.d/sileo.sources",
            "/.bootstrapped_electra",
            "/usr/lib/libjailbreak.dylib",
            "/jb/lzma",
            "/.cydia_no_stash",
            "/.installed_unc0ver",
            "/.bootstrapped_electra",
            "/jb/offsets.plist",
            "/usr/share/jailbreak/injectme.plist",
            "/etc/apt/undecimus/undecimus.list",
            "/var/lib/dpkg/info/mobilesubstrate.md5sums",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/jb/jailbreakd.plist",
            "/jb/amfid_payload.dylib",
            "/jb/libjailbreak.dylib",
            "/usr/libexec/cydia/firmware.sh",
            "/var/lib/cydia",
            "/etc/apt",
            "/private/var/lib/apt",
            "/private/var/Users/",
            "/var/log/apt",
            "/Applications/Cydia.app",
            "/Applications/ckra1n.app",
            "/private/var/stash",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/cache/apt/",
            "/private/var/log/syslog",
            "/private/var/tmp/cydia.log",
            "/Applications/Icy.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/blackra1n.app",
            "/Applications/SBSettings.app",
            "/Applications/FakeCarrier.app",
            "/Applications/WinterBoard.app",
            "/Applications/IntelliScreen.app",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/Library/MobileSubstrate/CydiaSubstrate.dylib",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/Applications/Sileo.app",
            "/var/binpack",
            "/Library/PreferenceBundles/LibertyPref.bundle",
            "/Library/PreferenceBundles/ShadowPreferences.bundle",
            "/Library/PreferenceBundles/ABypassPrefs.bundle",
            "/Library/PreferenceBundles/FlyJBPrefs.bundle",
            "/usr/lib/libhooker.dylib",
            "/usr/lib/libsubstitute.dylib",
            "/usr/lib/substrate",
            "/usr/lib/TweakInject",
            "/var/binpack/Applications/loader.app",
            "/Applications/FlyJB.app",
            "/Applications/Zebra.app",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/usr/libexec/ssh-keysign",
            "/bin/sh",
            "/etc/ssh/sshd_config",
            "/usr/libexec/sftp-server",
            "/usr/bin/ssh"
        ]
    }
    
    // func - isSuspiciousFilesPresentInTheDirectory
    private func isSuspiciousFilesPresentInTheDirectory() -> Bool {
        for path in filesPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    // func - canRestrictedDirectoriesWriteable
    private func canRestrictedDirectoriesWriteable() -> Bool {
        let jailBreakTestText = "Test for JailBreak"
        let filePath = "/private/jailBreakTestText.txt"
        do {
            try jailBreakTestText.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch { }
        return false
    }
    
    // func:- systemCall
    private func systemForkCall() -> Bool {
        return getpgrp() < 0
    }
    
    // Symbolic link verification
    private func checkSymbolicLinks() -> Bool {
        let paths = [
            "/var/lib/undecimus/apt",
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/arm-apple-darwin9",
            "/usr/include",
            "/usr/libexec",
            "/usr/share"
        ]
        for path in paths {
            do {
                let result = try FileManager.default.destinationOfSymbolicLink(atPath: path)
                if !result.isEmpty {
                    return true
                }
            } catch {}
        }
        return false
    }
}

internal class SimulatorChecker {
    
    static func amIRunInSimulator() -> Bool {
        return  checkRuntime() || checkCompile()
    }
    
    private static func checkRuntime() -> Bool {
        return ProcessInfo().environment["SIMULATOR_DEVICE_NAME"] != nil
    }

    private static func checkCompile() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
