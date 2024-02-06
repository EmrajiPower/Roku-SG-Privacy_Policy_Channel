sub init()
    m.top.backgroundURI = "pkg:/images/rsgetbg.jpg"

    devInfo = createObject("roDeviceInfo")    

    m.global.addFields({
     deviceId: devInfo.getChannelClientId()
     userContry: devInfo.GetUserCountryCode()
    })
  
    
    m.deviceLocationInfo = m.top.findNode("deviceLocationInfo")

    session = RegRead("userCredentials")
    
    if session = invalid
        print "[NOT FOUND 🛅 Device Registry] Creating ... "
        consentManagement = {}
        if m.global.userContry = "CA" or m.global.userContry = "CO" or m.global.userContry = "CT" or m.global.userContry = "VA"
            consentManagement = {
                unique_user_indetifier: m.global.deviceId
                location: m.global.userContry
                consent_preferences: [false,false]
            }
        else
            consentManagement = {
                unique_user_indetifier: m.global.deviceId
                location: m.global.userContry
                consent_preferences: [true,true]
            }
        end if
        RegWrite("userCredentials", FormatJson(consentManagement))
    else
        locatedInfo = ParseJson(session)
        print "[FOUND 🛅 Device Registry] ", locatedInfo
    end if
  
    m.top.overhang.showClock = false
    m.top.overhang.showOptions = true
  
    m.categoriespanel = m.top.panelSet.createChild("categoriesListPanel")
  
    m.categoryinfopanel = m.top.panelSet.createChild("categoryinfoPanel")
  
    m.categoriespanel.list.observeField("itemFocused","showcategoryinfo")
    m.categoryinfopanel.observeField("focusedChild","slideexamplesgridpanel")
  
    if devInfo <> invalid        
       m.deviceLocationInfo.text = "Location debug: "+ m.global.userContry
    end if
    
    m.categoriespanel.setFocus(true)

  end sub
  
  sub showcategoryinfo()
    categorycontent = m.categoriespanel.list.content.getChild(m.categoriespanel.list.itemFocused)
    m.categoryinfopanel.description = categorycontent.description
    m.examplespanel = createObject("RoSGNode","examplesGridPanel")
    m.examplespanel.overhangtext = categorycontent.shortdescriptionline1
    m.examplespanel.gridcontenturi = categorycontent.Url
  end sub
  
  sub slideexamplesgridpanel()
    if not m.top.panelSet.isGoingBack
      m.top.panelSet.appendChild(m.examplespanel)
      m.examplespanel.setFocus(true)
    else
      m.categoriespanel.setFocus(true)
    end if 
  end sub