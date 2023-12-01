; images.scm

;;; This file includes all the static images needed for the game.

(import image)
(import canvas)

; -------------------
;;; BASE ROUND BALL |
; -------------------

;;; (ball length main-color shadow-color) -> drawing?
;;;   length: integer?, non-negative
;;;   main-color: string?, or predefined rgb color.
;;;  shadow-color: string?, or predefined rgb color.
;;; Draws a round object as a base image to make different objects for Kirby to eat.
(define ball
  (lambda (length main-color shadow-color)
    (overlay/offset -3 -3 
                    (circle (* length 0.87) "solid" main-color)
                    (circle length "solid" shadow-color))))

; ------------------------
;;; Object 0: Basic Ball |
; ------------------------

;; Color Palette
(define darker-pink (color 248 187 198 1))
(define star-yellow (color 255 230 69 1))

;; Star

;;; (make-star length fill color) -> drawing?
;;;   length: integer?, non-negative
;;;   fill: string?
;;;   color: string?
;;; Draws an image of a star.
(define make-star
  (lambda (length fill color)
    (path length
          length
          (list (pair 0 (* length (/ 3 8))) ; 1
                (pair (* length (/ 3 8)) (* length (/ 3 8))) ; 2
                (pair (/ length 2) 0) ; 3
                (pair (* length (/ 5 8)) (* length (/ 3 8))) ; 4
                (pair length (* length (/ 3 8))) ; 5
                (pair (* length 0.75) (* length (/ 5 8))) ; 6
                (pair (* length (/ 7 8)) length) ; 7
                (pair (/ length 2) (* length 0.75)) ; 8
                (pair (* length (/ 1 8)) length) ; 9
                (pair (* length 0.25) (* length (/ 5 8))) ;10
          )
          fill
          color)))

;;; (star length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws an image of a star with outline
(define star
  (lambda (length)
    (overlay (make-star (+ length 0.8) "outline" "white")
             (make-star length "solid" star-yellow))))

;; Complete ball

;;; (basic-ball length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws the image of a complete basic Kirby ball.
(define basic-ball
  (lambda (length) 
    (overlay (star (* length 1.2))
             (ball length "pink" darker-pink))))

;; Display to test
(basic-ball 40)

; -------------------------
;;; OBJECT 1: TENNIS BALL |
; -------------------------

;; Color Palette
(define lemon-grass-green (color 197 230 54 1))
(define darker-lemon-grass-green (color 179 223 40 1))

;; White Curve

;;; (create-curve length) -> drawing?
;;;   length: integer?, non-negative
;;; Creates a single, thin white curve.
(define create-curve 
  (lambda (length)
    (ellipse (* length 1.4) (* length 0.8) "outline" "white")))

;;; (thick-curve length) -> drawing?
;;;   length: integer?, non-negative
;;; Creates a single, thick white curve.
(define thick-curve
  (lambda (length)
    (|> (range length (+ (* 0.1 length) length))
        (section map create-curve _)
        (section apply overlay _))))

;; Complete Tennis Ball
;;; (tennis-ball length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws a complete tennis ball with radius length.
(define tennis-ball
  (lambda (length)
    (let ([ball (ball length lemon-grass-green darker-lemon-grass-green)] ; Draw the ball
          [curve (thick-curve length)]) ; Draw the white lines across the ball
      (overlay/align "middle" "bottom" curve (overlay/align "middle" "top" curve ball)))))

;; Display to test
(tennis-ball 40)

; ------------------------
;;; OBJECT 2: MARIO LOGO |
; ------------------------

;; Color Palette
(define darker-red (color 207 26 27 1))

;; Big M
;;; (letter-m length) -> drawing?
;;;   length : integer?, non-negative
;;; Creates the big letter M in the Mario logo.
(define letter-m
  (lambda (length color) 
    (path length                                          ; horizontal image size
          length                                          ; vertical image size
          (list (pair 0 (* length 0.75))                  ; 1
                (pair (* length 0.25) 0)                  ; 2
                (pair (/ length 2) (* length (/ 3 8)))    ; 3
                (pair (* length 0.75) 0)                  ; 4
                (pair length (* length 0.75))             ; 5
                (pair (* length (/ 7 8)) length)          ; 6
                (pair (* length 0.75) (* length (/ 3 8))) ; 7
                (pair (/ length 2) (/ length 2))          ; 8
                (pair (* length 0.25) (* length (/ 3 8))) ; 9
                (pair (/ length 8) length)                ; 10
          )
          "solid"                                         ; fill style
          color)))                                        ; color

;; Complete Mario Ball
;;; (mario-ball length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws a complete Mario ball for Kirby to eat.
(define mario-ball
  (lambda (length color1 color2)
    (overlay (letter-m (* length 1.35) color1)
             (ball length color2 darker-red))))

;; Display to test
(mario-ball 40 "white" "red")

; --------------------------
;;; OBJECT 3: Medical Ball |
; --------------------------

;; Color Palette
(define bone-white (color 249 246 238 1))
(define darker-bone-white (color 237 234 222 1))

;; Red Cross

;;; (red-cross length) -> drawing?
;;;   length: integer?, non-negative
;;; Creates the red cross for the logo of the medical ball.
(define red-cross
  (lambda (length)
    (overlay
      (rectangle (* length 0.75) (* length 0.25) "solid" "red")
      (rectangle (* length 0.25) (* length 0.75) "solid" "red"))))

;; Complete Medical Ball

;;; (medical-ball length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws a complete medical ball for Kirby to eat.
(define medical-ball
  (lambda (length)
    (overlay (red-cross (* length 1.65))
             (ball length bone-white darker-bone-white))))

;; Display to test
(medical-ball 40)

; -----------------------------
;;; OBJECT 4: Snow Flake Ball |
; -----------------------------


; ------------------------
;;; Kirby 0: Basic Kirby |
; ------------------------

;; The pink circle
(define base-head
  (overlay/offset -0.5 -0.5 
                  (circle 100 "solid" "pink")
                  (circle 100.8 "solid" "palevioletred")))

;; One arm
(define arm
  (overlay/offset -0.5 -1 
                  (ellipse 70 50 "solid" "pink")
                  (ellipse 71 51 "solid" "palevioletred")))

;; Two arms
(define arms
  (beside arm (circle 60 "solid" "transparent") arm))

;; Attach the arms to the head
(define head
  (overlay/align "middle" "center" base-head arms))

;; Two pink ellipses for blush
(define blush
  (beside (ellipse 30 15 "solid" "hotpink")
          (rectangle 80 10 "solid" "pink")
          (ellipse 30 15 "solid" "hotpink")))

;; Basic black eye with white
(define black-eye-base
  (overlay/offset -4 -2
                  (ellipse 17 30 "solid" "white")
                  (ellipse 25 60 "solid" "black")))

;; Create an anime-like blue shadow for the eye
(define eye-blue
  (overlay/offset 0 4
                  (circle 5 "solid" "black")
                  (ellipse 14 20 "solid" "mediumblue")))

;; One complete eye
(define eye
  (overlay/offset -7 -35 
                  eye-blue 
                  black-eye-base))

;; Face with one eye
(define face-1
  (overlay/offset -150 -40 eye head))

;; Face with two eyes
(define face-2
  (overlay/offset -85 -40 eye face-1))

;; Mouth is a black circle with red ellipse
(define mouth
 (overlay/align "middle" "bottom" 
                (ellipse 30 17 "solid" "red") 
                (circle 20 "solid" "black")))

;; Attach blush on top of mouth
(define mouth-and-blush
     (above blush mouth))

;; THE COMPLETE BASIC KIRBY (WITHOUT FEET)
(define basic-kirby
  (overlay/offset -60 -100 mouth-and-blush face-2))

;; Feet are two red ellipses
;; They are not attached to the complete kirby for future animation
(define feet
 (beside (ellipse 70 50 "solid" "red") (circle 15 "solid" "white") (ellipse 70 50 "solid" "red")))

; --------------------------------
;;; Kirby 1: Tennis Player Kirby |
; --------------------------------

; ------------------------
;;; Kirby 2: Mario Kirby |
; ------------------------

;; Color Palette
(define mushroom-base-color (color 255 227 184 1))

;; MUSHROOM

;;; (mushroom-base length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws a base body for the mushroom.
(define mushroom-base
  (lambda (length)
    (ellipse length (/ length 1.5) "solid" mushroom-base-color)))

;;; (mushroom-eye length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws one eye for the mushroom body.
(define mushroom-eye
  (lambda (length)
    (overlay/offset (- (/ length 66.667)) (- (/ length 66.667))
                    (ellipse (* length 0.04) (* length 0.08) "solid" "white")
                    (ellipse (* length 0.07) (* length 0.17) "solid" "black"))))

;;; (mushroom-eyes length) -> drawing?
;;;   length: integer?, non-negative
;;; Aligns to make two eyes.
(define mushroom-eyes
  (lambda (length)
    (beside (mushroom-eye length) 
            (square (/ length 6) "solid" "transparent") 
            (mushroom-eye length))))

;;; (mushroom-body length) -> drawing?
;;;   length: integer?, non-negative
;;; Puts the eyes on top of the mushroom body.
(define mushroom-body
  (lambda (length)
    (overlay/offset (- (/ length 2.98507463)) (- (/ length 2.85714286)) 
                    (mushroom-eyes length) 
                    (mushroom-base length))))

;;; (mushroom-head length color) -> drawing?
;;;   length: integer?, non-negative
;;;   color: string?
;;; Draws the hat/head part of the mushroom.
(define mushroom-head
  (lambda (length color)
    (let ([white-ellipse (ellipse (/ length 4) (/ length 2.2222) "solid" "white")]
          [red-head (ellipse (* length 1.3) (* length 1.02) "solid" color)]
          [white-circle (circle (* length 0.25) "solid" "white")])
    (overlay/align "right" "center"
                   white-ellipse
                   (overlay/align "left" "center"
                                  white-ellipse
                                  (overlay white-circle 
                                           red-head))))))

;;; (mushroom length color) -> drawing?
;;;   length: integer?, non-negative
;;;   color: string?
;;; Draws the complete image of the mushroom.
(define mushroom
  (lambda (length color)
    (overlay/offset (/ length 6.667) (/ length 1.58730159) 
                    (mushroom-head length color) 
                    (mushroom-body length))))

;; Display to test
(mushroom 150 "green")
(mushroom 100 "red")

;; MARIO HAT

;;; (house length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws an image of the part of the hat that looks like a house.
(define house
  (lambda (length)
    (path length
          length
          (list (pair (/ length 2) 0) ; 1
                (pair (* length (/ 7 8)) (* length 0.25)) ; 2
                (pair (* length (/ 7 8)) (/ length 2)) ; 3
                (pair (/ length 8) (/ length 2)) ; 4
                (pair (/ length 8) (* length 0.25)) ;5
          )
          "solid"
          "red")))

;;; (pre-cap length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws an image of the part of the hat that is cap.
(define pre-cap
  (lambda (length)
    (path length
          length
          (list (pair 0 (* length (/ 5 8))) ; 1
                (pair (/ length 8) (/ length 2)) ; 2
                (pair (* length (/ 7 8)) (/ length 2)) ; 3
                (pair length (* length (/ 5 8)))
          )
          "solid"
          darker-red)))

;;; (cap length) -> drawing?
;;;   length: integer?, non-negative
;;; Finishes the look for the cap
(define cap
  (lambda (length)
    (overlay/offset 0 (- (/ length 1.66667)) 
                    (ellipse length (/ length 20) "solid" darker-red)
                    (pre-cap length))))

;;; (mario-hat length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws the who
(define mario-hat
  (lambda (length)
    (overlay/offset (- (/ length 2.73972603)) (- (/ length 5.71428571)) 
                    (mario-ball 27 "red" "white") 
                    (overlay (house length) (cap length)))))

; -------------------------
;;; Kirby 3: Doctor Kirby |
; -------------------------

; ------------------------
;;; Kirby 4: Santa Kirby |
; ------------------------

;; ANIMATION TEST

(define canv (make-canvas 500 500))

;;; (animate-with time) ->
;;;   time:
;;; Change 'basic-kirby' to whichever kirby you need to test.
(animate-with
  (lambda (time)
    (begin
      (draw-rectangle canv 0 0 300 300 "solid" "white")
      (draw-drawing canv
                    (if (odd? (round (* 45 time)))
                        (above basic-kirby feet)
                        (overlay/align "middle" "bottom" basic-kirby feet))
                    0
                    0))))

canv
