; test.clj
; Six Degrees of Kevin Bacon
; Written by David Kopec
; for Champlain College CSI 380 Emerging Languages
; April, 2023
; See LICENSE

(ns six-degrees.core-test
  (:require [clojure.test :refer :all]
            [six-degrees.core :refer :all]
            [six-degrees.data :as data]))

(defonce movies-people (data/read-movies-people))
(defonce people-movies (data/read-people-movies))

(defn check-people
  [path]
  (every? true? (map #(contains? people-movies %) (take-nth 2 path))))

(defn check-movies
  [path]
  (every? true? (map #(contains? movies-people %) (take-nth 2 (rest path)))))

(deftest smg-fpj-test
  (testing "Sarah Michelle Gellar -> Freddie Prinze Jr."
    (let [result (find-path people-movies movies-people "Sarah Michelle Gellar" "Freddie Prinze Jr.")]
      (print-path result)
      (is (= (count result) 3))
      (is (= (first result) "Sarah Michelle Gellar"))
      (is (= (last result) "Freddie Prinze Jr."))
      (is (check-movies result))
      (is (check-people result)))))

(deftest tom-tom-test
  (testing "Tom Cruise -> Tom Hanks"
    (let [result (find-path people-movies movies-people "Tom Cruise" "Tom Hanks")]
      (print-path result)
      (is (= (count result) 5))
      (is (= (first result) "Tom Cruise"))
      (is (= (last result) "Tom Hanks"))
      (is (check-movies result))
      (is (check-people result)))))

(deftest mb-sh-test
  (testing "Marlon Brando -> Salma Hayek"
    (let [result (find-path people-movies movies-people "Marlon Brando" "Salma Hayek")]
      (print-path result)
      (is (= (count result) 5))
      (is (= (first result) "Marlon Brando"))
      (is (= (last result) "Salma Hayek"))
      (is (check-movies result))
      (is (check-people result)))))

(deftest ch-kh-test
  (testing "Christina Hendricks -> Katharine Hepburn"
    (let [result (find-path people-movies movies-people "Christina Hendricks" "Katharine Hepburn")]
      (print-path result)
      (is (= (count result) 7))
      (is (= (first result) "Christina Hendricks"))
      (is (= (last result) "Katharine Hepburn"))
      (is (check-movies result))
      (is (check-people result)))))

(deftest ml-hh-test
  (testing "Martin Lawrence -> Helen Hunt"
    (let [result (find-path people-movies movies-people "Martin Lawrence" "Helen Hunt")]
      (print-path result)
      (is (= (count result) 7))
      (is (= (first result) "Martin Lawrence"))
      (is (= (last result) "Helen Hunt"))
      (is (check-movies result))
      (is (check-people result)))))
