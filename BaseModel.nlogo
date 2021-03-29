;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------ This is the main code file. It defines the types of entities and refers to the other files for how to run the model.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


__includes [ "SetupStuff.nls" "GoStuff.nls"]          ; This is the command to include other files, and these files must be in the same folder that this file is in.

globals
[
                                                      ;there are no global variables other than the ones given in the interface (with the sliders)
]


;; create types (these are the categories of agents)
breed
[scientists scientist]         ; these are the agents that produce their own research
breed
[media medium]                 ; in this model, the only medium is the propagandist
breed
[policy_makers policy_maker]   ; these are the agents that have a credence, but don't produce any research
undirected-link-breed
[colleagues colleague]         ; these are the connections between scientists
undirected-link-breed
[communications communication] ; these are are all of the other connections




;; define agent attributes (any agent in one of these classes has their own value for each of these)
scientists-own
[
  credence    ; the scientist's belief this round that Arm B is better than 50%
  B_results   ; a list of successes/failures that represents the result of pulling Arm B n times this round
  my_k        ; number of successes that this particular scientist has created this round
  k           ; total number of successes a  scientist is aware of
  n           ; total number of trials a scientist is aware of
  logodd      ; a different way to look at credence: logarithm of credence in B (given evidence), divided by credence in ~B (given evidence) - used to measure degree of certainty
]
media-own
[
  info_pool   ; the set of credences of all the scientists
  pro_info    ; the results that indicate Arm B is in fact better than 50%
  con_info    ; the results that suggest Arm B is no better than 50%
  my_k        ; the sum of all the results in con_info
]
policy_makers-own
[
  credence    ; the policy_maker's belief this round that Arm B is better that 50%
  k           ; the total number of successes a policy_maker is aware of
  n           ; the total number of trials a policy_maker is aware of
  logodd      ; another way to look at credence (same as scientists)
]
colleagues-own
[
  link_info   ; the results of the other end
]
communications-own
[
  link_info   ; the results of the other end of the link
  credence_list ; the credence of the other end
]





@#$#@#$#@
GRAPHICS-WINDOW
535
52
1128
502
-1
-1
9.0
1
18
1
1
1
0
0
0
1
0
64
0
48
0
0
1
ticks
30.0

SLIDER
115
65
310
98
NumberOfScientists
NumberOfScientists
1
100
20.0
1
1
NIL
HORIZONTAL

BUTTON
315
140
405
210
SETUP
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
115
145
310
178
NumberOfPolicyMakers
NumberOfPolicyMakers
1
100
20.0
1
1
NIL
HORIZONTAL

CHOOSER
115
100
310
145
ScientistNetworkStructure
ScientistNetworkStructure
"Cyclic" "In Between" "Complete"
0

BUTTON
280
260
480
295
GO ONCE
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
135
510
310
555
LabelsDisplayed
LabelsDisplayed
"Credence level" "Log of odds" "ID number"
1

BUTTON
280
295
480
330
GO TILL SCIENTIFIC CONSENSUS
go_SciConsensus\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
20
295
275
328
TrialCount
TrialCount
1
500
1.0
1
1
NIL
HORIZONTAL

SLIDER
115
180
310
213
SLT
SLT
0
NumberOfScientists
1.0
1
1
NIL
HORIZONTAL

BUTTON
315
510
400
655
Refresh display
refreshDisplay
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
135
590
310
623
ShowMediaConnections?
ShowMediaConnections?
1
1
-1000

TEXTBOX
235
235
302
253
SCIENCE
15
0.0
1

TEXTBOX
230
45
326
63
POPULATION
15
0.0
1

TEXTBOX
785
25
860
45
DISPLAY:
16
0.0
1

TEXTBOX
1590
12
1670
32
OUTPUTS:
16
0.0
1

TEXTBOX
245
490
320
515
DISPLAY
15
0.0
1

PLOT
1130
410
1890
780
Average log of odds
Rounds
Log( cred./ (1-cred.) )
0.0
2.0
0.0
1.0
true
true
"" ""
PENS
"of Scientists" 1.0 0 -16777216 true "" "plot mean [logodd] of scientists"
"of Policy Makers" 1.0 0 -8990512 true "" "plot mean [logodd] of policy_makers"
"Consensus Threshold (.99)" 1.0 0 -5298144 true "" "plot .99"

SWITCH
135
555
310
588
ShowScienceNetwork?
ShowScienceNetwork?
1
1
-1000

SWITCH
135
625
310
658
ShowStoPConnections?
ShowStoPConnections?
1
1
-1000

BUTTON
195
730
365
763
ITERATE
iterate
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
195
700
365
733
strength
strength
2
10
4.0
1
1
NIL
HORIZONTAL

BUTTON
315
65
405
135
CLEAR
clear-all
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
20
260
275
293
Epsilon
Epsilon
.05
.5
0.01
.01
1
NIL
HORIZONTAL

BUTTON
280
330
480
365
GO TILL PM CONSENSUS
go_PMConsensus
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
265
430
425
463
DoubleCount?
DoubleCount?
0
1
-1000

PLOT
1130
55
1890
405
Average credence
Rounds
Credence
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"of Scientists" 1.0 0 -16777216 true "" "plot mean [credence] of scientists"
"of Policy Makers" 1.0 0 -11221820 true "" "plot mean [credence] of policy_makers"
"Consensus Threshold" 1.0 0 -5298144 true "" "plot .99"

SLIDER
20
330
275
363
ConsensusThreshold
ConsensusThreshold
1
10
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
250
680
330
698
ITERATE
15
0.0
1

PLOT
535
505
830
775
Lag Score Each Round
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
"default" 1.0 0 -16777216 true "" "plot LagScore_ER"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

MONITOR
465
730
532
775
Lag Score
precision LagScore_OT 2
17
1
11

PLOT
830
505
1125
775
Lag Score Over Time
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
"default" 1.0 0 -16777216 true "" "plot LagScore_OT"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

SWITCH
105
430
265
463
SelectiveSharing?
SelectiveSharing?
0
1
-1000

SWITCH
105
400
265
433
ScientistsStartAt1?
ScientistsStartAt1?
1
1
-1000

SWITCH
265
400
425
433
PolicyMakersStartAt1?
PolicyMakersStartAt1?
1
1
-1000

TEXTBOX
235
380
385
398
OPTIONS
15
0.0
1

@#$#@#$#@
## What's new?
LagScore

## What's recent?
Choosable ConsensusThreshold

## COMPARING TO WEATHERALL'S MODEL
•(same) Scientists only research if they have credence strictly above .5; others only listen.
•(same) Propagandists communicate all and only results strictly less than .5, ignoring others.


## WHAT IS IT?

This model is part of a series that models the effect of selective sharing on a population of ideal udpaters. It consists of scientists that research a given theory, update using Bayes', and share their results to those that have acces. There is also a community of policy makers that updates on the information in the same way. Finally, there is a propagandist who shares only the negative data from the scientists.

For details on the model, refer to O'Connor's "How to Beat Science and Influence People"

The vanilla model allows one to select ε, n, k, and slt. The other models allow one to select one of the parameters to vary, while holding the rest fixed. Two graphs are produced. One is made to show similarities and discrepensies with O'Connor's findings and measures the average credence. The other is meant to find further insights on what is going on and measures the average time taken till scientific concensus.
## HOW IT WORKS

There are few comments in the model. New users are directed here for an explanation of its workings.

Globals: 

"Graph" functions:

Setup functions:

Go functions:



## HOW TO USE IT

Choose how many scientists are present (NumberOfScientists, k).

Choose a scientific network structure (complete or cyclic.

Choose how many of those scientists are listened to (NumberOfScientistsListenedTo, slt).

Choose how many policy makers are present. (This makes no affect on the model other than robustness, because they do not affect eachother.)

Choose how many trials are run each round before updating (TrialCount, n).

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
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="20cube" repetitions="1000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <exitCondition>(min [logodd] of scientists &gt; ConsensusThreshold) or (max [credence] of scientists &lt;= .5)</exitCondition>
    <metric>mean [logodd] of policy_makers</metric>
    <steppedValueSet variable="Epsilon" first="0.01" step="0.01" last="0.2"/>
    <steppedValueSet variable="TrialCount" first="1" step="1" last="20"/>
    <enumeratedValueSet variable="NumberOfScientists">
      <value value="20"/>
    </enumeratedValueSet>
    <steppedValueSet variable="SLT" first="1" step="1" last="20"/>
    <enumeratedValueSet variable="ScientistNetworkStructure">
      <value value="&quot;Cyclic&quot;"/>
      <value value="&quot;Complete&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="NumberOfPolicyMakers">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ShowMediaConnections?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ShowScienceNetwork?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ShowStoPConnections?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DoubleCount?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="LabelsDisplayed">
      <value value="&quot;Log of odds&quot;"/>
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
1
@#$#@#$#@
