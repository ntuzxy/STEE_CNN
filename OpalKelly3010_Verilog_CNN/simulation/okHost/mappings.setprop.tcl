cd F:/GoogleDrive/6-Tapeout/Tapeout_201908/testing_code/OpalKelly6010_Verilog/simulation/Simulation/Verilog
if { [ catch { xload xmp mappings.v } result ] } {
  exit 10
}
xset arch spartan6
xset dev xc6slx150
xset package fgg484
xset speedgrade -2
xset simulator isim
if { [xset hier sub] != 0 } {
  exit -1
}
set bMisMatch false
set xpsArch [xget arch]
if { ! [ string equal -nocase $xpsArch "spartan6" ] } {
   set bMisMatch true
}
set xpsDev [xget dev]
if { ! [ string equal -nocase $xpsDev "xc6slx150" ] } {
   set bMisMatch true
}
set xpsPkg [xget package]
if { ! [ string equal -nocase $xpsPkg "fgg484" ] } {
   set bMisMatch true
}
set xpsSpd [xget speedgrade]
if { ! [ string equal -nocase $xpsSpd "-2" ] } {
   set bMisMatch true
}
if { $bMisMatch == true } {
   puts "Settings Mismatch:"
   puts "Current Project:"
   puts "	Family: spartan6"
   puts "	Device: xc6slx150"
   puts "	Package: fgg484"
   puts "	Speed: -2"
   puts "XPS File: "
   puts "	Family: $xpsArch"
   puts "	Device: $xpsDev"
   puts "	Package: $xpsPkg"
   puts "	Speed: $xpsSpd"
   exit 11
}
xset hdl verilog
xset intstyle ise
save proj
exit
