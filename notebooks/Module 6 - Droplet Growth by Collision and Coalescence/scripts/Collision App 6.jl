using Base64, Interact

function showvid(file)
    HTML(string("""<video autoplay controls><source src="data:video/x-m4v;base64,""",
        base64encode(open(read,"figures/"*file)),"""" type="video/mp4"></video>"""))
end

vid = togglebuttons(OrderedDict("A"=>"a.mp4", "B"=>"b.mp4", "C"=>"c.mp4", "D"=>"e.mp4", 
                                "E"=>"f.mp4", "F"=>"g.mp4", "G"=>"i.mp4", "H"=>"j.mp4", 
                                "I"=>"k.mp4", "K"=>"SampleVideo_1280x720_2mb.mp4","L"=>"m.mp4",
                         "M"=>"n.mp4","N"=>"o.mp4",), value = "i.mp4", label = "Select Simulation")
                         
display(vid)
map(showvid, vid)