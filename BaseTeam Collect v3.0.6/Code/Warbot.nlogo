__includes [ "parameters.nls" "reds.nls" "greens.nls" ]

; definition des especes
breed [ Explorers Explorer ]
breed [ RocketLaunchers RocketLauncher ]
breed [ Harvesters Harvester ]
breed [ Bases Base ]
breed [ Missiles Missile ]
breed [ Fafs Faf ]
breed [ Burgers Burger ]
breed [ Seeds Seed ]
breed [ Walls Wall ]
breed [ Perceptions Perception ]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; definition des variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; les variables communes à tous les robots
;
turtles-own [ energy                 ;; l'energie de l'agent
              carrying-food?         ;; la quantite de nourriture transportee
              detection-range        ;; le rayon de perception
              speed                  ;; la vitesse
              fd-ok?                 ;; l'agent a-t-il le droit de se deplacer ? (un seul deplacement par tour)
              percept                ;; un agent pour visualiser la zone de perception
              my-bases               ;; les bases de l'agent
              mem0 mem1 mem2         ;; six zones memoires a utiliser pour la programmation des agents
              mem3 mem4 mem5         ;; chacune peut contenir un scalaire ou une liste de 2 valeurs
              friend                 ;; la couleur de mon équipe
              ennemy                 ;; la couleur de l'ennemi
              death-burgers          ;; le nombre de burgers relâchés à la mort d'un agent
            ]
;
; les variables specifiques aux rocket launchers
;
RocketLaunchers-own [ nb-missiles    ;; le nb de missiles transportes
                      max-missiles   ;; le nb max de missiles autorise
                      nb-fafs        ;; le nb de missiles de type "fire and forget"
                      max-fafs       ;; le nb max de missiles de type "fire and forget" autorise
                      waiting        ;; une tempo entre 2 tirs
                    ]

;
; les variables specifiques aux harvesters
;
Harvesters-own [ carried-walls-nrj    ;; l'énergie des murs transportés
               ]

;
; les variables specifiques aux bases
;
Bases-own [ nb-missiles              ;; le nb de missiles transportes
            max-missiles             ;; le nb max de missiles autorise
            nb-fafs                  ;; le nb de missiles de type "fire and forget"
            max-fafs                 ;; le nb max de missiles de type "fire and forget" autorise
            waiting                  ;; une tempo entre 2 tirs
            mem6 mem7 mem8           ;; la mémoire de la base est supérieure à celle des autres robots
            mem9 mem10 mem11         ;; chaque emplacement mémoire peut contenir une liste
            create-ok?
          ]
;
; les variables specifiques aux missiles
;
Missiles-own [ my-range ]            ;; la portee du missile
;
; les variables specifiques aux fafs
;
Fafs-own [ my-range                  ;; la portee du faf
           target                    ;; la cible du faf
         ]
;
; les variables specifiques aux perceptions (= cercles centres sur les robots pour visualiser leur sphère de perception)
;
Perceptions-own [ agt my-range ]
;
; les variables specifiques aux graines
;
Seeds-own [ age ]
Burgers-own [ burger-breed           ;; l'espèce de l'agent qui l'a créé
              who-id                 ;; l'identifiant du robot qui l'a créé
            ]

;
; les variables globales
;
globals [ victoire                     ;; 1 si victoire des verts / 2 si victoire des rouges
          duree                        ;; la duree d'une partie
          energy_green                 ;; la quantite d'energie de l'equipe verte
          energy_red                   ;; la quantite d'energie de l'equipe rouge

          wall-cost                    ;; le cout de fabrication d'un mur
          wall-nrj                     ;; l'energie initiale d'un mur
          seed-cost                    ;; le cout d'une graine
          max-seeds                    ;; la quantite max de graines par patch
          maturation-time              ;; le temps de maturation des graines
          burger-decay                 ;; la vitesse de pourrissement des burgers

          base-nrj                     ;; l'energie d'une base toute neuve
          base-perception              ;; la distance de perception d'une base
          base-speed                   ;; la vitesse d'une base
          base-nb-missiles             ;; le nombre initial de missiles
          base-max-missiles            ;; le nombre maximal de missiles
          base-nb-fafs                 ;; le nombre initial de fafs
          base-max-fafs                ;; le nombre maximal de fafs
          base-waiting                 ;; la temporisation entre 2 envois de missiles
          base-burgers                 ;; le nb de burgers créés en cas de mort d'une base

          rocket-launcher-cost         ;; le cout de fabrication d'un rocket-launcher
          rocket-launcher-nrj          ;; l'energie d'un rocket-launcher tout neuf
          rocket-launcher-perception   ;; la distance de perception d'un rocket-launcher
          rocket-launcher-speed        ;; la vitesse d'un rocket-launcher
          rocket-launcher-metabolism   ;; le metabolisme d'un rocket-launcher (consommation d'energie a chaque tour)
          rocket-launcher-nb-missiles  ;; le nombre initial de missiles
          rocket-launcher-max-missiles ;; le nombre maximal de missiles
          rocket-launcher-nb-fafs      ;; le nombre initial de fafs
          rocket-launcher-max-fafs     ;; le nombre maximal de fafs
          rocket-launcher-waiting      ;; la temporisation entre 2 envois de missiles
          rocket-launcher-burgers      ;; le nb de burgers créés en cas de mort d'un rocket-launcher

          explorer-cost                ;; le cout de fabrication d'un explorer
          explorer-nrj                 ;; l'energie d'un explorer tout neuf
          explorer-perception          ;; la distance de perception d'un explorer
          explorer-speed               ;; la vitesse d'un explorer
          explorer-metabolism          ;; le metabolisme d'un explorer (consommation d'energie a chaque tour)
          explorer-burgers             ;; le nb de burgers créés en cas de mort d'un explorer

          harvester-cost               ;; le cout de fabrication d'un harvester
          harvester-nrj                ;; l'energie d'un harvester tout neuf
          harvester-perception         ;; la distance de perception d'un harvester
          harvester-speed              ;; la vitesse d'un harvester
          harvester-metabolism         ;; le metabolisme d'un harvester (consommation d'energie a chaque tour)
          harvester-burgers            ;; le nb de burgers créés en cas de mort d'un harvester

          missile-cost                 ;; le cout de creation d'un missile
          missile-range                ;; la portee d'un missile
          missile-robot-damage         ;; les dommages d'un missile sur un robot
          missile-base-damage          ;; les dommages d'un missile sur une base
          missile-speed                ;; la vitesse d'un missile

          faf-cost                     ;; le cout de creation d'un faf
          faf-range                    ;; la portee d'un faf
          faf-robot-damage             ;; les dommages d'un faf sur un robot
          faf-base-damage              ;; les dommages d'un faf sur une base
          faf-speed                    ;; la vitesse d'un faf

          collision-damage             ;; dégâts en cas de collision

          burger-periodicity           ;; la periodicite avec laquelle les burgers sont ajoutes
          burger-quantity              ;; le nb de burgers crees a chaque fois
          wild-burger-min-nrj          ;; l'energie minimale d'un burger sauvage
          wild-burger-max-nrj          ;; l'energie maximale d'un burger sauvage
          seeded-burger-min-nrj        ;; l'energie minimale d'un burger cultive
          seeded-burger-max-nrj        ;; l'energie maximale d'un burger cultive
]

to test-int
  let i 2000000000
  show i
  while [i > 0] [set i i + 1]
  show i
end


;
; Procedure d'initialisation
;
to setup [ config ]
  ; efface tout
  clear-all
  init-parameters

  ; paramètres generaux
  set victoire 0
  ; cree 2 bases de chaque couleur
  new-Base red green 30 10
  new-Base red green 30 -10
  new-Base green red -30 10
  new-Base green red -30 -10

  ; demande aux bases de creer des robots
  ask Bases with [color = green] [
    set my-bases Bases with [ color = green ]
    ; appelle la procedure d'activation correspondant a la couleur
    initGreenBase
  ]
  ask Bases with [color = red] [
    set my-bases Bases with [ color = red ]
    ; appelle la procedure d'activation correspondant a la couleur
    initRedBase
  ]

  ; cree des obstacles
  new-random-walls

  ; ajoute de la nourriture
  repeat 3 [ new-random-burgers burger-quantity ]

  ; met à jour l'affichage des ressources globales des 2 equipes
  update_energy_watches

  reset-ticks
end

;
; Procedure principale
;
to go
  ; reinitialise la capacité de se déplacer
  ask turtles [ set fd-ok? true ]
  ; réinitialise la capacité à créer des robots ou des murs pour les bases
  ask Bases [ set create-ok? true ]
  ; si plus de bases vertes ni bleues, victoire des rouges
  if not any? Bases with [ color = green ][ print "Victoire des rouges" set victoire 1 stop ]
  ; si plus de bases rouges ni bleues, victoire des verts
  if not any? Bases with [ color = red ][ print "Victoire des verts" set victoire 2 stop ]

  ; pour tous les explorers
  ask Explorers [
    ; decremente l'energie
    set energy energy - explorer-metabolism
    ; teste s'ils sont toujours en vie
    mort
    ; affiche ou non un label sur l'agent
    display-label
    ; appelle la procedure d'activation correspondant a la couleur
    ifelse (color = green)
    [ carefully[goGreenExplorer][show error-message] ]
    [ carefully[goRedExplorer][show error-message] ]
  ]

  ; pour tous les rocket-launchers
  ask RocketLaunchers [
    ; decremente l'energie
    set energy energy - rocket-launcher-metabolism
    ; teste s'ils sont toujours en vie
    mort
    ; decremente le delai d'attente avant de pouvoir lancer un nouveau missile
    if (waiting > 0) [ set waiting waiting - 1 ]
    ; affiche ou non un label sur l'agent
    display-label
    ; appelle la procedure d'activation correspondant a la couleur
    ifelse (color = green)
    [ carefully[goGreenRocketLauncher][show error-message] ]
    [ carefully[goRedRocketLauncher][show error-message] ]
  ]

  ; pour tous les moissonneurs
  ask Harvesters [
    ; decremente l'energie
    set energy energy - harvester-metabolism
    ; teste s'ils sont toujours en vie
    mort
    ; affiche ou non un label sur l'agent
    display-label
    ; appelle la procedure d'activation correspondant a la couleur
    ifelse (color = green)
    [ carefully[goGreenHarvester][show error-message] ]
    [ carefully[goRedHarvester][show error-message] ]
  ]

  ; pour toutes les bases
  ask Bases [
    ; teste si elles sont toujours en vie
    mort
    ; decremente le delai d'attente avant de pouvoir lancer un nouveau missile
    if (waiting > 0) [ set waiting waiting - 1 ]
    ; convertit la nourriture recuperee en energie
    convert-food-into-energy
    ; affiche ou non un label sur l'agent
    display-label
    ; appelle la procedure d'activation correspondant a la couleur
    ifelse (color = green)
    [ carefully[goGreenBase][show error-message] ]
    [ carefully[goRedBase][show error-message] ]
  ]

  ; guidage des missiles
  ask Missiles [ carefully[go-missile][show error-message] ]

  ; guidage des missiles
  ask Fafs [ carefully[go-faf][show error-message] ]

  ; pousse des graines
  ask Seeds [ carefully[grow-seed][show error-message] ]
  ; pourrissement des burgers
  ask Burgers [ set energy energy - burger-decay if (energy <= 0) [die] ]

  ; affichage des spheres de perception
  ask Perceptions [ carefully[go-perception][show error-message] ]

  ask Walls [ if (energy <= 0) [die] ]

  ; ajout aleatoire de nouveaux burgers
  if (random burger-periodicity = 0) [ carefully[new-random-burgers burger-quantity][show error-message] ]


  ; met à jour l'affichage des ressources globales des 2 equipes
  update_energy_watches
  tick
  if (ticks = duree) [ stop ]
end

to-report compute-energy [ c ]
  report round (sum [energy] of Bases with [ color = c ] +
  sum [energy] of Explorers with [ color = c ] +
  sum [energy] of Harvesters with [ color = c ] +
  sum [carrying-food?] of Harvesters with [ color = c ] +
  sum [energy] of RocketLaunchers with [ color = c ] +
  sum [nb-missiles * missile-cost] of RocketLaunchers with [ color = c ] +
  sum [nb-fafs * faf-cost] of RocketLaunchers with [ color = c ] +
  sum [nb-missiles * missile-cost] of bases with [ color = c ] +
  sum [nb-fafs * faf-cost] of Bases with [ color = c ])
end

to update_energy_watches
  set energy_red compute-energy red
  set energy_green compute-energy green
end

;
; Creation d'une nouvelle base de couleur 'c' a la position ('x', 'y')
;
to new-base [ c en x y ]
  ; cree la base
  create-Bases 1 [
    ; initialise la taille, la couleur, la position
    set size 2
    set color c
    set friend c
    set ennemy en
    set xcor x
    set ycor y
    ; initialise l'energie
    set energy base-nrj
    ; initialise le rayon de perception
    set detection-range base-perception
    ; les bases ne bougent pas
    set speed 0
    set label ""
    set mem0 0
    set mem1 0
    set mem2 0
    set mem3 0
    set mem4 0
    set mem5 0
    set mem6 0
    set mem7 0
    set mem8 0
    set mem9 0
    set mem10 0
    set mem11 0
    ; la base a le droit de créer un robot par tour
    set create-ok? true
    ; initialise le nb de missiles
    set nb-missiles base-nb-missiles
    set max-missiles base-max-missiles
    ; initialise le nb de faf
    set nb-fafs base-nb-fafs
    set max-fafs base-max-fafs
    set waiting 0
    set death-burgers base-burgers
    ; cree un agent 'sphere de perception'
    hatch-Perceptions 1 [
      set color c
      set my-range 2 * base-perception
      set agt myself
      ask myself [ set percept self ]
      set size 0
    ]
  ]
end

;
; cree 'n' burgers
;
to new-random-burgers [ n ]
  ; position choisie aleatoirement
  let x random-xcor
  let y random-ycor
  ; cree n burgers autour de la position choisie
  create-burgers n [ init-burger x y wild-burger-min-nrj wild-burger-max-nrj Burgers -1 ]
  ; cree des burgers à la même position relative pour les 2 autres bases
  create-burgers n [ init-burger x + 60 y wild-burger-min-nrj wild-burger-max-nrj Burgers -1 ]
;  create-burgers n [ init-burger x + 80 y wild-burger-min-nrj wild-burger-max-nrj Burgers -1 ]
end

;
; cree 'n' burgers à la position de l'agent
;
to new-burgers [ x y n min-nrj max-nrj bb wi ]
  ; cree n burgers autour de l'agent
  hatch-Burgers n [ init-burger x y min-nrj max-nrj bb wi ]
end

to init-burger [ x y min-nrj max-nrj bb wi ]
  ; positions etalees autour du point choisi
  setxy x y
  set burger-breed bb
  set who-id wi
  set label ""
  set heading random 360
  fd random 3
  set size 1
  ; energie entre 50 et 100
  set energy min-nrj + random (max-nrj + 1 - min-nrj)
;  show word word burger-breed " / " who-id
end

;
; Creation de nouveaux obstacles
;
to new-random-walls
  ; 180 murs crees aleatoirement
  create-Walls 60 [
    let x random-xcor
    let y random-ycor
    ;; crée 3 murs symétriques
    init-wall x y
    init-wall x + 40 y
    init-wall x + 80 y
  ]
end

;; seules les bases peuvent créer de nouveaux murs
to new-wall [ a ]
  if (([breed] of a = Bases) and create-ok?) [
    ; on verifie que l'agent a suffisamment d'energie
    if ([energy] of a > wall-cost) [
      ; creation de l'agent
      hatch-Walls 1 [
        ; meme couleur et orientation que l'agent parent
        set color [color] of a
        set size 1
        ; on decale le nouvel agent
        fd 1
        ; initialisation de l'energie, du rayon de perception, de la vitesse
        set energy wall-nrj
      ]
      ; decremente l'energie de l'agent createur
      ask a [
        set energy energy - wall-cost
        set create-ok? false
      ]
    ]
  ]
end

to init-wall [ x y ]
  setxy x y
  set energy wall-nrj
  set color gray
  set size 1
end

;
; Creation d'un nouvel explorer par l'agent 'a'
;
to new-Explorer [ a ]
  ; on verifie que l'agent a suffisamment d'energie
  if (([energy] of a > explorer-cost) and create-ok?) [
    ; orientation choisie aleatoirement
    set heading random 360
    ; creation de l'agent
    hatch-Explorers 1 [
      ; initialisation de sa taille
      set size 2
      ; meme couleur et orientation que l'agent parent
      set color [color] of a
      set friend [friend] of a
      set ennemy [ennemy] of a
      set heading [heading] of a
      ; on decale le nouvel agent
      fd 1
      ; initialisation de l'energie, du rayon de perception, de la vitesse
      set energy explorer-nrj
      set detection-range explorer-perception
      set speed explorer-speed
      set my-bases Bases with [ color = [color] of a ]
      set label ""
      set mem0 0
      set mem1 0
      set mem2 0
      set mem3 0
      set mem4 0
      set mem5 0
      set death-burgers explorer-burgers
      set carrying-food? 0
      ; cree un agent 'sphere de perception'
      hatch-Perceptions 1 [
        set color [color] of a
        set my-range 2 * explorer-perception
        set agt myself
        ask myself [ set percept self ]
        set size 0
      ]
      ifelse (color = green)
      [ initGreenExplorer ]
      [ initRedExplorer ]
    ]
    ; decremente l'energie de l'agent createur
    ask a [
      set energy energy - explorer-cost
      set create-ok? false
    ]
  ]
end

;
; Creation d'un nouveau rocket-launcher par l'agent 'a'
;
to new-RocketLauncher [ a ]
  ; on verifie que l'agent a suffisamment d'energie
  if (([energy] of a > rocket-launcher-cost) and create-ok?) [
    ; orientation choisie aleatoirement
    set heading random 360
    ; creation de l'agent
    hatch-RocketLaunchers 1 [
      ; initialisation de sa taille
      set size 2
      ; meme couleur et orientation que l'agent parent
      set color [color] of a
      set friend [friend] of a
      set ennemy [ennemy] of a
      set heading [heading] of a
      ; on decale le nouvel agent
      fd 1
      ; initialisation de l'energie, du rayon de perception, de la vitesse
      set energy rocket-launcher-nrj
      set detection-range rocket-launcher-perception
      set speed rocket-launcher-speed
      ; initialement 30 missiles, 100 au maximum
      set nb-missiles rocket-launcher-nb-missiles
      set max-missiles rocket-launcher-max-missiles
      ; initialement 30 missiles, 100 au maximum
      set nb-fafs rocket-launcher-nb-fafs
      set max-fafs rocket-launcher-max-fafs
      set waiting 0
      set my-bases Bases with [ color = [color] of a ]
      set label ""
      set mem0 0
      set mem1 0
      set mem2 0
      set mem3 0
      set mem4 0
      set mem5 0
      set death-burgers rocket-launcher-burgers
      set carrying-food? 0
      ; cree un agent 'sphere de perception'
      hatch-Perceptions 1 [
        set color [color] of a
        set my-range 2 * rocket-launcher-perception
        set agt myself
        ask myself [ set percept self ]
        set size 0
      ]
      ifelse (color = green)
      [ initGreenRocketLauncher ]
      [ initRedRocketLauncher ]
    ]
    ; decremente l'energie de l'agent createur
    ask a [
      set energy energy - rocket-launcher-cost
      set create-ok? false
    ]
  ]
end

;
; Creation d'un nouvel harvester par l'agent 'a'
;
to new-Harvester [ a ]
  ; on verifie que l'agent a suffisamment d'energie
  if (([energy] of a > harvester-cost) and create-ok?) [
    ; orientation choisie aleatoirement
    set heading random 360
    ; creation de l'agent
    hatch-Harvesters 1 [
      ; initialisation de sa taille
      set size 2
      ; meme couleur et orientation que l'agent parent
      set color [color] of a
      set friend [friend] of a
      set ennemy [ennemy] of a
      set heading [heading] of a
      ; on decale le nouvel agent
      fd 1
      ; initialisation de l'energie, du rayon de perception, de la vitesse
      set energy harvester-nrj
      set detection-range harvester-perception
      set speed harvester-speed
      set my-bases Bases with [ color = [color] of a ]
      set label ""
      set mem0 0
      set mem1 0
      set mem2 0
      set mem3 0
      set mem4 0
      set mem5 0
      set death-burgers harvester-burgers
      set carrying-food? 0
      set carried-walls-nrj []
      ; cree un agent 'sphere de perception'
      hatch-Perceptions 1 [
        set color [color] of a
        set my-range 2 * harvester-perception
        set agt myself
        ask myself [ set percept self ]
        set size 0
      ]
      ifelse (color = green)
      [ initGreenHarvester ]
      [ initRedHarvester ]
    ]
    ; decremente l'energie de l'agent createur
    ask a [
      set energy energy - harvester-cost
      set create-ok? false
    ]
  ]
end

;
; affiche ou non un label sur l'agent
;
to display-label
  set label ""
  ifelse (display? = "missiles")
  [ ifelse ((breed = RocketLaunchers) or (breed = Bases)) [ set label nb-missiles ][ set label "" ]]
  [ ifelse (display? = "fafs")
    [ ifelse ((breed = RocketLaunchers) or (breed = Bases)) [ set label nb-fafs ][ set label "" ]]
    [ ifelse (display? = "energy")
      [ set label round energy ]
      [ ifelse (display? = "carried-walls-nrj")
        [ ifelse (breed = Harvesters) [set label carried-walls-nrj][ set label ""]]
        [ ifelse (display? = "mem0")
          [ set label mem0 ]
          [ ifelse (display? = "mem1")
            [ set label mem1 ]
            [ ifelse (display? = "mem2")
              [ set label mem2 ]
              [ ifelse (display? = "mem3")
                [ set label mem3 ]
                [ ifelse (display? = "mem4")
                  [ set label mem4 ]
                  [ ifelse (display? = "mem5")
                    [ set label mem5 ]
                    [ if (display? = "carrying-food?")
                      [ ifelse ((breed = Bases) or (breed = RocketLaunchers))
                        [ set label "" ]
                        [ set label round carrying-food? ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
end

;
; si l'agent n'a plus d'energie, il meurt
;
to mort
  if (energy <= 0) [
    ; crée des burgers en mourant
    new-burgers xcor ycor death-burgers wild-burger-min-nrj wild-burger-max-nrj breed who
    ; supprime le cercle de perception
    ask percept [die]
    ; meurt
    die
  ]
end

;
; prend le rocher 'b'
;
to take-wall [ b ]
  if ([breed] of b = Walls) [
    ;; seuls les agents de type "moissonneurs" peuvent soulever les rochers
    if ((breed = Harvesters) and (length carried-walls-nrj < 5)) [
      ; si on est suffisamment proche
      if (distance b <= 2) [
        set carried-walls-nrj fput [energy] of b carried-walls-nrj
        ; l'agent-rocher est tue
        ask b [ die ]
      ]
    ]
  ]
end

;
; depose le rocher devant l'agent
;
to drop-wall
  if (not empty? carried-walls-nrj) [
    hatch-Walls 1 [
      set heading [heading] of myself
      set size 1
      set color [color] of myself
      set energy first [carried-walls-nrj] of myself
      set carrying-food? 0
      set mem0 0
      set mem1 0
      set mem2 0
      set mem3 0
      set mem4 0
      set mem5 0
      set detection-range 0
      set speed 0
      set fd-ok? false
      set percept 0
      set my-bases 0
      set friend gray
      set ennemy gray
      fd 1
    ]
    set carried-walls-nrj remove-item 0 carried-walls-nrj
  ]
end

;
; prend la nourriture 'b'
;
to take-food [ b ]
  if ([breed] of b = Burgers) [
    ;; seuls les agents de type "moissonneurs" peuvent recolter la nourriture
    if (breed = Harvesters) [
      ; si on est suffisamment proche
      if (distance b <= 2) [
        without-interruption [
          ; on augmente la quantite de nourriture transportee
          set carrying-food? carrying-food? + [energy] of b
          ; l'agent-nourriture est tue
          ask b [ die ]
        ]
      ]
    ]
  ]
end

;
; donne la quantite 'c' de nourriture a l'agent 'agent'
;
to give-food [ agent c ]
  ; on ne peut donner de la nourriture qu'à un autre moissonneur ou à la base
  if ((agent != nobody) and (([breed] of agent = Explorers) or ([breed] of agent = Harvesters) or ([breed] of agent = Bases))) [
    ; si les 2 agents sont suffisamment proches l'un de l'autre
    if (distance agent <= 2) and (c <= carrying-food?) [
      ; incremente la nourriture de l'autre agent
      ask agent [ set carrying-food? carrying-food? + c ]
      ; decremente sa propre nourriture
      set carrying-food? carrying-food? - c
      if (carrying-food? < 0) [show "pb d'échange de nourriture"]
    ]
  ]
end

;
; plante 'nb' graines dans le sol
; - on ne peut pas avoir plus de 'max-seeds' graines dans un patch
; - il faut consommer 'seed-cost' unites de 'carrying-food?' pour planter une graine
;
to plant-seeds [ c nb ]
  ; compte le nombre de graine ici
  let nb-seeds count Seeds-here
  ; evalue combien on peut planter de graines ici
  set nb min (list nb (max-seeds - nb-seeds) (carrying-food? / seed-cost))

  if (nb > 0) and (count Walls-here = 0) [
    ; plante les graines
    ask patch-here [
      sprout-Seeds nb [ set age 0 set shape "dot" set label "" set size 1 set friend c  ]
    ]
    ; c'est preleve sur la nourriture
    set carrying-food? carrying-food? - nb * seed-cost
    if (carrying-food? < 0) [show "pb de plantation"]
  ]
end

;
; assure la croissance des graines
; - au bout de 'maturation-time' ticks, produit un burger avec une energie comprise
;   entre 'seeded-burger-min-nrj' et 'seeded-burger-max-nrj'
;
to grow-seed
  set age age + 1
  set color scale-color friend age 0 maturation-time
  if (age = maturation-time) [
    new-burgers xcor ycor 1 seeded-burger-min-nrj seeded-burger-max-nrj breed who
    die
  ]
end

;
; donne la quantite 'nrj' d'energie a l'agent 'agent'
;
to give-energy [ agent nrj ]
  if (breed = Bases) [
    if (agent != nobody) [
      ; si les 2 agents sont suffisamment proches l'un de l'autre
      if (distance agent <= 2) and (nrj <= energy) [
        ; incremente l'energie de l'autre agent
        ask agent [ set energy energy + nrj ]
        ; decremente sa propre energie
        set energy energy - nrj
      ]
    ]
  ]
end

;
; procedure reservee aux bases pour convertir la nourriture
; que les agents ont ramenee en energie
;
to convert-food-into-energy
  ; incremente l'energie
  set energy energy + carrying-food?
  ; supprime la nourriture
  set carrying-food? 0
end

;
; renvoie un des agents présent devant dans un cone d'ouverture 135° et jusqu'à une distance d
; (hormis les burgers, les graines et les agents de perception)
to-report free-ahead? [ d ]
  set d max (list 1 d)
  report one-of other turtles in-cone d 135 with [ breed != Burgers and breed != Seeds and breed != Perceptions and breed != Missiles and breed != Fafs ]
end

;
; avance vers l'avant
;
to forward-move [ d ]
  without-interruption [
    ; si l'agent ne s'est pas deja deplace au cours de ce cycle
    if (fd-ok?) [
      ; il inhibe son deplacement pendant le tour
      set fd-ok? false
      ; limite le déplacement à la vitesse de l'agent
      set d min (list d speed)
      ; est-ce qu'il y a un agent devant
      let a free-ahead? d
      ; si la voie est libre
      ifelse (a = nobody) [
        ; il peut avancer...
        fd d
        ; il peut écraser les plants de burgers (sauf si c'est un harvester)
        if (breed != Harvesters) [ ask Seeds-here with [age > 100][ set age age - 100 ]]
      ]
      ; sinon, il y a collision avec dégâts sur l'obstacle et sur le robot
      [
        ask a [ set energy energy - collision-damage ]
        ifelse ([breed] of a = Bases)
        [ set energy 0 ]
        [ set energy energy - collision-damage ]
      ]
    ]
  ]
end

;
; effectue un mouvement aleatoire
;
to random-move
  ; choisit une orientation aleatoire entre -45 et +45 degres
  rt random 91 - 45
  ; avance vers l'avant
  if (free-ahead? speed = nobody) [forward-move speed]
end

;
; lance une nouvelle rocket dans la direction 'dir'
;
to launch-rocket [ dir ]
  ; si l'agent a encore des missiles et qu'il respecte le delai d'attente
  if ((waiting = 0) and (nb-missiles > 0)) [
    ; on decremente le nombre de missiles de l'agent
    set nb-missiles nb-missiles - 1
    ; impose un delai d'attente de 5 entre 2 lancers de missiles
    ifelse (breed != bases)
    [ set waiting rocket-launcher-waiting ]
    [ set waiting base-waiting ]

    ; on cree un nouveau missile
    hatch-Missiles 1 [
      ; pas de label pour le missile
      set label ""
      ; taille 1
      set size 1
      ; portee 20
      set my-range missile-range
      ; en se dirigeant dans la direction 'dir'
      set heading dir
      ; a la vitesse de 1
      set speed missile-speed
      ; on decale le missile par rapport a l'agent
      fd 0.5
    ]
  ]
end

;
; procedure de "guidage" des missiles
;
to go-missile
  ; recupere la liste des agents a une distance inferieure a 1.5 dans un cone de 180 degres
  let t turtles in-cone 1.5 180 with [ (breed != Missiles) and (breed != Fafs) and (breed != Burgers) and (breed != Perceptions) and (breed != Seeds) ]
  ; s'il y a des agents
  if any? t [
    ; on decremente leur energie de 100 si ce n'est pas une base, de 20 si c'est une base
    ask t [ ifelse (breed != Bases) [ set energy energy - missile-robot-damage ][ set energy energy - missile-base-damage ] ]
    ; le missile est detruit
    die
  ]
  ; si la portee du missile devient nulle...
  ifelse my-range < 0
    ; ... alors il est detruit
    [ die ]
    ; sinon il avance a la vitesse speed, et sa portee est diminuee d'autant
    [  ; avance tout droit à la vitesse speed
      fd speed set my-range my-range - speed
    ]
end


;
; possibilite de creer 'n' nouveaux missiles pour un rocket-launcher ou pour la base
; cout = 10 pour le creer
; degats = 100 pour un robot / 20 pour une base
;
to new-missile [ n ]
  if ((breed = RocketLaunchers) or (breed = Bases)) [
    ; si on n'atteint pas le max de missiles autorises et qu'on a suffisamment d'energie
    if (nb-missiles + n <= max-missiles) and (energy > missile-cost * n) [
      ; le nb de missiles est incremente de 'n'
      set nb-missiles nb-missiles + n
      ; chaque missile coûte 10 points d'energie a fabriquer
      set energy energy - missile-cost * n
    ]
  ]
end

;
; lance une nouvelle rocket de type faf en direction de la cible t
;
to launch-faf [ t ]
  ; si l'agent a encore des fafs et qu'il respecte le delai d'attente
  if ((waiting = 0) and (nb-fafs > 0)) [
    ; on decremente le nombre de fafs de l'agent
    set nb-fafs nb-fafs - 1
    ; impose un delai d'attente de 5 entre 2 lancers de fafs
    ifelse (breed != bases)
    [ set waiting rocket-launcher-waiting ]
    [ set waiting base-waiting ]

    ; on cree un nouveau faf
    hatch-Fafs 1 [
      ; pas de label pour le faf
      set label ""
      ; taille 1
      set size 3
      set color yellow
      ; portee 20
      set my-range faf-range
      ; en se dirigeant dans la direction de la cible
      if (t != nobody) [
        set heading towards t
      ]
      ; a la vitesse de 1
      set speed faf-speed
      ; on decale le faf par rapport a l'agent
      fd 0.5
      ; vérouille la cible
      set target t
    ]
  ]
end

;
; procedure de "guidage" des missiles
;
to go-faf
  ; recupere la liste des agents a une distance inferieure a 1.5 dans un cone de 180 degres
  let t turtles in-cone 1.5 180 with [ (breed != Missiles) and (breed != Fafs) and (breed != Burgers) and (breed != Perceptions) and (breed != Seeds) ]
  ; s'il y a des agents
  if any? t [
    ; on decremente leur energie de la quantité prédéfinie
    ask t [ ifelse (breed != Bases) [ set energy energy - faf-robot-damage ][ set energy energy - faf-base-damage ] ]
    ; le faf est detruit
    die
  ]
  ; si la portee du missile devient nulle...
  ifelse my-range < 0
    ; ... alors il est detruit
    [ die ]
    ; sinon il avance a la vitesse speed, et sa portee est diminuee d'autant
    [
      let h heading
      if (target != nobody) [
        set heading towards target
      ]
      ; avance tout droit à la vitesse speed
      fd speed set my-range my-range - speed
    ]
end


;
; possibilite de creer 'n' nouveaux missiles pour un rocket-launcher ou pour la base
; cout = 10 pour le creer
; degats = 100 pour un robot / 20 pour une base
;
to new-faf [ n ]
  ; si on n'atteint pas le max de missiles autorises et qu'on a suffisamment d'energie
  if (nb-fafs + n <= max-fafs) and (energy > faf-cost * n) [
    ; le nb de missiles est incremente de 'n'
    set nb-fafs nb-fafs + n
    ; chaque missile coûte 10 points d'energie a fabriquer
    set energy energy - faf-cost * n
  ]
end

;
; renvoie les agents de type Burger dans le rayon de perception de l'agent
;
to-report perceive-food
  report Burgers in-radius detection-range
end

;
; renvoie les missiles de type faf dans le rayon de perception de l'agent
;
to-report perceive-fafs
  report Fafs in-radius detection-range
end

;
; renvoie les agents de type Burger dans le rayon de perception de l'agent
;
to-report perceive-food-in-cone [ a ]
  report Burgers in-cone detection-range a
end

;
; renvoie les agents de type Seed dans le rayon de perception de l'agent
; les graines ne sont perceptibles que quand elle ont un age > 500
;
to-report perceive-seeds [ c ]
  ifelse (c = friend)
  [ report Seeds in-radius detection-range with [ friend = c ]]
  [ report Seeds in-radius detection-range with [ (friend = c) and (age > 500) ]]
end

;
; renvoie les agents de type Seed dans le rayon de perception de l'agent
; les graines ne sont perceptibles que quand elle ont un age > 500
;
to-report perceive-seeds-in-cone [ a c ]
  ifelse (c = friend)
  [ report Seeds in-cone detection-range a with [ friend = c ]]
  [ report Seeds in-cone detection-range a with [ (friend = c) and (age > 500) ]]
end

;
; renvoie les agents de type Wall dans le rayon de perception de l'agent
;
to-report perceive-walls
  report Walls in-radius detection-range
end

;
; renvoie les agents de type Wall dans le rayon de perception de l'agent
;
to-report perceive-walls-in-cone [ a ]
  report Walls in-cone detection-range a
end

;
; renvoie les agents de couleur 'c' et de type 'Explorer' ou 'RocketLauncher' dans le rayon de perception de l'agent
;
to-report perceive-robots [ c ]
  report turtles in-radius detection-range with [ (color = c) and ((breed = Explorers) or (breed = RocketLaunchers) or (breed = Harvesters))]
end

;
; renvoie les agents de couleur 'c' et de type 'Explorer' ou 'RocketLauncher' ou 'Harvesters' dans le rayon de perception de l'agent
;
to-report perceive-robots-in-cone [ c a ]
  report turtles in-cone detection-range a with [ (color = c) and ((breed = Explorers) or (breed = RocketLaunchers) or (breed = Harvesters))]
end

;
; renvoie les agents de couleur 'c' et de type b dans le rayon de perception de l'agent
;
to-report perceive-specific-robots [ c b  ]
  report turtles in-radius detection-range with [ (color = c) and (breed = b)]
end

;
; renvoie les agents de couleur 'c' et de type b dans le rayon de perception de l'agent
;
to-report perceive-specific-robots-in-cone [ c b a ]
  report turtles in-cone detection-range a with [ (color = c) and (breed = b)]
end

;
; renvoie les bases de couleur 'c' dans le rayon de perception de l'agent
;
to-report perceive-base [ c ]
  report turtles in-radius detection-range with [ (color = c) and (breed = Bases) ]
end

;
; renvoie les bases de couleur 'c' dans le rayon de perception de l'agent
;
to-report perceive-base-in-cone [ c a ]
  report turtles in-cone detection-range a with [ (color = c) and (breed = Bases) ]
end

;
; renvoie les agents de couleur 'c1' ou 'c2' et de type 'Explorer' ou 'RocketLauncher' dans le rayon de perception de l'agent
;
to-report perceive-robots2 [ c1 c2 ]
  report turtles in-radius detection-range with [ ((color = c1) or (color = c2)) and ((breed = Explorers) or (breed = RocketLaunchers) or (breed = Harvesters))]
end

;
; renvoie les agents de couleur 'c1' ou 'c2' et de type 'Explorer' ou 'RocketLauncher' ou 'Harvesters' dans le rayon de perception de l'agent
;
to-report perceive-robots2-in-cone [ c1 c2 a ]
  report turtles in-cone detection-range a with [ ((color = c1) or (color = c2)) and ((breed = Explorers) or (breed = RocketLaunchers) or (breed = Harvesters))]
end

;
; renvoie les agents de couleur 'c1' ou 'c2' et de type b dans le rayon de perception de l'agent
;
to-report perceive-specific-robots2 [ c1 c2 b  ]
  report turtles in-radius detection-range with [ ((color = c1) or (color = c2)) and (breed = b)]
end

;
; renvoie les agents de couleur 'c1' ou 'c2' et de type b dans le rayon de perception de l'agent
;
to-report perceive-specific-robots2-in-cone [ c1 c2 b a ]
  report turtles in-cone detection-range a with [ ((color = c1) or (color = c2)) and (breed = b)]
end

;
; renvoie les bases de couleur 'c1' ou 'c2' dans le rayon de perception de l'agent
;
to-report perceive-base2 [ c1 c2 ]
  report turtles in-radius detection-range with [ ((color = c1) or (color = c2)) and (breed = Bases) ]
end

;
; renvoie les bases de couleur 'c1' ou 'c2' dans le rayon de perception de l'agent
;
to-report perceive-base2-in-cone [ c1 c2 a ]
  report turtles in-cone detection-range a with [ ((color = c1) or (color = c2)) and (breed = Bases) ]
end

;
; realise l'affichage d'un cercle autour de l'agent pour visualiser son rayon de perception
;
to go-perception
  ; si on demande l'affichage du rayon de perception
  ifelse (display-range?) [
    ; change la taille de l'agent
    set size my-range
    ; les coordonnees suivent celles de l'agent auquel l'agent de perception appartient
    ifelse ( agt != nobody ) [
      set xcor [xcor] of agt
      set ycor [ycor] of agt
    ]
    [ die ]
  ]
  ; ... sinon, taille 0 pour ne pas voir le cercle
  [ set size 0 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
213
10
997
346
-1
-1
6.4132231405
1
10
1
1
1
0
1
1
1
-60
60
-25
25
0
0
1
ticks
30.0

BUTTON
34
10
100
43
Setup
setup 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
113
10
176
43
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

MONITOR
30
272
100
317
Base R1
round [energy] of turtle 0
3
1
11

MONITOR
30
318
100
363
Base R2
round [energy] of turtle 2
3
1
11

SWITCH
22
99
185
132
display-range?
display-range?
1
1
-1000

MONITOR
101
318
171
363
Base G2
round [energy] of turtle 6
17
1
11

MONITOR
101
272
171
317
Base G1
round [energy] of turtle 4
17
1
11

CHOOSER
22
136
185
181
display?
display?
"none" "energy" "missiles" "carrying-food?" "carried-walls-nrj" "mem0" "mem1" "mem2" "mem3" "mem4" "mem5"
0

MONITOR
30
226
100
271
Reds
energy_red
0
1
11

MONITOR
101
226
171
271
Greens
energy_green
0
1
11

PLOT
213
347
997
562
plot 1
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
"default" 1.0 0 -2674135 true "" "plot energy_red"
"pen-1" 1.0 0 -13840069 true "" "plot energy_green"

MONITOR
101
364
171
409
GE
count Explorers with [color = green]
17
1
11

MONITOR
101
410
171
455
GRL
count RocketLaunchers with [color = green]
17
1
11

MONITOR
101
456
171
501
GH
count Harvesters with [color = green]
17
1
11

MONITOR
30
364
100
409
RE
count Explorers with [color = red]
17
1
11

MONITOR
30
410
100
455
RRL
count RocketLaunchers with [color = red]
17
1
11

MONITOR
30
456
100
501
RH
count Harvesters with [color = red]
17
1
11

@#$#@#$#@
## DE QUOI S'AGIT-IL?

Il s'agit d'un jeu inspiré du jeu Warbot. L'objectif, pour chaque équipe de robot, consiste à accumuler plus de ressources que son adversaire. Pour cela, vous devrez définir et implémenter une stratégie décentralisée, se basant uniquement sur les perceptions et actions locales des agents, sans la possibilité de disposer de connaissances globales sur le terrain de jeu.

Vous pouvez retrouver le calcul des ressources de chaque équipe dans la procédure update_energy_watches

## TRAVAIL A FAIRE

Il s'agit pour vous de programmer l'équipe rouge, en mettant tout votre code dans le fichier reds.nls

Les procédures à compléter sont :
- Les quatre procédures initRed* (où * est à remplacer par Base, Explorer, RocketLauncher, Harvester) ; ces procédures sont appelées une seule fois au moment de la création d'un agent.
- Les quatre procédures goRed* (où * est à remplacer par Base, Explorer, RocketLauncher, Harvester) ; ces procédures sont appelées à chaque itération de la simulation et définissent le comportement des différents agents).

Vous NE DEVEZ PAS modifier le nom de ces procédures ! Pour vous aider à structurer votre code, vous pouvez programmer autant de procédures que vous voulez, en veillant à préfixer systématiquement vos noms de procédures avec le préfixe que vous aurez choisi (et qui doit être unique dans la promo). 

## CONTRAINTES ET CONSIGNES PARTICULIERES

- Il est interdit de créer des variables globales (cela permettrait une communication globale entre les agents). De même, ne créez pas de variables d'agents (ce qui permettrait d'étendre la "mémoire" des agents). Utilisez en guise de mémoire des agents les variables mem0 à mem5. Chacune de ces variables pourra contenir au maximum une liste de 2 valeurs (par exemple pour stocker les coordonnées d'un agent).
 
- Un seul deplacement est autorisé par iteration de jeu. Pour cela, vous ne devez pas appeler directement la procédure forward (ou fd) pour avancer mais utiliser à la place la procedure forward-move : celle-ci s'assure alors que l'agent qui essaye d'avancer ne s'est pas déjà déplacé au cours de l'itération en cours.

- De même, un seul tir de missile est autorisé par iteration de jeu. Pour cela, utilisez la procedure launch-rocket pour lancer un missile.

- Pour ce qui est de la perception, vous devez également respecter la distance de perception maximale de chaque type de robot, donnée par la variable detection-range. Utilisez pour cela les procédures perceive-xxx mises à votre disposition dans l'onglet code.

- Vous programmez l'équipe rouge, mais celle-ci peut devenir l'équipe verte au cours d'un tournoi, simplement en changeant les procédures initRed* en initGreen* et en changeant les procédures goRed* en goGreen*. Cela veut dire que vous ne devez pas faire d'hypothèses dans votre code relatives à la couleur de vos robots. Pour faire référence à la couleur des robots "amis", utilisez la couleur "color" (c'est-à-dire la même couleur que soi), pour faire référence à la couleur des robots "ennemis", utilisez la couleur "ennemy" (mise à jour automatiquement à la création des agents).

## TRAVAIL A RENDRE

- Vous rendrez le fichier reds.nls complété avec le code de votre équipe.
- Vous documenterez votre code de manière aussi precise que possible
- Vous complèterez la section "VOTRE STRATEGIE COMMENTEE" (voir ci-dessous) pour expliquer comment vous avez procédé pour concevoir votre équipe de robots.

## LISTE DES PRIMITIVES A VOTRE DISPOSITION

; Creation de 'n' nouveaux explorers par la base 'a'  
new-Explorer n a

; Creation de 'n' nouveaux rocket-launchers par la base 'a'  
new-RocketLauncher n a

; prend l'item de nourriture 'b'  
take b

; donne la quantite 'c' de nourriture a l'agent 'agent'  
give-food agent c

; donne la quantite 'c' d'energie a l'agent 'agent'  
give-energy agent c

; avance vers l'avant (en testant l'absence d'obstacles)  
forward-move

; avance dans une direction aleatoire  
random-move

; lance une nouvelle rocket dans la direction 'dir'  
launch-rocket dir

; possibilite de creer 'n' nouveaux missiles pour un rocket-launcher  
new-missile n

; renvoie les agents de type Burger dans le rayon de perception de l'agent  
perceive-food

; renvoie les bases de couleur 'c' dans le rayon de perception de l'agent  
perceive-base c

; renvoie les agents de couleur 'c' et de type 'b' dans le rayon de perception de   
; l'agent  
perceive c b

Pour vous aider a concevoir votre equipe, vous pourrez consulter les equipes programmees lors des competitions des annees precedentes, disponibles sur le site de Warbot.

## VOTRE STRATEGIE COMMENTEE

## CREDITS AND REFERENCES

Warbot a ete imagine par J. Ferber au LIRMM (Montpellier) dans le cadre de la plate-forme Madkit (www.madkit.org).  
voir http://www.lirmm.fr/~ferber/warbot/ProjetWarBot.html
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
Circle -2674135 false false -45 75 150
Circle -2674135 true false 28 73 95
Polygon -2674135 true false 135 90 150 195 195 135 180 90 135 90

circle
false
0
Circle -7500403 false true 2 2 297

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

explorer
false
0
Rectangle -6459832 true false 180 180 210 255
Rectangle -6459832 true false 90 180 120 255
Circle -7500403 true true 105 90 90
Rectangle -7500403 true true 105 135 195 210
Circle -7500403 true true 105 165 90
Line -7500403 true 105 60 120 105
Circle -7500403 true true 96 49 13
Circle -7500403 true true 165 39 69
Polygon -16777216 true false 195 75 225 105 240 105 240 30 165 30
Polygon -7500403 true true 180 75 210 60 195 90
Circle -1184463 true false 117 132 6
Circle -1184463 true false 132 132 6
Circle -1184463 true false 147 132 6
Circle -1184463 true false 162 132 6
Circle -1184463 true false 177 132 6
Line -16777216 false 105 128 195 128
Line -16777216 false 104 142 205 143
Rectangle -16777216 false false 136 173 167 219
Circle -16777216 true false 141 193 4

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

hamburger
false
0
Circle -6459832 true false 83 83 134
Rectangle -16777216 true false 75 135 225 165
Circle -1184463 true false 105 113 3
Circle -1184463 true false 125 105 3
Circle -1184463 true false 146 100 3
Circle -1184463 true false 138 113 3
Circle -1184463 true false 161 113 3
Circle -1184463 true false 174 102 3
Circle -1184463 true false 186 117 3
Rectangle -2674135 true false 93 137 210 163

harvester
false
0
Rectangle -6459832 true false 180 180 210 255
Rectangle -6459832 true false 90 180 120 255
Circle -7500403 true true 105 90 90
Rectangle -7500403 true true 105 135 195 240
Circle -1184463 true false 117 132 6
Circle -1184463 true false 132 132 6
Circle -1184463 true false 147 132 6
Circle -1184463 true false 162 132 6
Circle -1184463 true false 177 132 6
Line -16777216 false 105 128 195 128
Line -16777216 false 104 142 205 143
Rectangle -16777216 false false 136 173 167 219
Circle -16777216 true false 141 193 4
Rectangle -6459832 true false 135 240 165 255
Polygon -7500403 true true 225 30 210 90 90 90 75 30 105 75 195 75

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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

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

rocket launcher
false
0
Rectangle -6459832 true false 180 180 210 255
Rectangle -6459832 true false 90 180 120 255
Circle -7500403 true true 105 90 90
Rectangle -7500403 true true 105 135 195 240
Circle -1184463 true false 117 132 6
Circle -1184463 true false 132 132 6
Circle -1184463 true false 147 132 6
Circle -1184463 true false 162 132 6
Circle -1184463 true false 177 132 6
Line -16777216 false 105 128 195 128
Line -16777216 false 104 142 205 143
Rectangle -16777216 false false 136 173 167 219
Circle -16777216 true false 141 193 4
Rectangle -6459832 true false 135 240 165 255
Polygon -6459832 true false 75 45 90 45 105 60 195 60 225 75 195 90 105 90 90 105 75 105 90 90 75 90 75 60 90 60 75 45

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

wall
false
0
Rectangle -7500403 true true 90 90 210 210
Line -16777216 false 90 120 210 120
Line -16777216 false 90 150 210 150
Line -16777216 false 90 180 210 180
Line -16777216 false 120 90 120 120
Line -16777216 false 165 90 165 120
Line -16777216 false 150 120 150 150
Line -16777216 false 195 120 195 150
Line -16777216 false 105 120 105 150
Line -16777216 false 135 150 135 180
Line -16777216 false 180 150 180 180
Line -16777216 false 120 180 120 210
Line -16777216 false 165 180 165 210

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
