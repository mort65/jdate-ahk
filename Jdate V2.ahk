; V1toV2: Removed #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
Persistent
#SingleInstance force

bJalali := True
sToday := ""

gregorian_to_jalali(gd,gm,gy) {
    ;converts gregorian date to jalali
    ;if not gy or not gm or not gd
    ;    throw Exception( "Invalid date", -1)
    g_d_m := [ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ]
    gy2 := (gm > 2) ? (gy + 1) : gy
    days := 355666 + (365 * gy) + (((gy2 + 3) // 4)) - (((gy2 + 99) // 100)) + (((gy2 + 399) // 400)) + gd + g_d_m[gm]
    jy := -1595 + (33 * ((days // 12053)))
    days := Mod(days,12053)
    jy += 4 * ((days // 1461))
    days := Mod(days,1461)
    if (days > 365)
    {
        jy += ((days - 1) // 365)
        days := Mod((days - 1),365)
    }
    jm := (days < 186) ? 1 + (days // 31) : 7 + ((days - 186) // 30)
    jd := 1 + ((days < 186) ? Mod(days,31) : (Mod((days - 186),30)))
    jalali := [ jd, jm, jy ]
    return jalali
}

jalali_to_gregorian(jd,jm,jy) {
    ;;converts jalali date to gregorian
    ;if not gy or not gm or not gd
    ;    throw Exception( "Invalid date", -1)
    jy += 1595
    days := -355668 + (365 * jy) + (( (jy // 33)) * 8) + ((Mod(jy,33) + 3) // 4) + jd + ((jm < 7) ? (jm - 1) * 31 : ((jm - 7) * 30) + 186)
    gy := 400 * ((days // 146097))
    days := Mod(days,146097)
    if (days > 36524) {
        gy += 100 * ((--days // 36524))
        days := Mod(days,36524)
        if (days >= 365) 
            days++
    }
    gy += 4 * ((days // 1461))
    days := Mod(days,1461)
    if (days > 365) {
        gy +=  ((days - 1) // 365)
        days := Mod((days - 1),365)
    }
    gd := days + 1
    sal_a := [ 0, 31, ((Mod(gy,4) == 0 && Mod(gy,100) != 0) || (Mod(gy,400) == 0)) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    gm := 1
    while(gm < 14 && gd > sal_a[gm]) {
        gd -= sal_a[gm]
        gm+=1
    }
    gregorian := [ gd, gm - 1, gy ]
    return gregorian
}

gToday()
{
    ;languageCode_0409 := "English_United_States"
    vLang := Format("{:i}", "0x" "0409") ;hex to dec
    gDate := FormatTime("L" vLang, "dd MM yyyy")
    gArr := StrSplit(gDate, A_Space)
    return gArr
    
}

jToday()
{
    gArr := gToday()
    jArr := (gregorian_to_jalali(gArr[1], gArr[2], gArr[3]))
    return jArr
}

today(dateArr)
{
    return (Format("{:04}", dateArr[3]) . "/" . Format("{:02}", dateArr[2]) . "/" . Format("{:02}", dateArr[1]))
}

If bJalali
{
    sToday := today(jToday())
}
Else
{
    sToday := today(gToday())
}

Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
;Tray.NoMainWindow()
A_IconTip := sToday
Tray.Add("Gregorian", Gregorian)
Tray.Add("Exit", Exit)
Tray.Default := "Gregorian"
SetTimer(updateTip,60000)
return

Exit(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *)
{ ; V1toV2: Added bracket
global ; V1toV2: Made function global
SetTimer(updateTip,0)
Sleep(50)
ExitApp()
} ; V1toV2: Added bracket before function


Gregorian(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *)
{
    Global bJalali
    bJalali := !bJalali
    updateTip()
    if bJalali
        Tray.Rename("Jalali", "Gregorian")
    else
        Tray.Rename("Gregorian", "Jalali")
    return
}



 
updateTip()
{ 
    Global bJalali
	Global sToday  
    If bJalali
    {
        sToday := today(jToday())
    }
    Else
    {
        sToday := today(gToday())
    }
    A_IconTip := sToday
    return
}
