'********** Copyright 2015 Roku Corp.  All Rights Reserved. **********

sub Main()
	showChannelSGScreen()
end sub

sub showChannelSGScreen()
	screen = CreateObject("roSGScreen")
	m.port = CreateObject("roMessagePort")
	screen.setMessagePort(m.port)
	m.global = screen.getGlobalNode() 
	scene = screen.CreateScene("tutorialPanelSetScene")
	screen.show()
	' vscode_rdb_on_device_component_entry
	while(true)

		msg = wait(0, m.port)
		msgType = type(msg)

		if msgType = "roSGScreenEvent"

			if msg.isScreenClosed() then return

		end if

	end while
end sub
