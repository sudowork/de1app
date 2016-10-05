#!/usr/local/bin/tclsh 

cd /d/admin/code/de1beta/skins/default/2560x1600

set fast 1

proc fast_write_open {fn parms} {
    set f [open $fn $parms]
    fconfigure $f -blocking 0
    fconfigure $f -buffersize 1000000
    return $f
}

proc write_file {filename data} {
    set fn [fast_write_open $filename w]
    puts $fn $data 
    close $fn
    return 1
}

proc read_file {filename} {
    set fn [open $filename]
    set data [read $fn]
    close $fn
    return $data
}

proc regsubex {regex in replace} {
	set escaped [string map {\[ \\[ \] \\] \$ \\$ \\ \\\\} $in]
	regsub -all $regex $escaped $replace result
	set result [subst $result]
	return $result
}

set skinfiles { nothing_on.png espresso_on.png settings_on.png steam_on.png tea_on.png sleep.jpg}
set dirs [list \
    "1280x800" 2 2 \
    "1920x1200" 1.333333 1.333333 \
    "1920x1080" 1.333333 1.4814814815 \
    "1280x720"  2 2.22222 \
    "2560x1440" 1 1.11111 \
]

# convert all the skin PNG files
foreach {dir xdivisor ydivisor} $dirs {
    puts "Making $dir skin $xdivisor / $ydivisor"
    if {$fast == 0} {
        foreach skinfile $skinfiles {
            exec convert $skinfile -resize $dir!  ../$dir/$skinfile 
        }
    }

    set newskin [read_file "skin.tcl"]
    set newskin [regsubex {add_de1_text (".*?") ([0-9]+) ([0-9]+) } $newskin "add_de1_text \\1 \[expr \{\\2/$xdivisor\}\] \[expr \{\\3/$ydivisor\}\] "]
    set newskin [regsubex {add_de1_button (".*?") (.*?) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)\n} $newskin "add_de1_button \\1 \\2 \[expr \{\\3/$xdivisor\}\] \[expr \{\\4/$ydivisor\}\] \[expr \{\\5/$xdivisor\}\] \[expr \{\\6/$ydivisor\}\]\n"]
    set newskin [regsubex {add_de1_variable (".*?") ([0-9]+) ([0-9]+) } $newskin "add_de1_variable \\1 \[expr \{\\2/$xdivisor\}\] \[expr \{\\3/$ydivisor\}\] "]
    
    # this the maximum text width for labels
    #puts "xdivisor: $xdivisor"
    set newskin [regsubex {\-width ([0-9]+)} $newskin "-width \[expr \{\\1/$xdivisor\}\] "]
    write_file "../$dir/skin.tcl" $newskin 

}

exit

# 


puts "Resizing skin 2560x1600 -> 1280x800"
cd 2560x1600
set do_this 1
if {$do_this == 1} {
    exec convert nothing_on.png -resize 1280x800!  ../1280x800/nothing_on.png 
    exec convert espresso_on.png -resize 1280x800!  ../1280x800/espresso_on.png 
    exec convert settings_on.png -resize 1280x800!  ../1280x800/settings_on.png 
    exec convert steam_on.png -resize 1280x800!  ../1280x800/steam_on.png 
    exec convert tea_on.png -resize 1280x800!  ../1280x800/tea_on.png 
}

set newskin [read_file "skin.tcl"]
set newskin [regsubex {add_de1_text (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_text \1 [expr {\2/2}] [expr {\3/2}] }]
set newskin [regsubex {add_de1_button (".*?") (.*?) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)\n} $newskin {add_de1_button \1 \2 [expr {\3/2}] [expr {\4/2}] [expr {\5/2}] [expr {\6/2}]\n}]
set newskin [regsubex {add_de1_variable (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_variable \1 [expr {\2/2}] [expr {\3/2}] }]
set newskin [regsubex {\-width ([0-9]+)} $newskin {-width [expr {\1/2}]}]
write_file "../1280x800/skin.tcl" $newskin 

set do_all 1
if {$do_all == 1} {
    puts "Resizing skin 2560x1600 -> 1920x1200"
    exec convert nothing_on.png -resize 1920x1200!  ../1920x1200/nothing_on.png &
    exec convert espresso_on.png -resize 1920x1200!  ../1920x1200/espresso_on.png &
    exec convert settings_on.png -resize 1920x1200!  ../1920x1200/settings_on.png &
    exec convert steam_on.png -resize 1920x1200!  ../1920x1200/steam_on.png &
    exec convert tea_on.png -resize 1920x1200!  ../1920x1200/tea_on.png &

    set newskin [read_file "skin.tcl"]
    set newskin [regsubex {add_de1_text (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_text \1 [expr {int(\2/1.33)}] [expr {int(\3/1.33)}] }]
    set newskin [regsubex {add_de1_button (".*?") (.*?) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)\n} $newskin {add_de1_button \1 \2 [expr {int(\3/1.33)}] [expr {int(\4/1.33)}] [expr {int(\5/1.33)}] [expr {int(\6/1.33)}]\n}]
    set newskin [regsubex {add_de1_variable (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_variable \1 [expr {int(\2/1.33)}] [expr {int(\3/1.33)}] }]
    set newskin [regsubex {\-width ([0-9]+)} $newskin {-width [expr {int(\1/1.33)}]}]
    write_file "../1920x1200/skin.tcl" $newskin 

    cd ..

    cd 2560x1440
    puts "Resizing skin 2560x1440 -> 1280x720"
    exec convert nothing_on.png -resize 1280x720!  ../1280x720/nothing_on.png
    exec convert espresso_on.png -resize 1280x720!  ../1280x720/espresso_on.png
    exec convert settings_on.png -resize 1280x720!  ../1280x720/settings_on.png
    exec convert steam_on.png -resize 1280x720!  ../1280x720/steam_on.png
    exec convert tea_on.png -resize 1280x720!  ../1280x720/tea_on.png

    set newskin [read_file "skin.tcl"]
    set newskin [regsubex {add_de1_text (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_text \1 [expr {\2/2}] [expr {\3/2}] }]
    set newskin [regsubex {add_de1_button (".*?") (.*?) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)\n} $newskin {add_de1_button \1 \2 [expr {\3/2}] [expr {\4/2}] [expr {\5/2}] [expr {\6/2}]\n}]
    set newskin [regsubex {add_de1_variable (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_variable \1 [expr {\2/2}] [expr {\3/2}] }]
    set newskin [regsubex {\-width ([0-9]+)} $newskin {-width [expr {\1/2}]}]
    write_file "../1280x720/skin.tcl" $newskin 


    puts "Resizing skin 2560x1440 -> 1920x1080"
    exec convert nothing_on.png -resize 1920x1080!  ../1920x1080/nothing_on.png
    exec convert espresso_on.png -resize 1920x1080!  ../1920x1080/espresso_on.png
    exec convert settings_on.png -resize 1920x1080!  ../1920x1080/settings_on.png
    exec convert steam_on.png -resize 1920x1080!  ../1920x1080/steam_on.png
    exec convert tea_on.png -resize 1920x1080!  ../1920x1080/tea_on.png

    set newskin [read_file "skin.tcl"]
    set newskin [regsubex {add_de1_text (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_text \1 [expr {int(\2/1.33)}] [expr {int(\3/1.33)}] }]
    set newskin [regsubex {add_de1_button (".*?") (.*?) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)\n} $newskin {add_de1_button \1 \2 [expr {int(\3/1.33)}] [expr {int(\4/1.33)}] [expr {int(\5/1.33)}] [expr {int(\6/1.33)}]\n}]
    set newskin [regsubex {add_de1_variable (".*?") ([0-9]+) ([0-9]+) } $newskin {add_de1_variable \1 [expr {int(\2/1.33)}] [expr {int(\3/1.33)}] }]
    set newskin [regsubex {\-width ([0-9]+)} $newskin {-width [expr {int(\1/1.33)}]}]
    write_file "../1920x1080/skin.tcl" $newskin 
}


cd ..

puts "done"