use_random_seed 1127
big_now = 6000
small_now = 600 #ten minutes
the_now = 6

tonics = [60, 67, 62, 69, 64, 71, 66, 73, 68, 63, 70, 65].ring
set :Root, 60

############################
major = [-24,-17,-13,-12,-10,-8,-7,-5,-3,-1,0,2,4,5,7,9,11]
harmonicminor = [-24,-17,-13,-12,-10,-9,-7,-5,-4,-1,0,2,3,5,7,8,11]
octatonic = [-24,-17,-11,-9,-8,-6,-5,-3,-2,0,1,3,4,6,7,9,10]
wholetone = [-24,-18,-16,-10,-8,-6,-4,-2,0,2,4,6,8,10]
messiansix = [-24,-19,-12,-10,-8,-7,-6,-4,-2,-1,0,2,4,5,6,8,10,11]
scales = [major, major, major, major, major, harmonicminor, harmonicminor, harmonicminor,octatonic,wholetone,messiansix]
#################################

define :modulate do
  k = 0
  set :Root, tonics[k]
  set :Scale, major
  loop do
    if one_in(10)
      k = k+choose([-1,-1,1,1,1,4])
      set :Root, tonics[k]
    end
    if one_in(50)
      sca = choose(scales)
      set :Scale, sca
    end
    sleep big_now/small_now
  end
end

############################
define :conductor do
  drkamb_onoff = 1
  set :drkamb_onoff, drkamb_onoff
  klimba_onoff = 0
  set :klimba_onoff, klimba_onoff
  pno_onoff = 0
  set :pno_onoff, pno_onoff
  plucky_onoff = 0
  set :plucky_onoff, plucky_onoff
  proph_onoff = 0
  set :proph_onoff, proph_onoff
  organ_onoff = 0
  set :organ_onoff, organ_onoff
  hollo_onoff = 0
  set :hollo_onoff, hollo_onoff
  
  busyness = 1
  busynesses = [0, 0, 1, 1, 1, 2, 2, 3]
  density = 1
  densities = [0, 0, 1, 1, 1, 2, 2, 3]
  
  
  
  loop do
    short_voices = get[:klimba_onoff] + get[:pno_onoff] + get[:plucky_onoff]
    long_voices = get[:proph_onoff] + get[:organ_onoff] + get[:hollo_onoff]
    voices = short_voices + long_voices
    
    if one_in(small_now)
      busyness = choose(busynesses)
      puts "busyness"
      puts busyness
    end
    
    short_discrepancy = (busyness-short_voices).abs
    
    if one_in(small_now)
      density = choose(densities)
      puts "density"
      puts density
    end
    
    long_discrepancy = (density - long_voices).abs
    
    if voices == 0
      if get[:drkamb_onoff] == 0
        set :drkamb_onoff, 1
      end
    else
      if get[:drkamb_onoff] == 1
        set :drkamb_onoff, 0
      end
    end
    
    
    if one_in( (((small_now) * (1 + klimba_onoff) / (1 + 7*(short_discrepancy**2))).round) )
      klimba_onoff = (klimba_onoff-1).abs
      set :klimba_onoff, klimba_onoff
    end
    
    if one_in( (((small_now) * (1 + pno_onoff) / (1 + 7*(short_discrepancy**2))).round) )
      pno_onoff = (pno_onoff-1).abs
      set :pno_onoff, pno_onoff
    end
    
    if one_in( (((small_now) * (1 + plucky_onoff) / (1 + 7*(short_discrepancy**2))).round) )
      plucky_onoff = (plucky_onoff-1).abs
      set :plucky_onoff, plucky_onoff
    end
    
    if one_in( (((small_now) * (1 + proph_onoff) / (1 + 7*(long_discrepancy**2))).round))
      proph_onoff = (proph_onoff-1).abs
      set :proph_onoff, proph_onoff
    end
    
    if one_in( (((small_now) * (1 + organ_onoff) / (1 + 7*(long_discrepancy**2))).round))
      organ_onoff = (organ_onoff-1).abs
      set :organ_onoff, organ_onoff
    end
    
    if one_in( (((small_now) * (1 + hollo_onoff) / (1 + 7*(long_discrepancy**2))).round))
      hollo_onoff = (hollo_onoff-1).abs
      set :hollo_onoff, hollo_onoff
    end
    
    sleep ((small_now/4).round)
  end
end

###################

in_thread do
  modulate
end
in_thread do
  conductor
end

##########################
########################## Voices

####################
### Dark Ambience
define :drkamb do |n|
  drkamb_act = get[:drkamb_onoff]
  use_synth(:dark_ambience)
  loop do
    if drkamb_act != get[:drkamb_onoff]
      puts "dark ambient transition"
      if one_in(3)
        drkamb_act = (drkamb_act - 1).abs
      end
    end
    if drkamb_act == 1
      length1=rrand(20,50)
      length2=rrand(30,60)
      pan = rand(-0.75..0.75)
      if one_in(10)
        a=choose([2,-2])
        pan = rrand(-0.75, 0.75)
        play n+(a/2), amp: 0.4, attack: rrand(0.5,1), sustain: rrand(1,2), release: rrand(1,2),pan: pan
        sleep 3
        play n+a, amp: 0.3, sustain: length1, attack: rrand(0.5,1), release: rrand(1,2), pan: pan*(1.1)
        n = n+a
        sleep length1 + 3
      else
        a=choose([1,-1])
        play n, amp: 0.3, sustain: length2, attack: 1, release: 1, pan: rrand(-0.8, 0.8)
        n = n+choose([-1,1])
        sleep length2 + 3
      end
    else
      sleep big_now/small_now
    end
  end
end

##############

in_thread do
  drkamb 60
end
in_thread do
  drkamb 60
end
in_thread do
  drkamb 60
end
in_thread do
  drkamb 48
end
in_thread do
  drkamb 48
end
in_thread do
  drkamb 36
end
in_thread do
  drkamb 41
end
in_thread do
  drkamb 67
end


####################
### Kalimba

define :klimba do
  use_synth(:kalimba)
  klmba_act = get[:klimba_onoff]
  loop do
    if klmba_act != get[:klimba_onoff]
      puts "kalimba transition"
      if one_in(10)
        klmba_act = (klmba_act - 1).abs
      end
    end
    
    if klmba_act == 1
      play 12 + get[:Root] + get[:Scale].sample, amp: 0.6, pan: rrand(-0.8,0.8), clickiness: 1
      sleep rrand(4, 20)
    else
      sleep big_now/small_now
    end
  end
end

##############
in_thread do
  klimba
end
in_thread do
  klimba
end
in_thread do
  klimba
end
in_thread do
  klimba
end

####################
### Prophet

define :cutoffwander do
  CO = 90
  set :cutoff, CO
  a=1
  loop do
    if one_in(5)
      CO=CO+a
      set :cutoff,CO
    end
    if (CO-90).abs > 10
      a = -a
    end
    sleep 10
  end
end

define :proph do
  
  use_synth(:prophet)
  proph_act = get[:proph_onoff]
  loop do
    if proph_act != get[:proph_onoff]
      puts "prophet transition"
      if one_in(3)
        proph_act = (proph_act - 1).abs
      end
    end
    if proph_act == 1
      sv = get[:klimba_onoff] + get[:pno_onoff] + get[:plucky_onoff]
      lv = get[:organ_onoff] + get[:hollo_onoff]
      length1=rand(10..70)
      pan = rand(-0.75..0.75)
      Root = get[:Root]
      play Root+choose(major), amp: 0.6+rrand(-0.05, 0.05)-0.05*sv-0.05*lv, sustain: length1/2, release: length1, pan: pan, cutoff: get[:cutoff], attack: rand_i(0..2)
      sleep length1/2
    else
      sleep big_now/small_now
    end
  end
end

##############
in_thread do
  cutoffwander
end
in_thread do
  proph
end
in_thread do
  proph
end
in_thread do
  proph
end
in_thread do
  proph
end
in_thread do
  proph
end

####################
### Organ

define :organ do
  use_synth(:organ_tonewheel)
  organ_act = get[:organ_onoff]
  pan = -0.99
  loop do
    if organ_act != get[:organ_onoff]
      puts "organ transition"
      if one_in(3)
        organ_act = (organ_act-1).abs
      end
    end
    if organ_act == 1
      length1=rand(10..15)
      Root = get[:Root]
      a = (1-pan.abs)*0.6
      play [Root+choose(get[:Scale]), Root+choose(get[:Scale])],
        amp: a, sustain: length1/2, release: length1/8, pan: pan+rrand(-a,a), attack: (length1/4)*pan.abs
      sleep length1/2+rrand(1,3)
      pan = pan + rrand(0.05,0.15)
      if pan > 1
        pan = pan-2
      end
    else
      sleep big_now/small_now
    end
  end
end

##############
in_thread do
  organ
end
in_thread do
  organ
end
in_thread do
  organ
end
in_thread do
  organ
end

####################
### Piano

define :ratewalk do
  shortlength = 30
  set :SLn, shortlength
  a= 1
  climbchance = 3-a
  
  loop do
    if get[:pno_onoff] == 1
      
      if one_in(small_now)
        a = -a
      end
      
      if one_in(climbchance)
        shortlength = shortlength*(1-a*0.1)
        set :SLn, shortlength
      end
      
      if shortlength < 0.5
        if shortlength < 0.1
          a = -1
          climbchance = 2
        else
          climbchance = 3-a
        end
      end
      
      if shortlength > 100
        a = 1
        climbchance = 2
      else
        climbchance = 3-a
      end
      sleep 1
    end
    sleep(big_now/small_now)
  end
end


define :pno do
  use_synth(:piano)
  pno_act = get[:pno_onoff]
  loop do
    if pno_act != get[:pno_onoff]
      puts "piano transition"
      if one_in(10)
        pno_act = (pno_act-1).abs
      end
    end
    if pno_act == 1
      SLn = get[:SLn]
      Root = get[:Root]
      play Root + choose(get[:Scale]),amp: 0.6,sustain: rand(SLn..3*SLn),release: rand(SLn..3*SLn),pan: rand(-0.9..0.9)
      sleep rand(SLn..3*SLn)
    else
      sleep big_now/small_now
    end
  end
end
##############
in_thread do
  ratewalk
end

in_thread do
  pno
end

in_thread do
  pno
end

####################
### Hollow

define :hollo do
  use_synth(:hollow)
  hollo_act = get[:hollo_onoff]
  loop do
    if hollo_act != get[:hollo_onoff]
      puts "hollow transition"
      if one_in(3)
        hollo_act = (hollo_act - 1).abs
      end
    end
    if hollo_act == 1
      R = get[:Root]
      L = get[:Scale].length
      s = play (R+get[:Scale][rand_i(0..4)]),attack: 10,release: 15,note_slide: 10,note_slide_shape: 7,pan: 0,pan_slide: 10
      u = play (R+get[:Scale][rand_i(0..4)]),attack: 10,release: 15,note_slide: 10,note_slide_shape: 7,pan: 0,pan_slide: 10
      t = play (R+get[:Scale][rand_i(0..4)]),attack: 10,release: 15,note_slide: 10,note_slide_shape: 7,pan: -0.3,pan_slide: 10
      v = play (R+choose(get[:Scale])),attack: 10,release: 15,note_slide: 10,note_slide_shape: 7,pan: 0.3,pan_slide: 10
      sleep 10
      control s,note: (R+get[:Scale][rand_i(6..12)]),pan: -0.75
      control t,note: (R+get[:Scale][rand_i(6..12)]),pan: 0.75
      control u,note: (R+get[:Scale][rand_i(6..12)]),pan: -0.5
      control v,note: (R+choose(get[:Scale])),pan: 0.5
      sleep 10
    else
      sleep big_now/small_now
    end
  end
end

##############
in_thread do
  hollo
end

##############
### Plucky

define :plucky do
  use_synth(:pluck)
  plucky_act = get[:plucky_onoff]
  loop do
    if plucky_act != get[:plucky_onoff]
      puts "pluck transition"
      plucky_act = (plucky_act-1).abs
    end
    if plucky_act == 1
      length1=rrand(0.05,2)
      pan = rand(-0.1..0.1)
      L = get[:Scale].length
      note = rand_i(6..L-1)
      coef = rrand(0.2,0.6)
      Root = get[:Root]
      while note > 0
        play Root+get[:Scale][note],amp: 0.6,sustain: length1*(L-note)/2,release: length1*(L-note)/2,pan: pan,coef: coef
        sleep length1*rrand(2,4)
        note = note-1
        length1=length1*(0.9)
        pan = pan*(1.1)
      end
      sleep length1
    else
      sleep big_now/small_now
    end
  end
end

###################
in_thread do
  plucky
end
in_thread do
  plucky
end
in_thread do
  plucky
end
