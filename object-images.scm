; object-images.scm

;;; This file includes all the static images needed for the game.

(import image)

;;; OBJECTS DRAWING

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