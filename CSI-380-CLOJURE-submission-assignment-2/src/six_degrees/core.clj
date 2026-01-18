; core.clj
; Six Degrees of Kevin Bacon
; Starter code by David Kopec
; for Champlain College CSI 380 Emerging Languages
; April, 2023
; See LICENSE

(ns six-degrees.core
  (:gen-class)
  (:require [six-degrees.data :as data]))

(defn get_neighbors
  [people-movies movies-people current explored]
  (let [neighbors (if (contains? people-movies current)
                        (get people-movies current)
                        (get movies-people current)
                        )
        ]
    (filter
      (fn [personOrMovie]
        (not (contains? explored personOrMovie))
        )
      neighbors
      )
    )
  )

(defn rebuild_path
  [expl end]
  (reverse
    (loop [path [end]
            personOrMovie end
            ]
      (let [previous (get expl personOrMovie)
            ]
        (if (nil? previous)
          path
          (recur (conj path previous) previous)
          )
        )
      )
    )
  )


; Find the path between two actors using breadth-first search
(defn find-path
  "Finds the path between two actors using breadth-first search. Returns a list of strings (a path) including the actors and any co-stars/movies between them."
  [people-movies movies-people start end]
  ; BFS - Queue for frontier, map for explored
  ; end if queue is empty or goal is reached
  ; check neighbors -> check explored ->(ifnot) add to frontier
  ; - if current is a person, get a movies. vice versa
  ; - helper func for get neighbors/alternating
  (let [frontier (conj clojure.lang.PersistentQueue/EMPTY start)
        explored {start nil}
        ]
    (loop [front frontier expl explored]
      (if (empty? front)
        nil
        (let [current (peek front)
              remaining_front (pop front)
              ]
          (if (= current end)
            (rebuild_path expl end)
            (let [neighbors (get_neighbors people-movies movies-people current expl)
                  updated_expl (reduce
                            (fn [expl_map node]
                              (assoc expl_map node current)
                              )
                            expl
                            neighbors
                            )
                  updated_front (reduce
                                  conj remaining_front neighbors
                                )
                  ]
              (recur updated_front updated_expl)
              )
            )
          )
        )
      )
    )
  )

(defn print-path
  "Print a nicely formatted path out of a sequence of strings."
  [path]
  (println (clojure.string/join " -> " path)))

(defn -main
  "Find a path between two actors via movies and co-stars."
  [& args]
  (if (not (= 2 (count args)))
    (println "Expect 2 actors as arguments.")
    (let [movies-people (data/read-movies-people)
        people-movies (data/read-people-movies)]
      (print-path (find-path people-movies movies-people (first args) (second args))))))
