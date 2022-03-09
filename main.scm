(use-modules (system foreign)
             (system foreign-library))

(define libsink (dynamic-link "libsink"))

; (define c_main
;   (pointer->procedure double
;                       (dynamic-func "main" libsink)
;                       (list double)))

(define c_main_ptr (foreign-library-pointer "libsink" "main"))

; (define c_note
;   (pointer->procedure double
;                       (dynamic-func "afunc" libsink)
;                       (list double)))

(define c_main
  (pointer->procedure double
                      c_main_ptr
                      (list double)))
; (newline)
; (display (j0 0.3))
; (newline)
(display (c_main 3.0))
