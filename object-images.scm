; object-images.scm

;;; This file includes all the static images needed for the game.

(import image)

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
    (overlay/offset -3 -6 
                    (circle (* length 0.85) "solid" main-color)
                    (circle length "solid" shadow-color))))

; -------------------------
;;; OBJECT 1: TENNIS BALL |
; -------------------------

;; Color Palette
(define lemon-grass-green (color 197 230 54 1))
(define darker-lemon-grass-green (color 179 223 40 1))

;; Tennis Ball

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
(tennis-ball 100)

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
  (lambda (length) 
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
          "white")))                                      ; color

;; Complete Mario Ball
;;; (mario-ball length) -> drawing?
;;;   length: integer?, non-negative
;;; Draws a complete Mario ball for Kirby to eat.
(define mario-ball
  (lambda (length)
    (overlay (letter-m (* length 1.35))
             (ball length "red" darker-red))))

;; Display to test
(mario-ball 40)
(mario-ball 100)