wiggle = -1
susWiggle = -1
wiggleAmp = 0
susWiggleAmp = 0
wiggleOffset = 0.05
wiggleToOffset = 0.05


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

    local currentBeat = (songPos / 1000)*(bpm/60)
	for i=0,3 do
		--setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
		setActorY(_G['receptor'..i..'Y'] + 8 * math.cos((currentBeat + i*wiggleOffset) * math.pi), i)
	end
    for i=4,7 do
		--setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
		setActorY(_G['receptor'..i..'Y'] + 8 * -math.cos((currentBeat + i*wiggleOffset) * math.pi), i)
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
end

function stepHit (step)
	
end

function lerp(pos,tar,perc)
	return pos+((tar-pos)*perc)
end

print("Mod Chart script loaded :)")