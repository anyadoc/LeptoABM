; Leptospirosis in Marginalized Urban Communities
;r- is for rodents
;ds- is for stray dogs
;do- is for owned dogs
;h- is for humans
;HH- is for household
;e- is for patches (environment)
globals
[ ;for Household
  HH-xcor
  HH-ycor
  year                           ;resets when a year has passed            ;ABelsare: instead now a year counter, not a week counter
  week                           ;counter for weeks; resets to 1 after 52  ;ABelsare: replaces year in the previous version
  ;owned dogs
  ;od-init-prev                  ;prevalence of dog serovar in dogs at setup AB 14Jan18 now a reporter
  ;stray dogs
  ;sd-init-prev                  ;prevalence of dog serovar in dogs at setup AB 14Jan18 now a reporter
  ;rodents
  ;r-init-prev                    ;prevalence of a rodent serovar in rodents at setup AB 14Jan18 now a reporter
  r-death-prob-juv
  r-death-prob-adult
  r-birth-prob-low
  r-birth-prob-high
  ;humans
  ;h-death-prob                               ;AB 14Jan18 now an agent variable (humans)
  ;h-birth-prob                               ;AB 14Jan18 now an agent variable (humans)
  h-incident-case-seroD
  h-incident-case-seroR
;  p0-dogs
;  p1-dogs
;  p2-dogs
;  p3-dogs
;  p4-dogs
;  p5-dogs
  human-dl-inc
  human-dl-inc-per10000
  human-rl-inc
  human-rl-inc-per10000
  human-dl-pre
  human-rl-pre
  sdog-dl-pre
  sdog-rl-pre
  odog-dl-pre
  odog-rl-pre
  rodent-rl-pre
  rodent-dl-pre
  cum-human-pop
  avg-annual-human-pop
  ann-human-dl-inc-per10000
  cum-ann-human-dl-inc
  ann-human-rl-inc-per10000
  cum-ann-human-rl-inc
]

breed [ rodents rodent ]
breed [ HHs HH ]
breed [ odogs odog ]
breed [ sdogs sdog ]
breed [ humans human ]

patches-own
[
  p-inf-dog                                                ;probability that a host on the patch would be infected with the dog serovar
  p-inf-rod                                                ;probability that a host on the patch would be infected with the rodent serovar
  e-contaminated-from-dog-d                                ;patch contaminated from a dog with dog servoar
  e-contaminated-from-dog-r                                ;patch contaminated from a dog with rodent serovar
  e-contaminated-from-rod-d                                ;patch contaminated from a rodent with dog serovar
  e-contaminated-from-rod-r                                ;patch contaminated from a rodent with rodent serovar
  e-amount-seroD-d                                         ;amount of dog serovar from dog on patch
  e-amount-seroD-r                                         ;amount of dog serovar from rodent on patch
  e-amount-seroR-d                                         ;amount of rodent serovar from dog on patch
  e-amount-seroR-r                                         ;amount of rodent serovar from rodent on patch
  e-amount-seroD                                           ;total number of dog serovar leptospires on patch
  e-amount-seroR                                           ;total number of rodent serovar leptospires on patch
  count-odogs-here
]

rodents-own
[
  r-start-patch                                            ;the center of the rodents' homerange
  r-home-range                                             ;distance for home range
  r-HH-id                                                  ;rodent's assigned HH
  r-age                                                    ;rodent age for juvenile or adult
  r-SIR-dog-S
  r-SIR-dog-I
  r-SIR-dog-Shed
  r-SIR-dog-R
  r-SIR-rod-S
  r-SIR-rod-I
  r-SIR-rod-Shed
  r-SIR-rod-R
  r-days-shed-dog
  r-days-shed-rod
  r-shed-init-dog
  r-shed-init-rod
  r-days-recovered
  r-incub-pd-dog
  r-days-incub-dog
  r-rate-decay-dog
  r-incub-pd-rod
  r-days-incub-rod
  r-rate-decay-rod
]

odogs-own
[
  od-start-patch                                            ;the center of the dogs' homerange
  od-home-range                                             ;distance for home range
  ;od-HH-id                                                  ;dog's assigned HH; AB 14Jan18 this dog variable does not appear anywhere in the code.
  od-age
  d-SIR-dog-S
  d-SIR-dog-I
  d-SIR-dog-Shed
  d-SIR-dog-R
  d-SIR-rod-S
  d-SIR-rod-I
  d-SIR-rod-Shed
  d-SIR-rod-R
  ;d-birth-prob                                  ;ABelsare 14Jan18 now a reporter
  d-death-prob
  d-days-shed-dog
  d-days-shed-rod
  d-shed-init-dog
  d-shed-init-rod
  d-days-recovered
  d-incub-pd-dog
  d-days-incub-dog
  d-rate-decay-dog
  d-incub-pd-rod
  d-days-incub-rod
  d-rate-decay-rod
]
sdogs-own
[
  sd-start-patch                                             ;the center of the dogs' homerange
  sd-home-range                                              ;distance for home range
  sd-HH-id                                                   ;dog's assigned HH
  sd-age
  d-SIR-dog-S
  d-SIR-dog-I
  d-SIR-dog-Shed
  d-SIR-dog-R
  d-SIR-rod-S
  d-SIR-rod-I
  d-SIR-rod-Shed
  d-SIR-rod-R
  ;d-birth-prob                                     ;ABelsare 14Jan18 now a reporter
  d-death-prob
  d-days-shed-dog
  d-days-shed-rod
  d-shed-init-dog
  d-shed-init-rod
  d-days-recovered
  d-incub-pd-dog
  d-days-incub-dog
  d-rate-decay-dog
  d-incub-pd-rod
  d-days-incub-rod
  d-rate-decay-rod
]
humans-own
[
  h-HH-id
  h-SIR-dog-S
  h-SIR-dog-I
  h-SIR-dog-R
  h-SIR-rod-S
  h-SIR-rod-I
  h-SIR-rod-R
  h-days-inf-dog
  h-days-inf-rod
  h-prob-move
  h-start-patch
  ;h-birth-prob
  h-death-prob
]
HHs-own
[ HH-id ]

to setup
  ca
  set year 0                                                                 ;sets initial year to zero  ;10July17 AVB
  set week 0                                                                 ;10July17 AVB
; ------ SET GLOBALS -----
  ;set od-init-prev 0.04
  ;set sd-init-prev 0.04
  ;set r-init-prev 0.17
;  set p0-dogs 0.47
;  set p1-dogs 0.47 + 0.27
;  set p2-dogs 0.47 + 0.27 + 0.11
;  set p3-dogs 0.47 + 0.27 + 0.11 + 0.08
;  set p4-dogs 0.47 + 0.27 + 0.11 + 0.08 + 0.05
;  set p5-dogs 1.0
  ;set d-birth-prob (0.0769)
  ;set d-death-prob (0.0228)
  ;set od-birth-prob (0.131)
  ;set od-death-prob (0.0228)
  ;set sd-birth-prob (0.2078)
  ;set sd-death-prob (0.0651)
  ;set r-birth-prob-high (0.6027)
  ;set r-birth-prob-low (0.2063)
  ;set r-death-prob-juv (0.0830)
  ;set r-death-prob-adult (0.0957)
  ;set h-birth-prob (0.000266)
  ;set h-death-prob (0.000266)
  ;Households
  set HH-xcor [50 54 58 62 66 70 74 78 82 86 90 94 98 102 106]
  set HH-ycor [58 62 66 70 74 78 82 86 90 94]
;------------------------------------------------------------------ END SET GLOBALS---------------------------------------------------
  let prob-list [ 0.47 0.27 0.11 0.08 0.05 ]                         ;ABelsare 14Jan18
  let p0-dogs item 0 prob-list
  let p1-dogs item 0 prob-list + item 1 prob-list
  let p2-dogs item 0 prob-list + item 1 prob-list + item 2 prob-list
  let p3-dogs item 0 prob-list + item 1 prob-list + item 2 prob-list + item 3 prob-list
  let p4-dogs item 0 prob-list + item 1 prob-list + item 2 prob-list + item 3 prob-list + item 4 prob-list
  let i 0
  repeat (length HH-xcor)
  [ let j 0
    repeat (length HH-ycor)
    [ create-HHs 1                                                     ;creates HH with the following variables
      [ set HH-id (i + 1 + (length HH-xcor) * j)
        setxy (item i HH-xcor) (item j HH-ycor)
        set color yellow
        set size 1
        set shape "square"
        let p-dogs-allowed random-float 1
        if p-dogs-allowed < p0-dogs [ set count-odogs-here 0 ]
        if p-dogs-allowed > p0-dogs and p-dogs-allowed <= p1-dogs [ set count-odogs-here 1 ]
        if p-dogs-allowed > p1-dogs and p-dogs-allowed <= p2-dogs [ set count-odogs-here 2 ]
        if p-dogs-allowed > p2-dogs and p-dogs-allowed <= p3-dogs [ set count-odogs-here 3 ]
        if p-dogs-allowed > p3-dogs and p-dogs-allowed <= p4-dogs [ set count-odogs-here 4 ]
        if p-dogs-allowed > p4-dogs [ set count-odogs-here 5 ]
        set j (j + 1)
        ]
      ]
    set i (i + 1)
    ]
  if h-init != 0 [
    create-humans h-init
    [ set shape "person"
      set color blue
      set size 2
      set h-HH-id random (length HH-xcor * length HH-ycor)
      setxy [ xcor ] of HH h-HH-id [ ycor ] of HH h-HH-id
      set h-start-patch patch-here
      ;set h-birth-prob 0.000266                                             ;AB 14Jan18 not sure why this was a global variable before. Now using to-report.
      set h-death-prob 0.000266                                              ;AB 14Jan18 not sure why this was a global variable before. Now an agent variable.
      set h-SIR-dog-S TRUE
      set h-SIR-dog-I FALSE
      set h-SIR-dog-R FALSE
      set h-SIR-rod-S TRUE
      set h-SIR-rod-I FALSE
      set h-SIR-rod-R FALSE
      set h-days-inf-dog 0
      set h-days-inf-rod 0
      set h-prob-move 0.50 ]
    ]
  ask patches [
    let num-odogs count-odogs-here
    if (num-odogs > 0) [
      sprout-odogs num-odogs [
        set shape "wolf"
        set color gray
        set size 2
        set od-start-patch patch-here
        set od-age random 53 ;abs (random-normal 0 52)                 ;AB 14Jan18  set od-age abs (random-normal 0 52)-This does not assign age between 0 and 52!
        set od-home-range 25
        set d-SIR-dog-S TRUE
        set d-SIR-dog-I FALSE
        set d-SIR-dog-Shed FALSE
        set d-SIR-dog-R FALSE
        set d-SIR-rod-S TRUE
        set d-SIR-rod-I FALSE
        set d-SIR-rod-Shed FALSE
        set d-SIR-rod-R FALSE
        set d-days-shed-dog 0
        set d-days-shed-rod 0
        ;set d-birth-prob (0.1480)                                      ;AB 14Jan18 now a reporter
        set d-death-prob (0.0228)
        ;let od-infected-init (random-float 1)
        if random-float 1 < od-init-prev [
          ;if (od-infected-init < od-init-prev) [
          set d-SIR-dog-I TRUE
          set d-incub-pd-dog 3 + random 12 ;random (18) + 3                          ;AB 14Jan18 as per the manuscript (table 5) this should be 3-14 days
          set d-days-incub-dog 0
          set d-shed-init-dog abs ((random-normal 59000 10000) * 900)
          set d-days-shed-dog 0
          set d-rate-decay-dog (0.15 + random-float 0.2)
          set d-SIR-dog-S FALSE
          ]
        ]
      ]
    ]
  if sd-init != 0 [
    create-sdogs sd-init [
      set shape "wolf"
      set color gray
      set size 2
      let xloc 30 + random 97
      let yloc 38 + random 77
      setxy xloc yloc                                            ;AB 30Oct17 random-xcor random-ycor
      set sd-start-patch patch xloc yloc
      set sd-age random 53 ;abs (random-normal 0 52)                        ;AB 14Jan18  set sd-age abs (random-normal 0 52)-This does not assign age between 0 and 52!
      set sd-home-range 50
      set d-SIR-dog-S TRUE
      set d-SIR-dog-I FALSE
      set d-SIR-dog-Shed FALSE
      set d-SIR-dog-R FALSE
      set d-SIR-rod-S TRUE
      set d-SIR-rod-I FALSE
      set d-SIR-rod-Shed FALSE
      set d-SIR-rod-R FALSE
      set d-days-shed-dog 0
      set d-days-shed-rod 0
      ;set d-birth-prob (0.1480)                                 ;AB 14Jan18 now a reporter
      set d-death-prob (0.0228)
      ;let sd-infected-init (random-float 1)
      ;if (sd-infected-init < sd-init-prev)[
      if (random-float 1 < sd-init-prev ) [
        set d-SIR-dog-I TRUE
        set d-incub-pd-dog 3 + random 12  ;(random 18 + 3)                                       ;AB 14Jan18 as per ms (table 5) this should be 3-14 days
        set d-days-incub-dog 0
        set d-shed-init-dog abs ((random-normal 59000 10000) * 900)
        set d-days-shed-dog 0
        set d-rate-decay-dog (0.15 + random-float 0.2)
        set d-SIR-dog-S FALSE ]
      ]
    ]
  if r-init != 0 [
  create-rodents r-init [
    set shape "default"
    set color white
    set size 1
    set r-HH-id random ((length HH-xcor) * (length HH-ycor))
    setxy ([ xcor ] of HH r-HH-id) ([ ycor ] of HH r-HH-id)
    set r-start-patch patch-here
    set r-home-range 5
    set r-age random 17    ;abs (random-normal 0 16)                                      ;AB 14Jan18 this does not result in values between 0 and 16!
    set r-SIR-dog-S TRUE
    set r-SIR-dog-I FALSE
    set r-SIR-dog-Shed FALSE
    set r-SIR-dog-R FALSE
    set r-SIR-rod-S TRUE
    set r-SIR-rod-I FALSE
    set r-SIR-rod-Shed FALSE
    set r-SIR-rod-R FALSE
    set r-birth-prob-high 0.6027
    set r-birth-prob-low 0.2063
    set r-death-prob-juv 0.0830
    set r-death-prob-adult 0.0957
    ;let r-infected-init (random-float 1)
    ;if (r-infected-init < r-init-prev)[
    if random-float 1 < r-init-prev [
      set r-SIR-rod-I TRUE
      set r-incub-pd-rod 7 + random 8 ;random (7) + 7                                         ;AB 14Jan18 changed to make it 7 to 14
      set r-days-incub-rod 0
      set r-shed-init-rod abs ((random-normal 6100000 1500000) * 7.58)
      set r-days-shed-rod 0
      set r-rate-decay-rod (0.15 + random-float 0.2)
      set r-SIR-rod-S FALSE
      ]
    ]
  ]
  if (Output_file? = "YES") [
    file-open (word "results/HumanLeptoIncidence.csv")
    ;if (file-exists? (word OutputFileName) = FALSE) [
    ;file-open (word OutputFileName)
    file-print "Year,AnnualDogSerovarInc/10K,AnnualRodentSerovarInc/10K"
    file-close
    ]
  ;]
  reset-ticks
end

to go
  ;ticks, time, and age
  if (week = 0 or week = 52) [
    set year year + 1
    ]                                                               ;7July17 AVB
  if (year = 12) [                                                  ;7July17 AVB
    set week 0
    stop ]
  ;set time (time + 1)                                              ;7July17 AVB inactivated
  set week (week + 1)                                               ;7July17 AVB
  if (week mod 4 = 0 and week < 53) [
    set cum-human-pop cum-human-pop + count humans
    ]
  if week = 53 [                                                   ;7July17 AVB changed year to week, and 52 to 53
    set avg-annual-human-pop cum-human-pop / 12
    set cum-human-pop 0
    set ann-human-dl-inc-per10000 round ((cum-ann-human-dl-inc / avg-annual-human-pop) * 10000)
    set ann-human-rl-inc-per10000 round ((cum-ann-human-rl-inc / avg-annual-human-pop) * 10000)
    set cum-ann-human-dl-inc 0
    set cum-ann-human-rl-inc 0
    set week 1   ;set year 0                                       ;7July17 AVB changed set year 0 to set week 1
    if (Output_file? = "YES") [
      ;file-open (word OutputFileName)
      file-open (word "results/HumanLeptoIncidence.csv")
      file-type (year - 1) file-type "," file-type ann-human-dl-inc-per10000 file-type "," file-type ann-human-rl-inc-per10000
      file-print""
      file-close
      ]
    ]
  ask odogs [
    od-die
    od-birth                                                    ;ABelsare_edits: if (od-age > 52)[ if (week >= 37 and week <= 52)[od-birth]]
    od-go
    set od-age (od-age + 1)
    ]
  ask sdogs [
    sd-die
    sd-birth
    sd-go
    set sd-age (sd-age + 1)
    ]
  ask rodents [
    r-die
    r-birth
    r-go
    set r-age (r-age + 1)
    ]
  ask humans [
    h-die
    h-birth
    h-go
    ]
  ask patches [ e-decay ]
;----------------------------------Incidence in humans-------------------
  let humans-dl humans with [ h-SIR-dog-I = TRUE ]
  let humans-rl humans with [ h-SIR-rod-I = TRUE ]
  set human-dl-inc precision (count humans-dl / count humans) 3
  set human-rl-inc precision (count humans-rl / count humans) 3
  set-current-plot "Human_Lepto_incidence"
  set-current-plot-pen "SeroD"
  plotxy ticks human-dl-inc
  set-current-plot-pen "SeroR"
  plotxy ticks human-rl-inc
;-----------------------------------Prevalence in humans----------------
  let humans-dl-pre humans with [ h-SIR-dog-R = TRUE ]
  let humans-rl-pre humans with [ h-SIR-rod-R = TRUE ]
  set human-dl-pre precision (count humans-dl-pre / count humans) 3
  set human-rl-pre precision (count humans-rl-pre / count humans) 3
  set-current-plot "Human_Lepto_prevalence"
  set-current-plot-pen "SeroD"
  plotxy ticks human-dl-pre
  set-current-plot-pen "SeroR"
  plotxy ticks human-rl-pre
;-------------------------------Prevalence in dogs-------------------
;-------------------------------stray dogs-------------------------
  let sdogs-dl-pre sdogs with [ d-SIR-dog-R = TRUE ]
  let sdogs-rl-pre sdogs with [ d-SIR-rod-R = TRUE ]
  set sdog-dl-pre precision (count sdogs-dl-pre / count sdogs) 3
  set sdog-rl-pre precision (count sdogs-rl-pre / count sdogs) 3
  set-current-plot "StrayDog_Lepto_prevalence"
  set-current-plot-pen "SeroD"
  plotxy ticks sdog-dl-pre
  set-current-plot-pen "SeroR"
  plotxy ticks sdog-rl-pre
;------------------------------------owned dogs------------------------
  let odogs-dl-pre odogs with [ d-SIR-dog-R = TRUE ]
  let odogs-rl-pre odogs with [ d-SIR-rod-R = TRUE ]
  set odog-dl-pre precision (count odogs-dl-pre / count odogs) 3
  set odog-rl-pre precision (count odogs-rl-pre / count odogs) 3
  set-current-plot "OwnedDog_Lepto_prevalence"
  set-current-plot-pen "SeroD"
  plotxy ticks odog-dl-pre
  set-current-plot-pen "SeroR"
  plotxy ticks odog-rl-pre
;-----------------------rodents---------------------------------------
  let rodents-rl-pre rodents with [ r-SIR-rod-I = TRUE or r-SIR-rod-Shed = TRUE ];AB changed 30/10 [r-SIR-rod-R = TRUE]
                                                                               ;BECAUSE ONCE INFECTED WITH RODENT SEROVAR, RODENTS ARE PERMANENTLY INFECTED
  let rodents-dl-pre rodents with [ r-SIR-dog-R = TRUE ]
  set rodent-rl-pre precision (count rodents-rl-pre / count rodents) 3
  set rodent-dl-pre precision (count rodents-dl-pre / count rodents) 3
  set-current-plot "Rodents_Lepto_prevalence"
  set-current-plot-pen "SeroD"
  plotxy ticks rodent-dl-pre
  set-current-plot-pen "SeroR"
  plotxy ticks rodent-rl-pre
  tick
end
;---------- OWNED DOGS -----------
to od-die
  if (random-float 1 < (d-death-prob * (count odogs / od-init)))[die]
;  let Nod (count odogs)
;  let d-death (random-float 1)
;  if (d-death < d-death-prob * Nod / od-init)
;  [
;    die
;    ]
end
to od-birth
  if week >= 37 and week <= 52 [                                              ;10July17 AVB year changed to week
    if od-age > 52 [
      if (random-float 1 < d-birth-prob * (od-init / count odogs)) [
        ;let Nod (count odogs)                                                 ;ABelsare_edits: redundant
        ;let od-birth-p (random-float 1)                                       ;ABelsare_edits: redundant
        ;if (od-birth-p < d-birth-prob * od-init / Nod)                        ;ABelsare_edits: change to if (random-float 1 < d-birth-prob * od-init / count odogs
        ;[
        hatch 1 [; hatch replacement dogs
          set shape "wolf"
          set color gray
          set size 2
          set od-start-patch [od-start-patch] of myself
          set od-home-range 25
          set d-SIR-dog-S TRUE
          set d-SIR-dog-I FALSE
          set d-SIR-dog-Shed FALSE
          set d-SIR-dog-R FALSE
          set d-SIR-rod-S TRUE
          set d-SIR-rod-I FALSE
          set d-SIR-rod-Shed FALSE
          set d-SIR-rod-R FALSE
          set d-days-shed-dog 0
          set d-days-shed-rod 0
          ;set d-birth-prob 0.1480                                              ;AB 14Jan18 now a reporter
          set d-death-prob 0.0228
          ]
        ]
      ]
    ]
end
to od-go
  repeat 7 [
    move-to od-start-patch
    move-to one-of patches in-radius (random-poisson 5)
    d-get-infected
    d-shed
    ]
end
;-------- STRAY DOGS -----------------
to sd-die
  if random-float 1 < d-death-prob * (count sdogs / sd-init) [ die ]
;  let Nsd (count sdogs)
;  let d-death (random-float 1)
;  if (d-death < d-death-prob * Nsd / sd-init) [die]
end
to sd-birth
  move-to sd-start-patch                                               ;30Oct17 AVB
  if week >= 37 and week <= 52 [                                       ;10July17 AVB year changed to week
    if sd-age > 52 [
      if (random-float 1 < (d-birth-prob * (sd-init / count sdogs))) [
        ;let Nsd (count sdogs)                                         ;ABelsare_edits: redundant
        ;let sd-birth-p (random-float 1)                               ;ABelsare_edits: redundant
        ;if (sd-birth-p < d-birth-prob * sd-init / Nsd)                ;ABelsare_edits: change to if (random-float 1 < d-birth-prob * sd-init / count sdogs)
        ;[
        hatch 1 [
          set shape "wolf"
          set color gray
          set size 2
          setxy [ xcor ] of myself [ ycor ] of myself     ;random-xcor random-ycor
          set sd-start-patch patch-here
          set sd-home-range 25 ;50
          set d-SIR-dog-S TRUE
          set d-SIR-dog-I FALSE
          set d-SIR-dog-Shed FALSE
          set d-SIR-dog-R FALSE
          set d-SIR-rod-S TRUE
          set d-SIR-rod-I FALSE
          set d-SIR-rod-Shed FALSE
          set d-SIR-rod-R FALSE
          ;set d-birth-prob 0.1480                                   ;ABelsare 14Jan18 now a reporter
          set d-death-prob 0.0429
          ]
        ]
      ]
    ]
end
to sd-go
  repeat 7 [
    move-to sd-start-patch
    move-to one-of patches in-radius sd-home-range
    d-get-infected
    d-shed
    ]
end
to d-get-infected
  ;ABelsare_edit: as per the code, if both serovars are present on a patch, a dog will be infected with dog serovar
  ;17Aug17 changed code so that equal chances of getting infected with either serovar.
  let serovar-list []
  if (any? odogs-here with [ d-SIR-dog-Shed = TRUE ]) or (any? sdogs-here with [ d-SIR-dog-Shed = TRUE ]) [
    set serovar-list lput "dog-serovar" serovar-list
    ]
  if (any? odogs-here with [ d-SIR-rod-Shed = TRUE ]) or (any? sdogs-here with [ d-SIR-rod-Shed = TRUE ])[
    set serovar-list lput "rodent-serovar" serovar-list
    ]
  set serovar-list lput "patch-dog-serovar" serovar-list
  set serovar-list lput "patch-rodent-serovar" serovar-list
  set serovar-list shuffle serovar-list
  while [ empty? serovar-list = FALSE ] [
    let prob-infection item 0 serovar-list
    if (prob-infection = "dog-serovar") [ prob-infection-dogserovar ]
    if (prob-infection = "rodent-serovar") [ prob-infection-rodentserovar ]
    if (prob-infection = "patch-dog-serovar") [ prob-infection-pdogserovar ]
    if (prob-infection = "patch-rodent-serovar") [ prob-infection-prodentserovar ]
    set serovar-list remove-item 0 serovar-list
    ]
end
to prob-infection-dogserovar
  if (d-SIR-dog-S = TRUE and d-SIR-rod-I = FALSE and d-SIR-rod-Shed = FALSE) [;d-SIR-rod-S = TRUE) [; AB 14Jan18 changed as dog resistant to rod serovar can get infected by dog serovar   ;;17Aug17 ABelsare_edits: added and d-SIR-rod-S = TRUE to prevent coinfection
    ;if (any? odogs-here with [d-SIR-dog-Shed = TRUE]) or (any? sdogs-here with [d-SIR-dog-Shed = TRUE])[ ;;ABelsare_edits: POTENTIAL ERROR HERE: SHOULD BE any? odogs-here
      ;let prob-inf (random-float 1)                           ;ABelsare_edits:redundant
      ;if prob-inf < 0.01
    if (random-float 1 < 0.01) [
      set d-SIR-dog-I TRUE
      ;set d-incub-pd-dog random (18) + 3                ;AB 14Jan18 redundant- this agent variable is already set when dogs are created
      set d-days-incub-dog 0
      set d-shed-init-dog abs((random-normal 59000 10000) * 900)
      set d-days-shed-dog 0
      set d-rate-decay-dog (0.15 + random-float 0.2)
      set d-SIR-dog-S FALSE
      set d-death-prob (d-death-prob * 1)               ;18Aug17 ABelsare_edits: changed from 1.1 to 1 as no change in baseline death rate
                                                        ; if dog is infected with seroD;; also changed set d-death-prob (0.0429 * 1) to set d-death-prob (d-death-prob * 1)
      ]
    ]
end
to prob-infection-pdogserovar
  if (d-SIR-dog-S = TRUE and d-SIR-rod-I = FALSE and d-SIR-rod-Shed = FALSE) [;d-SIR-rod-S = TRUE) [ ; AB 14Jan18 changed so that rod resistant dogs can get infected with dog serovar         ;17Aug17 ABelsare_edits: only susceptible dogs get infected from the patch
    if (random-float 1 < p-inf-dog) [
      set d-SIR-dog-I TRUE
      ;set d-incub-pd-dog random (18) + 3                                ;AB 14Jan18 redundant this agent variable is already set when dogs are created
      set d-days-incub-dog 0
      set d-shed-init-dog abs((random-normal 59000 10000) * 900)
      set d-days-shed-dog 0
      set d-rate-decay-dog (0.15 + random-float 0.2)
      set d-SIR-dog-S FALSE
      set d-death-prob (d-death-prob * 1)                              ;18Aug17 ABelsare_edits: changed from 1.1 to 1 as no change in baseline death rate
                                                                       ; if dog is infected with seroD;; also ;;18Aug17 ABelsare_edits:set d-death-prob d-death-prob * 1
      ]
    ]
end
to prob-infection-rodentserovar
  if (d-SIR-rod-S = TRUE and d-SIR-dog-I = FALSE and d-SIR-dog-Shed = FALSE) [;d-SIR-dog-S = TRUE) [;AB 14Jan18 modified     ;17Aug17 ABelsare_edits: added ..and d-SIR-dog-S = TRUE ...to prevent coinfection
    ;if (any? odogs-here with [d-SIR-rod-Shed = TRUE]) or (any? sdogs-here with [d-SIR-rod-Shed = TRUE]) [   ;;ABelsare_edits: POTENTIAL ERROR HERE: should be any? odogs-here.
      ;let prob-inf (random-float 1)      ;17Aug17 ABelsare_edits redundant
      ;if prob-inf < 0.01
      if (random-float 1 < 0.01) [
        set d-SIR-rod-I TRUE
        set d-incub-pd-rod 3 + random 19 ;random (11) + 3        ;AB 14Jan18 should be 3-21, changed accordingly
        set d-days-incub-rod 0
        set d-shed-init-rod abs((random-normal 59000 10000) * 900)
        set d-days-shed-rod 0
        set d-rate-decay-rod (0.3 + random-float 0.4)
        set d-SIR-rod-S FALSE
        set d-death-prob (d-death-prob * 1.1)                               ;18Aug17 ABelsare_edits:set d-death-prob d-death-prob * 1.1
        ]
      ]
end
to prob-infection-prodentserovar
  if (d-SIR-rod-S = TRUE and d-SIR-dog-I = FALSE and d-SIR-dog-Shed = FALSE) [;d-SIR-dog-S = TRUE) [ ;AB 14Jan18 modified
    ;let prob-inf (random-float 1)
    if (random-float 1 < p-inf-rod) [
      set d-SIR-rod-I TRUE
      set d-incub-pd-rod 3 + random 19 ;random (11) + 3                     ;AB 14Jan18 should be 3-21, changed accordingly
      set d-days-incub-rod 0
      set d-shed-init-rod abs((random-normal 59000 10000) * 900)
      set d-days-shed-rod 0
      set d-rate-decay-rod (0.3 + random-float 0.4)
      set d-SIR-rod-S FALSE
      set d-death-prob (d-death-prob * 1.1)                                     ;18Aug17 ABelsare_edits:set d-death-prob d-death-prob * 1.1
      ]
    ]
end
to d-shed
  ; Dog shedding dog serovar
  if d-SIR-dog-I = TRUE and d-days-incub-dog < d-incub-pd-dog [
    set d-days-incub-dog d-days-incub-dog + 1
  ]
  if d-SIR-dog-I = TRUE and d-days-incub-dog = d-incub-pd-dog [
    set d-SIR-dog-Shed TRUE
    set d-days-shed-dog 0
    set d-SIR-dog-I FALSE
 ]
  if d-SIR-dog-Shed = TRUE and d-days-shed-dog <= 3 [
    set d-days-shed-dog d-days-shed-dog + 1
    let new-amt-shed (d-shed-init-dog * (d-days-shed-dog / 3))
    ask patch-here [
      set e-contaminated-from-dog-d TRUE
      set e-amount-seroD-d e-amount-seroD-d + new-amt-shed
      set e-amount-seroD e-amount-seroD + new-amt-shed
      ]
    ]
  if d-SIR-dog-Shed = TRUE and d-days-shed-dog > 3 and d-days-shed-dog <= 10 [
    set d-days-shed-dog d-days-shed-dog + 1
    let new-amt-shed d-shed-init-dog
    ask patch-here [
      set e-contaminated-from-dog-d TRUE
      set e-amount-seroD-d e-amount-seroD-d + new-amt-shed
      set e-amount-seroD e-amount-seroD + new-amt-shed
      ]
    ]
  if d-SIR-dog-Shed = TRUE and d-days-shed-dog > 10 [
    set d-days-shed-dog d-days-shed-dog + 1
    let new-amt-shed (d-shed-init-dog * (exp (- d-rate-decay-dog * (d-days-shed-dog - 10))))
    ifelse new-amt-shed < 100
    [ set d-SIR-dog-Shed FALSE
      set d-SIR-dog-R TRUE
      set d-days-recovered 0 ]
    [ ask patch-here [
      set e-contaminated-from-dog-d TRUE
      set e-amount-seroD-d e-amount-seroD-d + new-amt-shed
      set e-amount-seroD e-amount-seroD + new-amt-shed ]
    ]
    ]
  if d-SIR-dog-R = TRUE [
   if (d-days-recovered < 365) [
     set d-days-recovered d-days-recovered + 1
     ]
   if (d-days-recovered = 365) [
     set d-SIR-dog-R FALSE
     set d-SIR-dog-S TRUE
     ]
  ]
  ;Dog Shedding Rodent Serovar
  if d-SIR-rod-I = TRUE and d-days-incub-rod < d-incub-pd-rod [
    set d-days-incub-rod d-days-incub-rod + 1 ]
  if d-SIR-rod-I = TRUE and d-days-incub-rod = d-incub-pd-rod [
    set d-SIR-rod-Shed TRUE
    set d-days-shed-rod 0
    set d-SIR-rod-I FALSE ]
  if d-SIR-rod-Shed = TRUE and d-days-shed-rod <= 3 [
    set d-days-shed-rod d-days-shed-rod + 1
    let new-amt-shed (d-shed-init-rod * (d-days-shed-rod / 3))
    ask patch-here [
      set e-contaminated-from-dog-r TRUE
      set e-amount-seroR-d e-amount-seroR-d + new-amt-shed
      set e-amount-seroR e-amount-seroR + new-amt-shed
      ]
    ]
  if (d-SIR-rod-Shed = TRUE and d-days-shed-rod > 3 and d-days-shed-rod <= 10) [
    set d-days-shed-rod d-days-shed-rod + 1
    let new-amt-shed d-shed-init-rod
    ask patch-here [
      set e-contaminated-from-dog-r TRUE
      set e-amount-seroR-d e-amount-seroR-d + new-amt-shed
      set e-amount-seroR e-amount-seroR + new-amt-shed
      ]
    ]
  if (d-SIR-rod-Shed = TRUE and d-days-shed-rod > 10) [
   set d-days-shed-rod d-days-shed-rod + 1
   let new-amt-shed (d-shed-init-rod * (exp (- d-rate-decay-rod * (d-days-shed-rod - 10))))
   ifelse new-amt-shed < 100
   [ set d-SIR-rod-Shed FALSE
     set d-SIR-rod-R TRUE ]                                             ;ABelsare_edits: do Recoverds (d-SIR-rod-R) remain recoverds for ever?
   [ ask patch-here [
     set e-contaminated-from-dog-r TRUE
     set e-amount-seroR-d e-amount-seroR-d + new-amt-shed
     set e-amount-seroR e-amount-seroR + new-amt-shed ]
   ]
   ]
end
;---------RODENTS------------
to r-die
  let Nr (count rodents)
  if r-age < 8 [
    ;let r-death (random-float 1)
    ;if (r-death < r-death-prob-juv * Nr / r-init)
    if (random-float 1 < r-death-prob-juv * Nr / r-init) [
      die
      ]
    ]
  if r-age >= 8 [
    ;let r-death (random-float 1)
    ;if (r-death < r-death-prob-adult * Nr / r-init)
    if (random-float 1 < r-death-prob-adult * Nr / r-init) [
      die
      ]
    ]
end
to r-birth
  let Nr (count rodents)
  if week > 12 and week <= 38 [                                                           ;10July17 AVB replaced year with week
    ;if r-age >= 8
    ;[
    let r-birth-p (random-float 1) * 4
    if (r-birth-p < r-birth-prob-low * r-init / Nr) [
      hatch 1                                                   ; hatch replacement rodents
      [ set shape "default"
        set color white
        set size 1
        set r-HH-id random ((length HH-xcor) * (length HH-ycor))
        setxy [ xcor ] of HH r-HH-id [ ycor ] of HH r-HH-id
        set r-start-patch patch-here
        set r-home-range 5
        set r-age 0
        set r-SIR-dog-S TRUE
        set r-SIR-dog-I FALSE
        set r-SIR-dog-Shed FALSE
        set r-SIR-dog-R FALSE
        set r-SIR-rod-S TRUE
        set r-SIR-rod-I FALSE
        set r-SIR-rod-Shed FALSE
        set r-SIR-rod-R FALSE
        set r-birth-prob-high (0.6027)
        set r-birth-prob-low (0.2063)
        set r-death-prob-juv (0.0830)
        set r-death-prob-adult (0.0957)
        ]
      ]
    ]
  if week <= 12 or week > 38 [                                                     ;10July17 AVB replaced year with week
    let r-birth-p (random-float 1) * 4
    if (r-birth-p < r-birth-prob-high * r-init / Nr) [
      hatch 1 [
        set shape "default"
        set color white
        set size 1
        set r-HH-id random ((length HH-xcor) * (length HH-ycor))
        setxy [ xcor ] of HH r-HH-id [ ycor ] of HH r-HH-id
        set r-start-patch patch-here
        set r-home-range 5
        set r-age 0
        set r-SIR-dog-S TRUE
        set r-SIR-dog-I FALSE
        set r-SIR-dog-Shed FALSE
        set r-SIR-dog-R FALSE
        set r-SIR-rod-S TRUE
        set r-SIR-rod-I FALSE
        set r-SIR-rod-Shed FALSE
        set r-SIR-rod-R FALSE
        ]
      ]
    ]
end
to r-go
  repeat 7 [
    move-to r-start-patch
    move-to one-of patches in-radius r-home-range
    r-get-infected
    r-shed
    ]
end
to r-get-infected
  ;ABelsare_edit: as per the code, if both serovars are present on a patch, a rodent will be infected with dog serovar.
  ;17Aug17 changed code so that equal chances of getting infected with either serovar.
  let rserovar-list []
  if (any? rodents-here with [ r-SIR-dog-Shed = TRUE ]) [
    set rserovar-list lput "dog-serovar" rserovar-list
    ]
  if (any? rodents-here with [ r-SIR-rod-Shed = TRUE ]) [
    set rserovar-list lput "rodent-serovar" rserovar-list
    ]
  set rserovar-list lput "patch-dog-serovar" rserovar-list
  set rserovar-list lput "patch-rodent-serovar" rserovar-list
  set rserovar-list shuffle rserovar-list
  while [ empty? rserovar-list = FALSE ] [
    let prob-infection item 0 rserovar-list
    if (prob-infection = "dog-serovar") [ prob-infection-rdogserovar ]
    if (prob-infection = "rodent-serovar") [ prob-infection-rrodentserovar ]
    if (prob-infection = "patch-dog-serovar") [ prob-infection-rpdogserovar ]
    if (prob-infection = "patch-rodent-serovar") [ prob-infection-rprodentserovar ]
    set rserovar-list remove-item 0 rserovar-list
    ]
end
to prob-infection-rdogserovar
  if (r-SIR-dog-S = TRUE and r-SIR-rod-S = TRUE) [   ;18Aug17 ABelsare_edits: added and r-SIR-rod-S = TRUE to prevent coinfection
    if (random-float 1 < 0.01) [
      set r-SIR-dog-I TRUE
      set r-incub-pd-dog 7 + random 8    ;random (7) + 7   ;AB 14Jan18 changed code to get a value between 7 and 14
      set r-days-incub-dog 0
      set r-shed-init-dog abs((random-normal 6100000 1500000) * 7.58)
      set r-days-shed-dog 0
      set r-rate-decay-dog (0.3 + random-float 0.4)
      set r-SIR-dog-S FALSE
      ]
    ]
end
to prob-infection-rpdogserovar
  if (r-SIR-dog-S = TRUE and r-SIR-rod-S = TRUE) [           ;18Aug17 ABelsare_edits: only susceptible dogs get infected from the patch
    if (random-float 1 < p-inf-dog) [
      set r-SIR-dog-I TRUE
      set r-incub-pd-dog 7 + random 8       ;random (7) + 7  ;AB 14Jan18 changed code to get a vlue between 7 and 14
      set r-days-incub-dog 0
      set r-shed-init-dog abs((random-normal 6100000 1500000) * 7.58)
      set r-days-shed-dog 0
      set r-rate-decay-dog (0.3 + random-float 0.4)
      set r-SIR-dog-S FALSE
      ]
    ]
end
to prob-infection-rrodentserovar
  if (r-SIR-rod-S = TRUE and r-SIR-dog-S = TRUE) [     ;18Aug17 ABelsare_edits: added ..and r-SIR-dog-S = TRUE ...to prevent coinfection
    if (random-float 1 < 0.01) [
      set r-SIR-rod-I TRUE
      set r-incub-pd-rod 7 + random 8 ;random (7) + 7
      set r-days-incub-rod 0
      set r-shed-init-rod abs((random-normal 6100000 1500000) * 7.58)
      set r-days-shed-rod 0
      set r-rate-decay-rod (0.15 + random-float 0.2)
      set r-SIR-rod-S FALSE
      ]
    ]
end
to prob-infection-rprodentserovar
  if (r-SIR-rod-S = TRUE and r-SIR-dog-S = TRUE) [    ;18Aug17 ABelsare_edits added r-SIR-dog-S = TRUE to prevent coinfection
    if (random-float 1 < p-inf-rod) [
      set r-SIR-rod-I TRUE
      set r-incub-pd-rod 7 + random 8 ;random (7) + 7
      set r-days-incub-rod 0
      set r-shed-init-rod abs((random-normal 6100000 1500000) * 7.58)
      set r-days-shed-rod 0
      set r-rate-decay-rod (0.15 + random-float 0.2)
      set r-SIR-rod-S FALSE
      ]
    ]
end
to r-shed
  ;;Rodent shedding dog serovar
  if r-SIR-dog-I = TRUE[                                ;ABelsare_edits_18Aug17
    ifelse (r-days-incub-dog < r-incub-pd-dog)
    [ set r-days-incub-dog r-days-incub-dog + 1 ]
    [ set r-SIR-dog-Shed True
      set r-days-shed-dog 0
      set r-SIR-dog-I FALSE ]
    ]
  if r-SIR-dog-Shed = TRUE [
    let new-amt-shed 0
    if r-days-shed-dog <= 3 [
      set r-days-shed-dog r-days-shed-dog + 1
      set new-amt-shed (r-shed-init-dog * (r-days-shed-dog / 3 ))
      ]
    if (r-days-shed-dog > 3 and r-days-shed-dog <= 10) [
      set r-days-shed-dog r-days-shed-dog + 1
      set new-amt-shed r-shed-init-dog
      ]
    if (r-SIR-dog-Shed = TRUE and r-days-shed-dog > 10) [
      set r-days-shed-dog r-days-shed-dog + 1
      set new-amt-shed (r-shed-init-dog * (exp (- r-rate-decay-dog * (r-days-shed-dog - 10))))
      ]
    ifelse (new-amt-shed < 100)
    [ set r-SIR-dog-Shed FALSE
      set r-SIR-dog-R TRUE ]
    [ ask patch-here [
      set e-contaminated-from-rod-d TRUE
      set e-amount-seroD-r e-amount-seroD-r + new-amt-shed
      set e-amount-seroD e-amount-seroD + new-amt-shed ]
    ]
    ]
  ;Rodent shedding rodent serovar
  if (r-SIR-rod-I = TRUE) [
    ifelse (r-days-incub-rod < r-incub-pd-rod)
    [ set r-days-incub-rod r-days-incub-rod + 1 ]
    [ set r-SIR-rod-SHED TRUE
      set r-days-shed-rod 0
      set r-SIR-rod-I FALSE ]
    ]
  if r-SIR-rod-Shed = TRUE [
    let new-amt-shed 0
    if r-days-shed-rod <= 3 [
      set r-days-shed-rod r-days-shed-rod + 1
      set new-amt-shed r-shed-init-rod * (r-days-shed-rod / 3)
      ]
    if r-days-shed-rod > 3 and r-days-shed-rod <= 10 [
      set r-days-shed-rod r-days-shed-rod + 1
      set new-amt-shed r-shed-init-rod
      ]
    if r-days-shed-rod > 10 [
      set r-days-shed-rod r-days-shed-rod + 1
      set new-amt-shed r-shed-init-rod * (exp (- r-rate-decay-rod * (r-days-shed-rod - 10)))
      ]
    if r-days-shed-rod > (12) [
      set r-days-shed-rod 3
      ]
    ask patch-here [
      set e-contaminated-from-rod-r TRUE
      set e-amount-seroR-r e-amount-seroR-r + new-amt-shed
      set e-amount-seroR e-amount-seroR + new-amt-shed
      ]
    ]
end
;---------- HUMANS -------------
to h-die
  if (random-float 1 < h-death-prob * (count humans / h-init)) [ die ]
  ;let Nh (count humans)
  ;let h-death (random-float 1)
  ;if (h-death < h-death-prob * Nh / h-init) [
    ;die
    ;]
end
to h-birth
  if (random-float 1 < h-birth-prob * (h-init / count humans))[
;    let Nh (count humans)
;    let h-birth-p (random-float 1)
;    if (h-birth-p < h-birth-prob * h-init / Nh)
      ;[
    hatch 1 [
      set shape "person"
      set color blue
      set size 2
      set h-HH-id random ((length HH-xcor) * (length HH-ycor))
      setxy [ xcor ] of HH h-HH-id [ycor] of HH h-HH-id
      set h-SIR-dog-S TRUE
      set h-SIR-dog-I FALSE
      set h-SIR-dog-R FALSE
      set h-SIR-rod-S TRUE
      set h-SIR-rod-I FALSE
      set h-SIR-rod-R FALSE
      set h-days-inf-dog 0
      set h-days-inf-rod 0
      ;set h-birth-prob 0.000266                                                  ;AB 14Jan18 now using to-report
      set h-death-prob 0.000266
      set h-prob-move 0.50
      set h-start-patch patch-here ]
    ]
end
to h-go
  repeat 7 [
    move-to h-start-patch
    ifelse (random-float 1 < h-prob-move)
    ;let prob-move (random-float 1)
    ;ifelse (prob-move < h-prob-move)
    [ move-to one-of patches in-radius 10 ]
    [ move-to one-of patches ]
    h-get-infected
    h-shed
    ]
end
to h-get-infected
  if h-SIR-dog-S = TRUE [
    if random-float 1 < (p-inf-dog / 100) [
      ;let prob-inf (random-float 1)
      ;if prob-inf < (p-inf-dog / 100)[
      set h-SIR-dog-I TRUE
      if (week < 53) [ set cum-ann-human-dl-inc cum-ann-human-dl-inc + 1 ]
      set h-days-inf-dog (random 28 + 2)
      set h-SIR-dog-S FALSE
      set h-death-prob h-death-prob * 1.1 ;0.000266 * 1.1     ;AB code change as h-death-prob is now an agent variable
      set h-incident-case-seroD h-incident-case-seroD + 1
      ]
    ]
  if h-SIR-rod-S = TRUE [
    if (random-float 1 < (p-inf-rod / 100)) [
      ;let prob-inf (random-float 1)
      ;if prob-inf < (p-inf-rod / 100)[
      set h-SIR-rod-I TRUE
      if (week < 53) [ set cum-ann-human-rl-inc cum-ann-human-rl-inc + 1 ]
      set h-days-inf-rod 2 + random 29 ;random (28) + 2       ;AB 14Jan18 changed to get a value between 2 and 30
      set h-SIR-rod-S FALSE
      set h-death-prob h-death-prob * 1.1    ;0.000266 * 1.1      ;AB Code change as h-death-prob is now an agent variable
      set h-incident-case-seroR h-incident-case-seroR + 1
      ]
    ]
end
to h-shed
  if h-SIR-dog-I = TRUE and h-days-inf-dog < 43 [
    set h-days-inf-dog h-days-inf-dog + 1
  ]
  if h-SIR-dog-I = TRUE and h-days-inf-dog = 43 [
    set h-SIR-dog-I FALSE
    set h-SIR-dog-R TRUE
    ]
  if h-SIR-rod-I = TRUE and h-days-inf-rod < 43 [
    set h-days-inf-rod h-days-inf-rod + 1
    ]
  if h-SIR-rod-I = TRUE and h-days-inf-rod = 43 [
    set h-SIR-rod-I FALSE
    set h-SIR-rod-R TRUE
    ]
end
to e-decay
   repeat 7
   [ set p-inf-rod (e-amount-seroR * 0.01 / 10 ^ 7)
     set p-inf-dog (e-amount-seroD * 0.01 / 10 ^ 7)
     set e-amount-seroD e-amount-seroD * 0.8
     set e-amount-seroR e-amount-seroR * 0.8
     set e-amount-seroD-d e-amount-seroD-d * 0.8
     set e-amount-seroR-d e-amount-seroR-d * 0.8
     set e-amount-seroD-r e-amount-seroD-r * 0.8
     set e-amount-seroR-r e-amount-seroR-r * 0.8
     ]
   if e-amount-seroD < 1000 [
     set e-amount-seroD 0
     set e-amount-seroD-d 0
     set e-amount-seroD-r 0
     set e-contaminated-from-dog-d FALSE
     set e-contaminated-from-rod-d FALSE
     ]
   if e-amount-seroR < 1000 [
     set e-amount-seroR 0
     set e-amount-seroR-r 0
     set e-amount-seroR-d 0
     set e-contaminated-from-dog-r FALSE
     set e-contaminated-from-rod-r FALSE
     ]
 end
to-report h-birth-prob
  report 0.000266
end
to-report d-birth-prob
  report 0.1480
end
to-report od-init-prev
  report 0.04
end
to-report sd-init-prev
  report 0.04
end
to-report r-init-prev
  report 0.17
end
@#$#@#$#@
GRAPHICS-WINDOW
201
10
662
472
-1
-1
3.0
1
10
1
1
1
0
0
0
1
0
150
0
150
0
0
1
ticks
30.0

BUTTON
15
10
90
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
13
95
185
128
od-init
od-init
0
500
155.0
5
1
NIL
HORIZONTAL

BUTTON
123
10
187
44
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1372
332
1558
457
Owned Dog Abundance
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"owned dogs" 1.0 0 -16777216 true "" "plot count odogs"
"dog w/ rodent serovar" 1.0 0 -2674135 true "" "plot count odogs with [d-SIR-rod-Shed = TRUE]"
"dog w/ dog serovar" 1.0 0 -14439633 true "" "plot count odogs with [d-SIR-dog-Shed = TRUE]"

SLIDER
13
52
185
85
r-init
r-init
0
5000
500.0
50
1
NIL
HORIZONTAL

PLOT
1370
62
1555
194
Rodent Abundance
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"rodents" 1.0 0 -16777216 true "" "plot count rodents"
"rodents w/ rod serovar" 1.0 0 -2674135 true "" "plot count rodents with [r-SIR-rod-Shed = TRUE]"
"rodents w/ dog serovar" 1.0 0 -13840069 true "" "plot count rodents with [r-SIR-dog-Shed = TRUE]"

SLIDER
14
137
186
170
sd-init
sd-init
0
500
160.0
5
1
NIL
HORIZONTAL

PLOT
669
71
903
199
Infected Patch Prevalence
NIL
NIL
0.0
10.0
0.0
0.1
true
true
"" ""
PENS
"SeroD" 1.0 0 -2674135 true "" "plot (count patches with [p-inf-dog > 0.0025] / count patches)"
"SeroR" 1.0 0 -13345367 true "" "plot (count patches with [p-inf-rod > 0.0025] / count patches)"

SLIDER
14
181
186
214
h-init
h-init
0
1000
615.0
1
1
NIL
HORIZONTAL

MONITOR
674
10
731
55
Year
year
17
1
11

MONITOR
741
10
796
55
Week
week
17
1
11

PLOT
669
207
904
327
Human_Lepto_incidence
NIL
NIL
0.0
1.0
0.0
0.001
true
true
"" ""
PENS
"SeroD" 1.0 0 -2674135 true "" ""
"SeroR" 1.0 0 -13345367 true "" ""

MONITOR
917
258
1095
303
SeroD incidence in humans
human-dl-inc
17
1
11

MONITOR
917
309
1094
354
SeroR incidence in humans
human-rl-inc
17
1
11

PLOT
669
337
904
460
Human_Lepto_prevalence
NIL
NIL
0.0
10.0
0.0
0.001
true
true
"" ""
PENS
"SeroD" 1.0 0 -2674135 true "" ""
"SeroR" 1.0 0 -13345367 true "" ""

MONITOR
919
361
1066
406
SeroD prevalence in humans
human-dl-pre
17
1
11

MONITOR
919
413
1068
458
SeroR prevalence in humans
human-rl-pre
17
1
11

PLOT
1116
333
1361
463
OwnedDog_Lepto_prevalence
NIL
NIL
0.0
10.0
0.0
0.1
true
true
"" ""
PENS
"SeroD" 1.0 0 -2674135 true "" ""
"SeroR" 1.0 0 -13345367 true "" ""

PLOT
1116
64
1363
194
Rodents_Lepto_prevalence
NIL
NIL
0.0
10.0
0.0
0.1
true
true
"" ""
PENS
"SeroD" 1.0 0 -2674135 true "" ""
"SeroR" 1.0 0 -13345367 true "" ""

PLOT
1372
199
1555
328
Stray Dog Abundance
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"stray dogs" 1.0 0 -16777216 true "" "plot count sdogs"
"dogs w/ rodent serovar" 1.0 0 -2674135 true "" "plot count sdogs with [d-SIR-rod-Shed = TRUE]"
"dogs w/ dog serovar" 1.0 0 -13840069 true "" "plot count sdogs with [d-SIR-dog-Shed = TRUE]"

MONITOR
1117
10
1202
55
NIL
rodent-rl-pre
17
1
11

MONITOR
916
153
1095
198
Human SeroD incidence per 10000
round (ann-human-dl-inc-per10000)
17
1
11

MONITOR
916
205
1096
250
Human SeroR incidence per 10000
round (ann-human-rl-inc-per10000)
17
1
11

CHOOSER
13
243
185
288
Output_file?
Output_file?
"YES" "NO"
0

MONITOR
1208
10
1296
55
NIL
rodent-dl-pre
17
1
11

PLOT
1116
200
1364
327
StrayDog_Lepto_prevalence
NIL
NIL
0.0
10.0
0.0
0.1
true
true
"" ""
PENS
"SeroD" 1.0 0 -2674135 true "" ""
"SeroR" 1.0 0 -13345367 true "" ""

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Model Validation - Baseline Model 062316" repetitions="12" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>GO</go>
    <timeLimit steps="520"/>
    <metric>count sdogs</metric>
    <metric>count sdogs with [d-SIR-dog-Shed = TRUE] / count sdogs</metric>
    <metric>count sdogs with [d-SIR-rod-Shed = TRUE] / count sdogs</metric>
    <metric>count sdogs with [(d-SIR-dog-Shed = FALSE) and (d-SIR-rod-Shed = FALSE)] / count sdogs</metric>
    <metric>count odogs</metric>
    <metric>count odogs with [d-SIR-dog-Shed = TRUE] / count odogs</metric>
    <metric>count odogs with [d-SIR-rod-Shed = TRUE] / count odogs</metric>
    <metric>count odogs with [(d-SIR-dog-Shed = FALSE) and (d-SIR-rod-Shed = FALSE)] / count odogs</metric>
    <metric>count humans</metric>
    <metric>h-incident-case-seroR</metric>
    <metric>h-incident-case-seroD</metric>
    <metric>count humans with [h-SIR-rod-I = TRUE]</metric>
    <metric>count humans with [h-SIR-dog-I = TRUE]</metric>
    <metric>count humans with [h-SIR-rod-I = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-dog-I = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-rod-R = TRUE]</metric>
    <metric>count humans with [h-SIR-dog-R = TRUE]</metric>
    <metric>count humans with [h-SIR-rod-R = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-dog-R = TRUE] / count humans</metric>
    <metric>count rodents</metric>
    <metric>count rodents with [r-SIR-dog-Shed = TRUE] / count rodents</metric>
    <metric>count rodents with [r-SIR-rod-Shed = TRUE] / count rodents</metric>
    <metric>count rodents with [(r-SIR-dog-Shed = FALSE) and (r-SIR-rod-Shed = FALSE)] / count rodents</metric>
    <metric>count patches with [e-amount-seroR &gt; 10000] / count patches</metric>
    <metric>count patches with [e-amount-seroR &gt; 100000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 10000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 100000] / count patches</metric>
    <metric>count patches with [e-contaminated-from-dog-d = TRUE] / count patches</metric>
    <metric>count patches with [e-contaminated-from-dog-r = TRUE] / count patches</metric>
    <metric>count patches with [e-contaminated-from-rod-d = TRUE] / count patches</metric>
    <metric>count patches with [e-contaminated-from-rod-r = TRUE] / count patches</metric>
    <enumeratedValueSet variable="r-init">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="od-init">
      <value value="225"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="h-init">
      <value value="650"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sd-init">
      <value value="225"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Model Validation - Baseline Model 062316_V2" repetitions="12" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>GO</go>
    <timeLimit steps="520"/>
    <metric>count sdogs</metric>
    <metric>count sdogs with [d-SIR-dog-Shed = TRUE] / count sdogs</metric>
    <metric>count sdogs with [d-SIR-rod-Shed = TRUE] / count sdogs</metric>
    <metric>count sdogs with [(d-SIR-dog-Shed = FALSE) and (d-SIR-rod-Shed = FALSE)] / count sdogs</metric>
    <metric>count odogs</metric>
    <metric>count odogs with [d-SIR-dog-Shed = TRUE] / count odogs</metric>
    <metric>count odogs with [d-SIR-rod-Shed = TRUE] / count odogs</metric>
    <metric>count odogs with [(d-SIR-dog-Shed = FALSE) and (d-SIR-rod-Shed = FALSE)] / count odogs</metric>
    <metric>count humans</metric>
    <metric>h-incident-case-seroR</metric>
    <metric>h-incident-case-seroD</metric>
    <metric>count humans with [h-SIR-rod-I = TRUE]</metric>
    <metric>count humans with [h-SIR-dog-I = TRUE]</metric>
    <metric>count humans with [h-SIR-rod-I = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-dog-I = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-rod-R = TRUE]</metric>
    <metric>count humans with [h-SIR-dog-R = TRUE]</metric>
    <metric>count humans with [h-SIR-rod-R = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-dog-R = TRUE] / count humans</metric>
    <metric>count rodents</metric>
    <metric>count rodents with [r-SIR-dog-Shed = TRUE] / count rodents</metric>
    <metric>count rodents with [r-SIR-rod-Shed = TRUE] / count rodents</metric>
    <metric>count rodents with [(r-SIR-dog-Shed = FALSE) and (r-SIR-rod-Shed = FALSE)] / count rodents</metric>
    <metric>count patches with [e-amount-seroR &gt; 10000] / count patches</metric>
    <metric>count patches with [e-amount-seroR &gt; 100000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 10000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 100000] / count patches</metric>
    <metric>count patches with [e-contaminated-from-dog-d = TRUE] / count patches</metric>
    <metric>count patches with [e-contaminated-from-dog-r = TRUE] / count patches</metric>
    <metric>count patches with [e-contaminated-from-rod-d = TRUE] / count patches</metric>
    <metric>count patches with [e-contaminated-from-rod-r = TRUE] / count patches</metric>
    <enumeratedValueSet variable="r-init">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="od-init">
      <value value="225"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="h-init">
      <value value="650"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sd-init">
      <value value="225"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Model Validation - Baseline Model 070416" repetitions="52000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>GO</go>
    <timeLimit steps="600"/>
    <metric>count sdogs</metric>
    <metric>count sdogs with [d-SIR-dog-Shed = TRUE] / count sdogs</metric>
    <metric>count sdogs with [d-SIR-rod-Shed = TRUE] / count sdogs</metric>
    <metric>count sdogs with [(d-SIR-dog-Shed = FALSE) and (d-SIR-rod-Shed = FALSE)] / count sdogs</metric>
    <metric>count odogs</metric>
    <metric>count odogs with [d-SIR-dog-Shed = TRUE] / count odogs</metric>
    <metric>count odogs with [d-SIR-rod-Shed = TRUE] / count odogs</metric>
    <metric>count odogs with [(d-SIR-dog-Shed = FALSE) and (d-SIR-rod-Shed = FALSE)] / count odogs</metric>
    <metric>count humans</metric>
    <metric>h-incident-case-seroR</metric>
    <metric>h-incident-case-seroD</metric>
    <metric>count humans with [h-SIR-rod-I = TRUE]</metric>
    <metric>count humans with [h-SIR-dog-I = TRUE]</metric>
    <metric>count humans with [h-SIR-rod-I = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-dog-I = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-rod-R = TRUE]</metric>
    <metric>count humans with [h-SIR-dog-R = TRUE]</metric>
    <metric>count humans with [h-SIR-rod-R = TRUE] / count humans</metric>
    <metric>count humans with [h-SIR-dog-R = TRUE] / count humans</metric>
    <metric>count rodents</metric>
    <metric>count rodents with [r-SIR-dog-Shed = TRUE] / count rodents</metric>
    <metric>count rodents with [r-SIR-rod-Shed = TRUE] / count rodents</metric>
    <metric>count rodents with [(r-SIR-dog-Shed = FALSE) and (r-SIR-rod-Shed = FALSE)] / count rodents</metric>
    <metric>count patches with [e-amount-seroR &gt; 1000] / count patches</metric>
    <metric>count patches with [e-amount-seroR &gt; 10000] / count patches</metric>
    <metric>count patches with [e-amount-seroR &gt; 100000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 1000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 10000] / count patches</metric>
    <metric>count patches with [e-amount-seroD &gt; 100000] / count patches</metric>
    <metric>sum [e-amount-seroD] of patches</metric>
    <metric>sum [e-amount-seroD-d] of patches</metric>
    <metric>sum [e-amount-seroD-r] of patches</metric>
    <metric>sum [e-amount-seroR] of patches</metric>
    <metric>sum [e-amount-seroR-d] of patches</metric>
    <metric>sum [e-amount-seroR-r] of patches</metric>
    <enumeratedValueSet variable="r-init">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="od-init">
      <value value="155"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="h-init">
      <value value="615"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sd-init">
      <value value="155"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
