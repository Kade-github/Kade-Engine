wiggle = -1
susWiggle = -1
wiggleAmp = 0
susWiggleAmp = 0
wiggleOffset = 0.05
wiggleToOffset = 0.05
arrowAngles = 0


function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
	
    wiggle = createWiggle(3.14159*1.5,0.025,0.5)
    susWiggle = createWiggle(3.14159*3,0.025,1)
    setSustainWiggle(susWiggle)
    setNoteWiggle(wiggle)
end


function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)

    wiggleAmp = lerp(wiggleAmp,0,0.05)
    susWiggleAmp = lerp(susWiggleAmp,0,0.05)
    setWiggleAmplitude(wiggle, wiggleAmp)
    setWiggleAmplitude(susWiggle, susWiggleAmp)

    if (curStep >= 191 and curStep < 239) or (curStep >= 383 and curStep < 575) then
        wiggleToOffset = 1
    else
        wiggleToOffset = 0.05
    end

    wiggleOffset = lerp(wiggleOffset, wiggleToOffset, 0.0125)
    arrowAngles = lerp(arrowAngles, 0, 0.0325)

    local currentBeat = (songPos / 1000)*(bpm/60)
	for i=0,3 do
		local receptor = _G['receptor_'..i]
		receptor.y = receptor.defaultY + 8 * math.cos((currentBeat + i*wiggleOffset) * math.pi)
        receptor.angle = arrowAngles
        if i % 2 == 0 then receptor.angle = -arrowAngles end
	end
    for i=4,7 do
		local receptor = _G['receptor_'..i]
		receptor.y = receptor.defaultY + 8 * -math.cos((currentBeat + i*wiggleOffset) * math.pi)
        receptor.angle = arrowAngles
        if i % 2 == 0 then receptor.angle = -arrowAngles end
	end
end

function beatHit (beat)
    print ("beat")
    if beat % 2 == 1 then
        susWiggleAmp = 0.1
    end
    if curStep >= 191 and curStep < 239 then
        if beat % 2 == 0 then
            wiggleAmp = 0.05
        end
    end
    if beat % 16 == 15 then
        arrowAngles = 360
    end
end

function stepHit (step)
	
end

function lerp(pos,tar,perc)
	return pos+((tar-pos)*perc)
end

print("Mod Chart script loaded :)")