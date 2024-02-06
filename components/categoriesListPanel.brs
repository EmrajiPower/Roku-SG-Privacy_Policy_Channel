sub init()
    m.top.panelSize = "medium"
    m.top.focusable = true
    m.top.hasNextPanel = true
    m.top.leftOnly = true
    m.top.createNextPanelOnItemFocus = false
    m.top.selectButtonMovesPanelForward = true
    m.top.overhangTitle = "Data Privacy Consent Manager"
    m.categorieslist = m.top.findNode("categorieslist")
    m.top.list = m.categorieslist 
end sub