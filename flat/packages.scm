(define-module (flat packages)
  #:use-module (guix packages)
  #:use-module (flat packages emacs))

(packages->manifest
 (list emacs-native-comp))
