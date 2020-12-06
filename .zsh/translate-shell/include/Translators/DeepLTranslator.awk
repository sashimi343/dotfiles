####################################################################
# DeepLTranslator.awk                                              #
####################################################################
#
# Last Updated: 12 Dec 2017
BEGIN { provides("deepl") }

function deeplInit() {
    HttpProtocol = "http://"
    HttpHost = "www.deepl.com"
    HttpPort = 80
}

function deeplRequestUrl(text, sl, tl, hl) {
    # Not implemented
}

function deeplTTSUrl(text, tl,    narrator) {
    # Not implemented
}

function deeplWebTranslateUrl(uri, sl, tl, hl) {
    # Not implemented
}

# Send an HTTP POST request and get response from DeepL Translator (via curl).
function deeplPost(text, sl, tl, hl,
                   ####
                   content, data, url) {
    data = "{\"jsonrpc\":\"2.0\",\"method\":\"LMT_handle_jobs\","
    data = data "\"params\":{\"jobs\":[{\"kind\":\"default\","
    data = data "\"raw_en_sentence\":" parameterize(text, "\"") "}],"
    data = data "\"lang\":{\"user_preferred_langs\":[\"" hl "\"],"
    data = data "\"source_lang_user_selected\":\"" sl "\","
    data = data "\"target_lang\":\"" tl "\"},"
    data = data "\"priority\":1},\"id\":1}"
    l(data)
    url = "https://www.deepl.com/jsonrpc"
    content = curlPost(url, data)
    return assert(content, "[ERROR] Null response.")
}

# Get the translation of a string.
function deeplTranslate(text, sl, tl, hl,
                        isVerbose, toSpeech, returnPlaylist, returnIl,
                        ####
                        r,
                        content, tokens, ast,
                        _sl, _tl, _hl, il,
                        translation, translations,
                        wShowOriginal, wShowTranslation,
                        wShowLanguages, wShowAlternatives,
                        group, temp) {
    if (!getCode(tl)) {
        # Check if target language is supported
        w("[WARNING] Unknown target language code: " tl)
    } else if (isRTL(tl)) {
        # Check if target language is R-to-L
        if (!FriBidi)
            w("[WARNING] " getName(tl) " is a right-to-left language, but FriBidi is not found.")
    }
    _sl = getCode(sl); if (!_sl) _sl = sl
    _tl = getCode(tl); if (!_tl) _tl = tl
    _hl = getCode(hl); if (!_hl) _hl = hl

    # Quick hack: DeepL uses uppercase language codes except for "auto"
    if (_sl != "auto") _sl = toupper(_sl)
    if (_tl != "auto") _tl = toupper(_tl)
    if (_hl != "auto") _hl = toupper(_hl)

    content = deeplPost(text, _sl, _tl, _hl)
    if (Option["dump"])
        return content
    tokenize(tokens, content)
    parseJson(ast, tokens)

    l(content, "content", 1, 1)
    l(tokens, "tokens", 1, 0, 1)
    l(ast, "ast")
    if (!isarray(ast) || !anything(ast)) {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        ExitCode = 1
        return
    }

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "compareByIndexFields"
    for (i in ast) {
        if (i ~ "^0" SUBSEP "result" SUBSEP "translations" SUBSEP 0 SUBSEP "beams" SUBSEP "[[:digit:]]+" SUBSEP "postprocessed_sentence$") {
            # FIXME: build a cache for recurring invocation of uprintf()
            append(translations, uprintf(unquote(unparameterize(ast[i]))))
        }
    }
    PROCINFO["sorted_in"] = saveSortedIn

    translation = translations[0]
    returnIl[0] = il = tolower(unparameterize(ast[0 SUBSEP "result" SUBSEP "source_lang"]))
    if (Option["verbose"] < 0)
        return getList(il)

    # Generate output
    if (!isVerbose) {
        # Brief mode
        r = translation

    } else {
        # Verbose mode
        wShowOriginal = Option["show-original"]
        wShowTranslation = Option["show-translation"]
        wShowLanguages = Option["show-languages"]
        wShowAlternatives = Option["show-alternatives"]

        if (length(translations) <= 1) wShowAlternatives = 0

        if (wShowOriginal) {
            # Display: original text
            if (r) r = r RS RS
            r = r m("-- display original text")
            r = r prettify("original", s(text, il))
        }

        if (wShowTranslation) {
            # Display: major translation
            if (r) r = r RS RS
            r = r m("-- display major translation")
            r = r prettify("translation", s(translation, tl))
        }

        if (wShowLanguages) {
            # Display: source language -> target language
            if (r) r = r RS RS
            r = r m("-- display source language -> target language")
            temp = Option["fmt-languages"]
            if (!temp) temp = "[ %s -> %t ]"
            split(temp, group, /(%s|%S|%t|%T)/)
            r = r prettify("languages", group[1])
            if (temp ~ /%s/)
                r = r prettify("languages-sl", getDisplay(il))
            if (temp ~ /%S/)
                r = r prettify("languages-sl", getName(il))
            r = r prettify("languages", group[2])
            if (temp ~ /%t/)
                r = r prettify("languages-tl", getDisplay(tl))
            if (temp ~ /%T/)
                r = r prettify("languages-tl", getName(tl))
            r = r prettify("languages", group[3])
        }

        if (wShowAlternatives) {
            # Display: alternative translations
            if (r) r = r RS
            r = r m("-- display alternative translations")
            r = r RS ins(1, prettify("alternatives-translations-item", translations[1]))
            for (i = 2; i < length(translations); i++)
                r = r RS ins(1, prettify("alternatives-translations-item", translations[i]))
        }
    }

    if (toSpeech) {
        returnPlaylist[0]["text"] = translation
        returnPlaylist[0]["tl"] = tl
    }

    return r
}
