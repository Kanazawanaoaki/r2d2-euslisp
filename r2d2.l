(defun make-legs nil
  (let (b1 b2 b3 b4 b5 b6 l1)
    (setq b1 (make-cube 20 40 500))
    (setq b2 (make-cylinder 50 20))
    (send b2 :rotate (deg2rad 90) :y)
    (send b2 :locate #f(-250 0 -10))
    (setq b3 (make-cylinder 20 40))
    (send b3 :rotate (deg2rad 90) :y)
    (send b3 :locate #f(-250 0 -20))
    (setq b4 (make-cube 20 100 150))
    (send b4 :locate #f(0 0 180))
    (setq b1 (body+ b1 b4))
    (setq b1 (body- b1 b3))
    (setq b2 (body- b2 b3))
    (setq b5 (make-cube 100 100 270))
    (send b5 :locate #f(0 0 -180))
    (setq b1 (body- b1 b5))
    (send b1 :assoc b2)
    (setq l1 (instance bodyset-link :init (make-cascoords :pos #f(0 0 250)) :bodies (list b1 b2)))
    l1))

;;(setq leg-test (make-legs))
;;(objects leg-test)

(defun make-head nil
  (let (b1 b2 b3 b4 b5 l1)
    (setq b1 (make-sphere 100))
    (setq b2 (make-cube 300 300 120))
    (send b2 :locate #f(0 0 -59))
    (setq b1 (body- b1 b2))
    (setq b3 (make-cylinder 15 20))
    (send b3 :locate #f(0 0 -10))
    (setq b1 (body+ b1 b3))
    (setq b4 (make-cube 20 60 40))
    (send b4 :locate #f(85 0 35))
    (setq b5 (make-cylinder 15 50))
    (send b5 :rotate (deg2rad 90) :y)
    (send b5 :locate #f(-35 0 60))
    (setq b4 (body- b4 b5))
    (send b4 :locate #f(-3 0 5))
    (setq b1 (body+ b1 b4))
    (send b1 :rotate (deg2rad 90) :z)
    (setq l1 (instance bodyset-link :init (make-cascoords) :bodies (list b1)))
    l1))

;;(setq head-test (make-head))
;;(objects head-test)

(defun mini-leg nil
  (let (b1)
    (setq b1 (make-cube 20 40 150))
    b1)))

(defun make-torso nil
  (let (b1 b2 b3 l1)
    (setq b1 (make-cylinder 100 250))
    (setq b2 (make-cylinder 10 250))
    (send b2 :locate #f(-125 0 220))
    (send b2 :rotate (deg2rad 90) :y)
    (setq b3 (mini-leg))
    (send b3 :locate #f(0 0 -30))
    (send b3 :assoc b1)
    (send b1 :assoc b2)
    (setq l1 (instance bodyset-link :init (make-cascoords :pos #f(0 0 -80)) :bodies (list b3 b2 b1)))
    l1))

;;(setq torso1 (make-torso))
;;(objects (list torso1))

(defun make-foot nil
  (let (b1 l1)
    (setq b1 (make-cube 40 80 50))
    (setq l1 (instance bodyset-link :init (make-cascoords) :bodies (list b1)))
    l1))
       

(defclass r2d2
    :super cascaded-link)
(defmethod r2d2
    (:init ()
     (let (head1 leg1 leg2 torso1 c1 c2 foot1 foot2 foot3)
       (send-super :init)
       (setq head1 (make-head));; 頭
       (send head1 :locate #f(0 0 250)) 
       (setq leg1 (make-legs));;足１
       (send leg1 :locate #f(-115 0 -30))
       (setq leg2 (make-legs));;足２
       (send leg2 :locate #f(115 0 -30))
       (setq torso1 (make-torso))
       ;(objects (list torso1 head1 leg1 leg2))
       (send self :assoc torso1)
       (send torso1 :assoc head1)
       (setq c1 (instance cascaded-coords :init))
       (send c1 :locate #f(115 0 220))
       (setq c2 (instance cascaded-coords :init))
       (send c2 :locate #f(-115 0 220))
       (send torso1 :assoc c1)
       (send c1 :assoc leg1)
       (send torso1 :assoc c2)
       (send c2 :assoc leg2)
       (setq foot1 (make-foot))
       (send foot1 :locate #f(-115 0 -60))
       (send leg1 :assoc foot1)
       (setq foot2 (make-foot))
       (send foot2 :locate #f(115 0 -60))
       (send leg2 :assoc foot2)
       (setq foot3 (make-foot))
       (send foot3 :locate #f(0 0 -90))
       (send foot3 :assoc torso1)
       (send foot3 :locate #f(0 0 115))
			 (send self :assoc foot3)
       (setq joint-list
	     (list (instance rotational-joint
			     :init :parent-link torso1 :child-link head1
			     :axis :z)
		   (instance rotational-joint
			     :init :parent-link torso1 :child-link leg1
			     :axis :x)
		   (instance rotational-joint
			     :init :parent-link torso1 :child-link leg2
			     :axis :x)
		   (instance rotational-joint
			     :init :parent-link leg1 :child-link foot1
			     :axis :x)
		   (instance rotational-joint
			     :init :parent-link leg2 :child-link foot2
			     :axis :x)
		   (instance rotational-joint
			     :init :parent-link foot3 :child-link torso1
			     :axis :x)))
       (setq links (list torso1 head1 leg1 leg2 foot1 foot2 foot3))
       (send self :init-ending)
       )))

(setq r (instance r2d2 :init))
(objects (list r))
(send r :angle-vector #f(30.0 -30.0 -30.0 0.0 0.0 30.0))
