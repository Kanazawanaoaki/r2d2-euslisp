;;モデルの読み込み
(load "package://naoeus/nao.l")
(load "r2d2.l")

;;初期設定
(setq box (make-cube 50 50 50))
(send box :set-color :red)
(send box :locate #f(0 500 25))
(setq *nao* (NaoH25V50))
(send *nao* :locate #f(0 -300 300))
(send *nao* :rotate (deg2rad 90) :z)
(send *nao* :reset-pose)
(setq *r2d2* r)
(send *nao* :head :look-at (send *r2d2* :worldpos))

(objects (list box *r2d2* *nao*))



;;つかむ動作　ここをアニメーションにしたい。angle-vectorシークエンスとか？
(setq l-target-cds (send (send *r2d2* :copy-coords) :translate #f(-135 -225 275)))
(send *nao* :inverse-kinematics
      l-target-cds
      :link-list (send *nao* :link-list (send *nao* :larm :end-coords :parent))
      :move-target (send *nao* :larm :end-coords)
      :rotation-axis nil
      :debug-view t)

(setq r-target-cds (send (send *r2d2* :copy-coords) :translate #f(135 -225 275)))
(send *nao* :inverse-kinematics
      r-target-cds
      :link-list (send *nao* :link-list (send *nao* :rarm :end-coords :parent))
      :move-target (send *nao* :rarm :end-coords)
      :rotation-axis nil
      :debug-view t)

;;(send (send *r2d2* :worldcoords) :translate #f(0 -225 275))

;;座標の連結
(send *nao* :larm :end-coords :assoc *r2d2*)

(unix:sleep 1)
;;持ち上げる
(send *nao* :larm :move-end-pos #f(0 26 15) :world :rotation-axis nil :debug-view t)
(send *nao* :rarm :move-end-pos #f(0 26 15) :world :rotation-axis nil :debug-view t)

(send *nao* :head :look-at (send *r2d2* :worldpos))

;;歩く
;;歩くパターンを作る。
(setq walk-list (send *nao* :calc-walk-pattern-from-footstep-list (send *nao* :go-pos-params->footstep-list 500 0 0)))
;;歩くを描画
(dolist (a walk-list)
	(send *nao* :angle-vector (cadr (memq :angle-vector a)))
	(send *nao* :move-coords (cadr (memq :root-coords a)) (car (send *nao* :links)))
	(send *irtviewer* :draw-objects)
	(x::window-main-one))

;;下ろす
(send *nao* :larm :move-end-pos #f(0 -26 -15) :world :rotation-axis nil :debug-view t)
(send *nao* :rarm :move-end-pos #f(0 -26 -15) :world :rotation-axis nil :debug-view t)

;;座標の連結解除
(send *nao* :larm :end-coords :dissoc *r2d2*)

(send *nao* :reset-pose)
(send *irtviewer* :draw-objects)
