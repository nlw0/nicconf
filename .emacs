(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(indicate-empty-lines t)
 '(scroll-preserve-screen-position 1)
 '(server-kill-new-buffers t))

(if (not (server-mode)) (server-start))

(add-to-list 'default-frame-alist '(font . "Monospace-7"))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(horizontal-scroll-bars . nil))

;;; Marmalade stuff
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;;; Little things
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(load-theme 'monokai t)

;;; From Stefan Monnier <foo at acm.org>. This is the opposite of
;;; fill-paragraph (M-q). Takes a multi-line paragraph and makes it
;;; into a single line of text.
(defun unfill-paragraph ()
  (interactive)
    (let ((fill-column (point-max)))
      (fill-paragraph nil)))
;;; Assign to a key.
(global-set-key (kbd "M-Q") 'unfill-paragraph)

(global-set-key [delete] 'delete-char)
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [C-end] 'end-of-buffer)
; entradas necesarias para XEmacs:
(global-set-key [(control home)] 'beginning-of-buffer)
(global-set-key [(control end)] 'end-of-buffer)

;;;
;;; When you paste something with the mouse, use the current position
;;; of the cursor instead of moving to where the mouse pointer is
;;; first.
(setq mouse-yank-at-point t)

(delete-selection-mode 1)

;;; Turns off the splashscreen, menu and scrollbar. God I hate'em!
(setq inhibit-splash-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
;;; Show the time in the minibuffer 
(display-time) 
;;; Replace yes/no+enter prompts with y/n prompts
(fset 'yes-or-no-p 'y-or-n-p)
;;; Turn on the column numbering in the minibuffer 
(column-number-mode 1)
;;; Format the title-bar to always include the buffer name
(setq frame-title-format "emacs - %b")

;;; Show matching parenthesis
(setq show-paren-mode 1)

;;;Provide access to system clipboard
(setq x-select-enable-clipboard t)
;;;Change default major mode to text instead of fundamental
(setq major-mode 'text-mode)
;;;Don't automatically add new lines when scrolling down at the bottom of a buffer
(setq next-line-add-newlines nil)
;;;Scroll just one line when hitting the bottom of the window
(setq scroll-step 1)
(setq scroll-conservatively 10000)

(require 'highlight-parentheses)

;;; Set paren-matching everywhere possible
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

(require 'wc-mode)

(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(setq py-autopep8-options '("--max-line-length=100"))

(global-unset-key (kbd "C-n"))

(require 'multiple-cursors)

(define-key (current-global-map) (kbd "C-n C-n") 'mc/edit-lines)
(define-key (current-global-map) (kbd "C-n C-b") 'mc/mark-all-like-this-dwim)

(require 'flycheck)
(require 'pyimpsort)

(add-hook 'after-init-hook #'global-flycheck-mode)

; (require 'flycheck-tip)

(add-hook 'python-mode-hook
	  '(lambda ()
	     ;; (define-key python-mode-map "\C-c\C-d" 'add-doc-string)
	     (define-key python-mode-map (kbd "C-n C-i") (lambda () (interactive) (pyimport-remove-unused) (pyimpsort-buffer)))
	     (define-key python-mode-map (kbd "C-,") #'flycheck-next-error)
	     ;(define-key python-mode-map (kbd "C-n ,") 'flycheck-tip-cycle)
	     )
	  )


;; To avoid echoing error message on minibuffer (optional)
;; (setq flycheck-display-errors-function 'ignore)

(global-set-key (kbd "M-SPC") 'hippie-expand)

;;; function to toggle comments
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-line)))
(global-set-key (kbd "C-;") 'comment-or-uncomment-region-or-line)

;;; Deactivate C-z on gui
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z C-z") 'my-suspend-frame)
(defun my-suspend-frame ()
  "In a GUI environment, do nothing; otherwise `suspend-frame'."
  (interactive)
  (if (display-graphic-p)
      (message "suspend-frame disabled for graphical displays.")
    (suspend-frame)))

;; I hate tabs!
(setq-default indent-tabs-mode nil)

;; Mail mode conf
(defun my-mail-mode-hook ()
  (auto-fill-mode 1)
  (flyspell-mode 1)
  )
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'mail-mode-hook 'my-mail-mode-hook)

;;(provide 'emacs)
;;; .emacs ends here
