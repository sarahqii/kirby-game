; images.scm

;;; This file includes all the static images needed for the game.

(import image)
(import canvas)
(import music)

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
  (lambda (length color1 color2)
    (overlay (make-star (+ length 0.8) "outline" color1)
             (make-star length "solid" color2))))

;; Complete ball

;;; (basic-ball length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws the image of a complete basic Kirby ball.
(define basic-ball
  (lambda (length) 
    (overlay (star (* length 1.2) "white" star-yellow)
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
;;; OBJECT 4: Christmas Ball   |
; -----------------------------

(define tree
  (overlay/offset -5 11 (triangle 23 "solid" "seagreen")
          (overlay/offset -2 10 (triangle 28 "solid" "seagreen")
                                (triangle 33 "solid" "seagreen"))))

;;; Tree-body
;;; Addes the start and tree trunk to the leaf part
(define tree-body
    (above (circle 4 "solid" "gold") tree (rectangle 4 12 "solid" "brown")))

;;; Christmas-ball
;;; Creates a final Christmas ball for Kirby to eat. 
(define Christmas-ball
  (overlay tree-body (overlay/offset 1 0.5 (circle 38 "solid" "darkslateblue") (circle 39 "solid" "gray"))
  ))

Christmas-ball
        
; ------------------------
;;; Kirby 0: Basic Kirby |
; ------------------------

;;; (base-head size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the image of the base head for basic kirby.
(define base-head
  (lambda (size)
    (overlay/offset 
      (- (* 0.0005 size)) 
      (- (* 0.0005 size)) 
      (circle size "solid" "pink")
      (circle (* 1.008 size) "solid" "palevioletred"))))

;;; (arm size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws one arm.
(define arm
  (lambda (size)
    (overlay/offset 
      (- (* 0.0005 size)) 
      (- (* 0.0005 size)) 
      (ellipse (* 0.7 size) (* 0.5 size) "solid" "pink")
      (ellipse (* 0.71 size) (* 0.51 size) "solid" "palevioletred"))))

;;; (arms size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws two arms.
(define arms
  (lambda (size)
    (beside (arm size) (circle (* 0.6 size) "solid" "white") (arm size))))

;;; (head size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the body (head with arms) of kirby.
(define head
  (lambda (size)
    (overlay/align "middle" "center" (base-head size) (arms size))))

;;; (blush size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws blush
(define blush
  (lambda (size)
    (beside (ellipse (* 0.3 size) (* 0.15 size) "solid" "hotpink")
            (rectangle (* 0.8 size) (* 0.1 size) "solid" "pink")
            (ellipse (* 0.3 size) (* 0.15 size) "solid" "hotpink"))))

;;; (balck-eye-base size) -> drawing?
(define black-eye-base
  (lambda (size)
    (overlay/offset
      (- (* 0.04 size))
      (- (* 0.02 size))
      (ellipse (* 0.17 size) (* 0.3 size) "solid" "white")
      (ellipse (* 0.25 size) (* 0.6 size) "solid" "black"))))

;;; (eye-blue size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws blue part of eye.
(define eye-blue
  (lambda (size)
    (overlay/offset
      0
      (* 0.04 size)
      (circle (* 0.05 size) "solid" "black")
      (ellipse (* 0.14 size) (* 0.2 size) "solid" "mediumblue"))))

;;; (eye size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws one eye.
(define eye
  (lambda (size)
    (overlay/offset (- (* 0.07 size)) (- (* 0.35 size)) 
                    (eye-blue size) 
                    (black-eye-base size))))

;;; (face-1 size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws a face with one eye.
(define face-1
  (lambda (size)
    (overlay/offset (- (* 1.5 size)) (- (* 0.4 size)) 
                    (eye size) 
                    (head size))))

;;; (mouth size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws a mouth.
(define mouth
  (lambda (size)
    (overlay/align "middle" "bottom" 
                   (ellipse (* 0.3 size) (* 0.17 size) "solid" "red") 
                   (circle (* 0.2 size) "solid" "black"))))

;;; (mouth-and-blush size) -> drawing?
;;;   size: integer?, non-negative
;;; Align the mouth and blush.
(define mouth-and-blush
  (lambda (size)
    (above (blush size) (mouth size))))

;;; (face-2 size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the face with two eyes.
(define face-2
  (lambda (size)
    (overlay/offset (- (* 0.85 size)) (- (* 0.4 size)) 
                    (eye size) 
                    (face-1 size))))

;;; (face size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the complete face.
(define face
  (lambda (size)
    (overlay/offset (- (* 0.6 size)) (- size) 
                    (mouth-and-blush size) 
                    (face-2 size))))

;;; (feet size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the feet.
(define feet
  (lambda (size)
    (beside 
      (ellipse (* 0.7 size) (* 0.5 size) "solid" "red") 
      (circle (* 0.15 size) "solid" "white") 
      (ellipse (* 0.7 size) (* 0.5 size) "solid" "red"))))

;;; (basic-kirby size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the complete basic kirby.
(define basic-kirby
  (lambda (size)
    (overlay/align "middle" "bottom" 
                   (face size) 
                   (feet size))))

;;; (basic-kirby-offset size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the basic kirby but offset feet for animation.
(define basic-kirby-offset
  (lambda (size)
    (overlay/offset (* 0.46 size)
                    (* 1.6 size)
                    (face size) 
                    (feet size))))

;; ANIMATION TEST

(define canv (make-canvas 400 400))

;; (animate-with time) -> animation?
;;   time: number?, a non-negative number
;; Animation for basic-kirby.
(ignore
  (animate-with
    (lambda (time)
      (begin
        (draw-rectangle canv 0 0 300 300 "solid" "white")
        (draw-drawing canv
                      (if (odd? (round (* 60 time)))
                          (basic-kirby 100)
                          (basic-kirby-offset 100))
                      0
                      0)))))

canv

; --------------------------------
;;; Kirby 1: Tennis Player Kirby |
; --------------------------------

;;; (racket-frame size) -> image?
;;;   size : number?, non-negative
;;; Draws the frame of the racket. 
(define racket-frame
  (lambda (size)
    (overlay
      (ellipse (* 0.8 size) size "solid" "white")
      (ellipse (* 0.86 size) (* 1.06 size) "solid" "blue"))))

;;; (racket-string size) -> image?
;;;   size : number?, non-negative
;;; Draws one string of the racket, length = size.
(define racket-string
  (lambda (size)
    (rectangle (* 0.02 size) size "solid" "black")))

;;; (racket-frame-with-strings size) -> image?
;;;   size : number?, non-negative
;;; Draws the frame of the racket with strings.
(define racket-frame-with-strings
  (lambda (size)
    (overlay
      (racket-string size)
      (racket-frame size))))

;;; (racket-connect size) -> image?
;;;   size : number?, non-negative
;;; Draws the connecting part of the racket. 
(define racket-connect
  (lambda (size)
    (rotate 180 
      (overlay
        (triangle (* 0.59 size) "solid" "white")
        (triangle (* 0.73 size) "solid" "black")))))

;;; (racket-connected size) -> image?
;;;   size : number?, non-negative
;;; Draws the connecting part of the racket combined with the racket frame. 
(define racket-connected
  (lambda (size)
    (overlay/offset (* 0.065 size) (* 0.8 size) 
                    (racket-frame-with-strings size) 
                    (racket-connect size))))

;;; (racket-handle size) -> image?
;;;   size : number?, non-negative
;;; Draws the handle of the racket. 
(define racket-handle
  (lambda (size)
    (rectangle (* 0.2 size) (* 0.6 size) "solid" "black")))

;;; (racket size) -> image?
;;;   size : number?, non-negative
;;; Draws the full racket. 
(define racket
  (lambda (size)
    (overlay/offset (- (* 0.33 size)) (- (* 1.24 size)) 
                    (racket-handle size) 
                    (racket-connected size))))

;;; (headband size) -> image?
;;;   size : number?, non-negative
;;; Draws a headband with a stripe.
(define headband
  (lambda (size)
    (overlay (rectangle (* 1.6 size) (* 0.08 size) "solid" "white")
             (rectangle (* 1.6 size) (* 0.2 size) "solid" "black"))))

;;; (kirby-with-headband size) -> image?
;;;   size : number?, non-negative
;;; Draws kirby with the headband.
(define kirby-with-headband
  (lambda (size)
    (overlay/offset (- (* 0.5 size))
                    (- (* 0.2 size))
                    (headband size)
                    (basic-kirby size))))

;;; (kirby-with-racket size) -> image?
;;;   size : number?, non-negative
;;; Draws kirby with the tennis racket.
(define kirby-with-racket
  (lambda (size)
    (overlay/offset (- (* 0.28 size)) (- (* 0.55 size)) 
                    (kirby-with-headband size) 
                    (racket size))))

;;; (tennis-kirby-ball-down size) -> image?
;;;   size : number?, non-negative
;;; Draws tennis kirby with the ball on the ground. 
(define tennis-kirby-ball-down
  (lambda (size)
    (overlay/offset (* 2.6 size) (* 2.2 size) 
                    (kirby-with-racket size) 
                    (tennis-ball (* 0.18 size)))))

;;; (tennis-kirby-ball-down size) -> image?
;;;   size : number?, non-negative
;;; Draws tennis kirby with the ball in his hand.
(define tennis-kirby-ball-up
  (lambda (size)
    (overlay/offset (* 2.6 size) (* 1.6 size) 
                    (kirby-with-racket size) 
                    (tennis-ball (* 0.18 size)))))

;;; An animation of tennis kirby bouncing the ball up and down.
(ignore
  (animate-with
    (lambda (time)
      (begin
        (draw-rectangle canv 0 0 2000 2000 "solid" "white")
        (draw-drawing canv
                      (if (odd? (round (* 60 time)))
                          (tennis-kirby-ball-down 100)
                          (tennis-kirby-ball-up 100))
                      0
                      0)))))
canv
        
; ------------------------
;;; Kirby 2: Mario Kirby |
; ------------------------

;; Color Palette
(define mushroom-base-color (color 255 227 184 1))
(define mustache-brown (color 65 38 37 1))

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

;; MUSTACHE

;;; (mustache length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws mustache.
(define mustache
  (lambda (length)
    (let* ([dot (circle (* length 0.1) "solid" mustache-brown)]
           [align (lambda (img) (overlay/offset (/ length 8) 0 dot img))])
      (apply beside (map align (make-list 2 (align dot)))))))

;; COMPLETE MARIO KIRBY

;;; (mario-wears-hat size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws image of mario kirby with hat on.
(define mario-wears-hat
  (lambda (size)
    (overlay/offset (- (/ size 4)) (/ size 1.08695652) 
                    (mario-hat (* size 2)) 
                    (basic-kirby size))))

;;; (mario-with-mustache size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws image of mario kirby with hat and mustache.
(define mario-with-mustache
  (lambda (size)
    (overlay/offset (- (/ size 1.58730159)) (- (* size 2))
                    (mustache (* size 1.5)) 
                    (mario-wears-hat size))))

;;; (mario-kirby size) -> drawing?
;;;   size: integer?, non-negative
;;; Draws the complete image of Mario Kirby.
(define mario-kirby
  (lambda (size)
    (overlay/offset (- (* size 3.1)) (- (/ size 1.66667))
                    (mushroom size "red")
                    (overlay/offset (/ size 1.11111111) (- (* size 1.8))
                                    (mushroom (/ size 1.11111111) "green")
                                    (mario-with-mustache size)))))

;; Display to test
(mario-kirby 100)

; -------------------------
;;; Kirby 3: Doctor Kirby |
; -------------------------

; ------------------------
;;; Kirby 4: Santa Kirby |
; ------------------------

;;; (santa-mustache size) -> drawing?
;;;   size : integer? (non-negative)
;;; Returns a white mustache. 
(define santa-mustache
  (lambda (size)
                (path (* 19 size)
                      (* 19 size)
                      (list (pair (* size 1.15) (* size 0))      ; 1st point
                            (pair (* size 1.8) (* size 0.19))    ; 2nd point
                            (pair (* size 2.075) (* size 0.575)) ; 3rd point
                            (pair (* size 1.8) (* size 0.575))   ; 4th point
                            (pair (* size 1.96) (* size 0.96))   ; 5th point 
                            (pair (* size 1.73) (* size 0.925))  ; 6th point
                            (pair (* size 1.15) (* size 1.4))    ;7th point
                            (pair (* size 0.575) (* size 0.925)) ; 8th pint
                            (pair (* size 0.345)  (* size 0.96)) ; 9 th pint
                            (pair (* size 0.5) (* size 0.575))   ; 10th pint
                            (pair (* size 0.23) (* size 0.575))  ; 11th pint
                            (pair (* size 0.5) (* size 0.19))    ; 12th point
                            (pair (* size 1.15) (* size 0)))     ; top point (need to return)
                      "solid"
                      "white" )))

;;; (nose size) -> drawing?
;;;  size : integer? (non-negative)
;;; Returns a dark red nose. 
(define nose
  (lambda (size)
    (ellipse (* size 0.45) (* size 0.25) "solid" "firebrick")))

;;; (mustache-with-nose size) -> drawing?
;;;  size : integer? (non-negative)
;;; Returns a combined nose and white mustache. 
(define mustache-with-nose
  (lambda (size)
     (overlay/offset (* -0.9 size) (* 0.1 size) 
                     (nose size) 
                     (santa-mustache size))))

;;; (mustache-with-nose size) -> drawing?
;;;  size : integer? (non-negative)
;;; Returns a combined nose, white mustache, and dark red nose.
(define mustache-with-nose-and-blush
  (lambda (size)
     (overlay/offset (* 0.4 size) (* 0 size) 
                     (mustache-with-nose size) 
                     (blush size))))

;;; (santa-face size) -> drawing?
;;;  size : integer? (non-negative)
;;; Returns a santa kirby face.
(define santa-face
  (lambda (size)
    (overlay/offset (- (* 0.18 size)) (- (* 1 size)) 
                    (mustache-with-nose-and-blush size) 
                    (face-2 size))))

;;; (basic-santa-kirby size) -> drawing?
;;;   size : integer? (non-negative)
;;; Returns a basic santa kirby with just head, arm, mustache with blush and nose, and feet.
(define basic-santa-kirby
  (lambda (size)
    (overlay/offset (* 0.47 size) (* 1.5 size) 
                    (face size) 
                    (feet size))))

;;; (santa-hat-base size) -> drawing?
;;; size : integer? (non-negative)
;;; Returns a base santa hat.
(define santa-hat-base
  (lambda (size)
  (overlay/offset (* 0.16 size) (* -1.1 size) 
    (overlay (ellipse (* 1.95 size) (* 0.45 size) "solid" "white")
                      (ellipse (* 2 size) (* 0.5 size) "solid" "goldenrod"))
     (overlay (triangle (* 1.55 size) "solid" "firebrick") 
              (triangle (* 1.7 size) "solid" "maroon")))))

;;; (santa-hat size) -> drawing?
;;; size : integer? (non-negative)
;;; Returns a final santa hat with the white ball on top of santa-hat-base.
(define santa-hat
  (lambda (size)
    (overlay/offset (* -0.78 size) (* 0.23 size) 
                    (overlay (circle (* 0.2 size) "solid" "white")
                             (circle (* 0.22 size) "solid" "goldenrod"))
                    (santa-hat-base size))))

;;; (circle-1 size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns the outermost red circle.
(define circle-1 
  (lambda (size)
    (circle (* 0.5 size) "solid" "red")))

;;; (circle-2 size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns the 2nd outermost orange circle.
(define circle-2 
  (lambda (size)
    (circle (* 0.4 size) "solid" "orange")))

;;; (circle-3 size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns the 3rd outermost yellow circle.
(define circle-3 
  (lambda (size)
    (circle (* 0.3 size) "solid" "yellow")))

;;; (circle-4 size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns the 4th outermost green circle.
(define circle-4 
  (lambda (size)
    (circle (* 0.2 size) "solid" "green")))

;;; (circle-5 size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns the 5th outermost blue circle.
(define circle-5 
  (lambda (size)
    (circle (* 0.1 size) "solid" "blue")))

;;; (circle-6 size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns the innermost violet circle.
(define circle-6 
  (lambda (size)
    (circle (* 0.05 size) "solid" "violet")))

;;; (candy size) -> drawing?
;;; size : integer? (non-negative)
;;; Returns a drawing with all the circles on top of each other.
(define candy 
  (lambda (size)
    (overlay (circle-6 size) 
             (circle-5 size) (circle-4 size) (circle-3 size) 
             (circle-2 size) (circle-1 size))))

;;; (stick size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns a brown stick drawing.
(define stick
  (lambda (size)
    (rectangle (* 0.1 size) (* 0.9 size) "solid" "brown")))

;;; (lollipop size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns a final drawing of lollipop.
(define lollipop
   (lambda (size)
     (above (candy size) (stick size))))

;;; (santa-kirby-with-lollipop size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns a drawing with kirby holding the lollipop
(define santa-kirby-with-lollipop
  (lambda (size)
      (overlay/offset (* -0.7 size) (* -0.4 size) 
                      (basic-santa-kirby size) 
                      (beside (square 15 "solid" "black") 
                              (rotate 345 (lollipop size))))))

;;; (final-santa-kirby size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns a final Santa kirby drawing.
(define final-santa-kirby
  (lambda (size)
     (overlay/offset (* -0.97 size) (* 1.1 size) 
                     (santa-hat size) 
                     (santa-kirby-with-lollipop size))))

;;; (final-santa-kirby-with-background size) -> drawing?
;;; size : integer? (non-negative)
;;;; Returns a final santa kirby in a black background so that we can see his mustache.
(define fina-santa-kirby-with-background
  (lambda (size)
  (overlay/offset (* -1 size) (* -1.8 size) 
                  (final-santa-kirby size) 
                  (rectangle (* 9 size) (* 7 size) "solid" "black"))))

(fina-santa-kirby-with-background 100)

canv

; ---------------------
;;; Background canvas |
; ---------------------

;; Color Palette
(define bg-yellow (color 253 211 36 1))
; star-yellow

(define background (rectangle 1000 600 "solid" bg-yellow))
(define dots
  (let* ([dot (overlay (circle 5 "solid" star-yellow) 
                       (square 20 "solid" "transparent"))]
         [1-row (apply beside (make-list 10 dot))])
    (apply above (make-list 5 1-row))))

(define star-0 (star 40 star-yellow star-yellow))
(define star-1 (star 60 star-yellow star-yellow))
(define star-2 (star 80 star-yellow star-yellow))
(define star-3 (star 100 star-yellow star-yellow))
(define star-4 (star 150 star-yellow star-yellow))

dots
star-0
star-1
star-2
star-3
star-4

; ---------------------
;;; Ball Click Effect |
; ---------------------


; ----------------
;;; Sound Effect |
; ----------------


; -----------
;;; The BGM |
; -----------

;;; The main part of the bgm.
(define main-bgm
  (seq (note 72 qn)
       (rest qn)
       (note 67 qn)
       (rest qn)
       (note 63 qn)
       (note 62 qn)
       (note 60 qn)
       (rest qn)
       (note 60 qn)
       (note 62 qn)
       (note 63 qn)
       (note 60 qn)
       (note 58 qn)
       (note 60 qn)
       (note 55 qn)
       (rest qn)
       (note 72 qn)
       (rest qn)
       (note 67 qn)
       (rest qn)
       (note 63 qn)
       (note 62 qn)
       (note 60 qn)
       (note 60 en)
       (note 62 en)
       (note 63 qn)
       (note 65 qn)
       (note 62 qn)
       (note 58 qn)
       (note 60 qn)
       (note 55 qn)
       (note 60 qn)
       (rest qn)))

;;; One part of the underlying bgm.
(define underlying-bgm-1
  (seq (note 57 en)
       (par (note 72 en)
            (note 69 en)
            (note 63 en))
       (note 52 en)
       (par (note 72 en)
            (note 69 en)
            (note 63 en))
       (note 57 en)
       (par (note 72 en)
            (note 69 en)
            (note 63 en))
       (note 52 en)
       (par (note 72 en)
            (note 69 en)
            (note 63 en))))

;;; Another part of the underlying bgm.
(define underlying-bgm-2
  (seq (note 62 en)
       (par (note 74 en)
            (note 69 en)
            (note 65 en))
       (note 57 en)
       (par (note 74 en)
            (note 69 en)
            (note 66 en))
       (note 62 en)
       (par (note 74 en)
            (note 69 en)
            (note 66 en))
       (note 57 en)
       (par (note 74 en)
            (note 69 en)
            (note 66 en))))

;;; Another part of the underlying bgm.
(define underlying-bgm-3
  (seq (note 52 en)
       (par (note 74 en)
            (note 69 en)
            (note 65 en))
       (note 59 en)
       (par (note 74 en)
            (note 69 en)
            (note 66 en))
       (note 63 en)
       (par (note 71 en)
            (note 67 en)
            (note 63 en))
       (note 56 en)
       (par (note 71 en)
            (note 67 en)
            (note 63 en))))

;;; The full underlying bgm.
(define underlying-bgm
  (seq (repeat 2 underlying-bgm-1)
       underlying-bgm-2
       (repeat 3 underlying-bgm-1)
       underlying-bgm-3
       underlying-bgm-1))

;;; The full bgm, the main and underlying bgm combined, repeated twice.
(repeat 2
  (mod (tempo qn 180) 
     (par (mod (dynamics 80) (mod (instrument 60) main-bgm))
          (mod (dynamics 10) (mod (instrument 57) underlying-bgm)))))
; 61 is best, but doesn't work for certain sounds
; 60, 57, 58
