' Reads and returns the value of the specified key
function RegRead(key as String, section = invalid As Dynamic) As Dynamic    
    If section = invalid Then section = "Privacy_Policy_Roku_BetaChannel"
    reg = CreateObject("roRegistrySection", section)
    If reg.Exists(key) Then return reg.Read(key)
    return invalid
end function

' Replaces the value of the specified key
sub RegWrite(key as String, val as String, section = invalid As Dynamic)
    If section = invalid Then section = "Privacy_Policy_Roku_BetaChannel"
    reg = CreateObject("roRegistrySection", section)
    reg.Write(key, val)
    reg.Flush()
end sub

' Deletes the specified key
sub RegDelete(key as String, section = invalid As Dynamic)
    If section = invalid Then section = "Privacy_Policy_Roku_BetaChannel"
    reg = CreateObject("roRegistrySection", section)
    reg.Delete(key)
    reg.Flush()
end sub