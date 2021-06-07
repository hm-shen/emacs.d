;;; init.el --- Initialization file for Emacs  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs
;;; Package --- Summary
;;; Code:
(require 'org)
(org-babel-load-file
  (expand-file-name "configs.org" user-emacs-directory))

(provide 'init)
;;; init.el ends here
