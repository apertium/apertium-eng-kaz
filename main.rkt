#lang racket

; Racket interface for apertium-eng-kaz
;
; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide kaz-eng
         kaz-eng-from-pretransfer-to-biltrans
         kaz-eng-from-t1x-to-postgen)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

(define (symbol-append s1 s2)
  (string->symbol (string-append (symbol->string s1) (symbol->string s2))))

(define A-ENG-KAZ './)
(define A-KAZ-ENG-BIL (symbol-append A-ENG-KAZ 'kaz-eng.autobil.bin))
(define A-KAZ-ENG-T1X (symbol-append A-ENG-KAZ 'apertium-eng-kaz.kaz-eng.t1x))
(define A-KAZ-ENG-T1X-BIN (symbol-append A-ENG-KAZ 'kaz-eng.t1x.bin))
(define A-KAZ-ENG-T2X (symbol-append A-ENG-KAZ 'apertium-eng-kaz.kaz-eng.t2x))
(define A-KAZ-ENG-T2X-BIN (symbol-append A-ENG-KAZ 'kaz-eng.t2x.bin))
(define A-KAZ-ENG-T3X (symbol-append A-ENG-KAZ 'apertium-eng-kaz.kaz-eng.t3x))
(define A-KAZ-ENG-T3X-BIN (symbol-append A-ENG-KAZ 'kaz-eng.t3x.bin))
(define A-KAZ-ENG-GEN (symbol-append A-ENG-KAZ 'kaz-eng.autogen.bin))

(define (kaz-eng s)
  (parameterize ([current-directory (pkg-directory "apertium-eng-kaz")])
    (rash
     "echo (values s) | apertium -d . kaz-eng")))

(define (kaz-eng-from-pretransfer-to-biltrans s)
  (parameterize ([current-directory (pkg-directory "apertium-eng-kaz")])
    (rash
     "echo (values s) | apertium-pretransfer | "
     "lt-proc -b (values A-KAZ-ENG-BIL)")))

(define (kaz-eng-from-t1x-to-postgen s)
  (parameterize ([current-directory (pkg-directory "apertium-eng-kaz")])
    (rash
     "echo (values s) | "
     "apertium-transfer -b (values A-KAZ-ENG-T1X) (values A-KAZ-ENG-T1X-BIN) | "
     "apertium-interchunk (values A-KAZ-ENG-T2X) (values A-KAZ-ENG-T2X-BIN) | "
     "apertium-postchunk (values A-KAZ-ENG-T3X) (values A-KAZ-ENG-T3X-BIN) | "
     "lt-proc -g (values A-KAZ-ENG-GEN)")))