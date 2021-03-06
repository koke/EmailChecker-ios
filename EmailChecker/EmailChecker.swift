import Foundation

private let knownDomains = Set([
    /* Default domains included */
    "aol.com", "att.net", "comcast.net", "facebook.com", "gmail.com", "gmx.com", "googlemail.com",
    "google.com", "hotmail.com", "hotmail.co.uk", "mac.com", "me.com", "msn.com",
    "live.com", "sbcglobal.net", "verizon.net", "yahoo.com", "yahoo.co.uk",

    /* Other global domains */
    "games.com" /* AOL */, "gmx.net", "hush.com", "hushmail.com", "icloud.com", "inbox.com",
    "lavabit.com", "love.com" /* AOL */, "outlook.com", "pobox.com", "rocketmail.com" /* Yahoo */,
    "safe-mail.net", "wow.com" /* AOL */, "ygm.com" /* AOL */, "ymail.com" /* Yahoo */, "zoho.com", "fastmail.fm",
    "yandex.com",

    /* United States ISP domains */
    "bellsouth.net", "charter.net", "comcast.com", "cox.net", "earthlink.net", "juno.com",

    /* British ISP domains */
    "btinternet.com", "virginmedia.com", "blueyonder.co.uk", "freeserve.co.uk", "live.co.uk",
    "ntlworld.com", "o2.co.uk", "orange.net", "sky.com", "talktalk.co.uk", "tiscali.co.uk",
    "virgin.net", "wanadoo.co.uk", "bt.com",

    /* Domains used in Asia */
    "sina.com", "qq.com", "naver.com", "hanmail.net", "daum.net", "nate.com", "yahoo.co.jp", "yahoo.co.kr", "yahoo.co.id", "yahoo.co.in", "yahoo.com.sg", "yahoo.com.ph",

    /* French ISP domains */
    "hotmail.fr", "live.fr", "laposte.net", "yahoo.fr", "wanadoo.fr", "orange.fr", "gmx.fr", "sfr.fr", "neuf.fr", "free.fr",

    /* German ISP domains */
    "gmx.de", "hotmail.de", "live.de", "online.de", "t-online.de" /* T-Mobile */, "web.de", "yahoo.de",

    /* Russian ISP domains */
    "mail.ru", "rambler.ru", "yandex.ru", "ya.ru", "list.ru",

    /* Belgian ISP domains */
    "hotmail.be", "live.be", "skynet.be", "voo.be", "tvcablenet.be", "telenet.be",

    /* Argentinian ISP domains */
    "hotmail.com.ar", "live.com.ar", "yahoo.com.ar", "fibertel.com.ar", "speedy.com.ar", "arnet.com.ar",

    /* Domains used in Mexico */
    "hotmail.com", "gmail.com", "yahoo.com.mx", "live.com.mx", "yahoo.com", "hotmail.es", "live.com", "hotmail.com.mx", "prodigy.net.mx", "msn.com"
    ])

public struct EmailChecker {
    public static func suggestDomainCorrection(email: String) -> String {
        let components = email.componentsSeparatedByString("@")
        guard components.count == 2 else {
            return email
        }
        let (account, domain) = (components[0], components[1])

        // If the domain name is empty, don't try to suggest anything
        guard !domain.isEmpty else {
            return email
        }

        // If the domain name is too long, don't try suggestion (resource consuming and useless)
        guard domain.characters.count < lengthOfLongestKnownDomain() + 1 else {
            return email
        }

        let suggestedDomain = suggest(domain)
        return account + "@" + suggestedDomain
    }
}

private func suggest(word: String) -> String {
    if knownDomains.contains(word) {
        return word
    }

    let candidates = edits(word).filter({ knownDomains.contains($0) })
    return candidates.first ?? word
}

private func edits(word: String) -> [String] {
    // deletes
    let deleted = deletes(word)
    let transposed = transposes(word)
    let replaced = alphabet.characters.flatMap({ character in
        return replaces(character, ys: word.characters)
    })
    let inserted = alphabet.characters.flatMap({ character in
        return between(character, ys: word.characters)
    })

    return deleted + transposed + replaced + inserted
}

private func deletes(word: String) -> [String] {
    return word.characters.indices.map({ word.removingCharacterAtIndex($0) })
}

private func transposes(word: String) -> [String] {
    return word.characters.indices.flatMap({ index in
        let (i, j) = (index, index.successor())
        guard j < word.endIndex else {
            return nil
        }
        var copy = word
        copy.replaceRange(i...j, with: String(word[j]) + String(word[i]))
        return copy
    })
}

private func replaces(x: Character, ys: String.CharacterView) -> [String] {
    guard let head = ys.first else {
        return [String(x)]
    }
    let tail = ys.dropFirst()
    return [String(x) + String(tail)] + replaces(x, ys: tail).map({ String(head) + $0 })
}

private func between(x: Character, ys: String.CharacterView) -> [String] {
    guard let head = ys.first else {
        return [String(x)]
    }
    let tail = ys.dropFirst()
    return [String(x) + String(ys)] + between(x, ys: tail).map({ String(head) + $0 })
}

private let alphabet = "abcdefghijklmnopqrstuvwxyz"

private func lengthOfLongestKnownDomain() -> Int {
    return knownDomains.map({ $0.characters.count }).maxElement() ?? 0
}

extension String {
    func removingCharacterAtIndex(index: Index) -> String {
        var copy = self
        copy.removeAtIndex(index)
        return copy
    }
}
