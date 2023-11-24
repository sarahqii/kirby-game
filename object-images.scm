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