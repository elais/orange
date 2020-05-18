(define-module (flat packages)
  #:use-module (guix profiles)
  #:use-module (flat packages emacs))

(packages->manifest
 (list emacs-native-comp))
