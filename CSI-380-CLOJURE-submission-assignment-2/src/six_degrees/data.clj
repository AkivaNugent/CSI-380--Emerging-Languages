; data.clj
; Written by David Kopec and GitHub Copilot
; For CSI 380 Assignment 8

(ns six-degrees.data
  (:gen-class)
  (:require [clojure.string :as str]))

; Parse the movie data files resources/movies_people.txt and resources/people_movies.txt
; into a map of people to a set of movies they were in and a map of movies to a set of
; people who were in them.

(defn read-movies-people
  "Reads the movies_people.txt file and returns a map of movies to a set of people who
  were in them."
  []
  (let [lines (line-seq (clojure.java.io/reader "resources/movies_people.txt"))]
    (reduce (fn [acc line]
              (let [movie (first (str/split line #"\|\|\|\|"))
                    people (set (str/split (or (second (str/split line #"\|\|\|\|")) "||") #"\|\|"))]
                (assoc acc movie people)))
            {}
            lines)))

(defn read-people-movies
  "Reads the people_movies.txt file and returns a map of people to a set of movies they
  were in."
  []
  (let [lines (line-seq (clojure.java.io/reader "resources/people_movies.txt"))]
    (reduce (fn [acc line]
              (let [person (first (str/split line #"\|\|\|\|"))
                    movies (set (str/split (or (second (str/split line #"\|\|\|\|")) "||") #"\|\|"))]
                (assoc acc person movies)))
            {}
            lines)))