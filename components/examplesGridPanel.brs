sub init()
    m.top.observeField("focusedChild","onFocusedChild")
    m.top.panelSize = "full"
    m.top.isFullScreen = true
    m.top.focusable = true
    m.top.hasNextPanel = false
    m.top.createNextPanelOnItemFocus = false
    m.top.optionsAvailable = true
    m.top.grid = m.top.findNode("examplesPosterGrid")
    
    m.firstPolicyActionText = m.top.findNode("firstPolicyActionText")
    m.secondPolicyActionText = m.top.findNode("secondPolicyActionText")    
    m.automaticAgreementText = m.top.findNode("automaticAgreementText")

    m.firstPolicyAction = m.top.findNode("firstPolicyAction")
    m.secondPolicyAction = m.top.findNode("secondPolicyAction")
    
    m.firstPolicyAction.uri="pkg:/images/focused-form-field.png"         
    m.secondPolicyAction.uri=""

    m.privacyBtns = m.top.findNode("privacyBtns")
    m.privacyBtns.observeField("buttonFocused","onToggleAction")
    m.privacyBtns.observeField("buttonSelected","onToggleSelected")

    m.BGuserFormButtonsA = m.top.findNode("BGuserFormButtonsA")
    m.BGuserFormButtonsB = m.top.findNode("BGuserFormButtonsB")

    m.BGcheckoutButtonsA = m.top.findNode("BGcheckoutButtonsA")
    m.BGcheckoutButtonsB = m.top.findNode("BGcheckoutButtonsB")
    m.automaticAgreementText.visible = false

    m.privacyBtns.iconUri = ""
    m.privacyBtns.focusedIconUri = ""
    m.privacyBtns.textFont="font:MediumSystemFont" 
    m.privacyBtns.focusedTextFont="font:MediumBoldSystemFont" 
    m.privacyBtns.focusBitmapUri = "pkg:/images/btnBG-focus.png"

    initialAgreementUserConfig()
  end sub

  sub initialAgreementUserConfig()
    session = RegRead("userCredentials")
    locatedInfo = ParseJson(session)

    if locatedInfo <> invalid    
        if locatedInfo.location = "CA" or locatedInfo.location = "CO" or locatedInfo.location = "CT" or locatedInfo.location = "VA"
            m.automaticAgreementText.visible = false
            'Red BG colors
            if locatedInfo.consent_preferences[0] = false then m.BGuserFormButtonsA.color = "#ff001c"
            if locatedInfo.consent_preferences[1] = false then m.BGuserFormButtonsB.color = "#ff001c"
            'No Agree text
            if locatedInfo.consent_preferences[0] = false then m.firstPolicyActionText.text = "No Agree"
            if locatedInfo.consent_preferences[1] = false then m.secondPolicyActionText.text = "No Agree"
            
            'Green BG colors
            if locatedInfo.consent_preferences[0] = true then m.BGuserFormButtonsA.color = "#00ff00"
            if locatedInfo.consent_preferences[1] = true then m.BGuserFormButtonsB.color = "#00ff00"
            'Agree text
            if locatedInfo.consent_preferences[0] = true then m.firstPolicyActionText.text = "Agree"
            if locatedInfo.consent_preferences[1] = true then m.secondPolicyActionText.text = "Agree"
        else            
            m.BGuserFormButtonsA.color = "#999999"
            m.BGuserFormButtonsB.color = "#999999"            
            m.firstPolicyActionText.text = "Agree"
            m.secondPolicyActionText.text = "Agree"
            m.automaticAgreementText.visible = true
        end if              
    end if
  end sub
  
  sub onFocusedChild(evt as object)    
    if m.top.hasFocus()
        m.privacyBtns.setFocus(true)
    end if    
  end sub


    sub onToggleAction(evt as object)        
        idx = evt.getData()
        if idx = 0              
            m.firstPolicyAction.uri="pkg:/images/focused-form-field.png"         
            m.secondPolicyAction.uri=""
        else if idx = 1            
            m.firstPolicyAction.uri=""
            m.secondPolicyAction.uri="pkg:/images/focused-form-field.png"
        end if
    end sub

    sub onToggleSelected(evt as object)
        idx = evt.getData()
        session = RegRead("userCredentials")
        locatedInfo = ParseJson(session)
        
        if idx = 0            
            preferenceOne = locatedInfo.consent_preferences[0]
            updateUserRegistry("pos1",not preferenceOne)
        else if idx = 1            
            preferenceTwo = locatedInfo.consent_preferences[1]            
            updateUserRegistry("pos2",not preferenceTwo)
        end if
    end sub

    sub updateUserRegistry(position as string, value as boolean)
        session = RegRead("userCredentials")
        locatedInfo = ParseJson(session)
        if session <> invalid
            if locatedInfo.location = "CA" or locatedInfo.location = "CO" or locatedInfo.location = "CT" or locatedInfo.location = "VA"
                if locatedInfo.unique_user_indetifier <> invalid and m.global.deviceId = locatedInfo.unique_user_indetifier
                    updateConsentManagement = {
                        unique_user_indetifier: m.global.deviceId
                        location: m.global.userContry
                    }
                    if position = "pos1" then updateConsentManagement.AddReplace("consent_preferences",[value,locatedInfo.consent_preferences[1]])
                    if position = "pos2" then updateConsentManagement.AddReplace("consent_preferences",[locatedInfo.consent_preferences[0],value])
                    RegWrite("userCredentials", FormatJson(updateConsentManagement))
                    print "[Record] ",formatJson(updateConsentManagement)
                    initialAgreementUserConfig()
                end if
            end if
        end if
    end sub
  
  sub readpostergrid()
    m.readPosterGridTask = createObject("roSGNode","postergridCR")
    m.readPosterGridTask.control = "RUN" 
    m.readPosterGridTask.observeField("postergridcontent","showpostergrid")
    m.readPosterGridTask.control = "RUN"
  end sub
  
  sub showpostergrid()
    m.infoPanel = createObject("RoSGNode","examplesGridPanel")
    if m.top.gridcontenturi = "consent_information"
        m.privacyBtns.visible = false
        m.automaticAgreementText.visible = false
    else
        m.privacyBtns.visible = true        
    end if
  end sub

  function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    ? "[Navigation debugger] key= "; key; " press= "; press
    if press then
        if key = "up" then
            firstBtn = m.privacyBtns.getChild(0)
            firstBtn.setFocus(true)
        else if key = "down" then
            secondBtn = m.privacyBtns.getChild(1)
            secondBtn.setFocus(true)
        end if
        return false
    end if
    return handled
end function