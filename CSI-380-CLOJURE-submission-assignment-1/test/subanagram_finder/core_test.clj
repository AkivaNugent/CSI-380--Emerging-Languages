(ns subanagram-finder.core-test
  (:require [clojure.test :refer :all]
            [subanagram-finder.core :refer :all]))

(deftest load-dictionary-test
  (testing "Loading dictionary failed."
    (let [dictionary (load-dictionary)]
      (is (and 
             (= (count dictionary) 99171)
             (= (first dictionary) "A")
             (= (second dictionary) "A's")
             (= (last dictionary) "études")
             (= dictionary (sort dictionary)))))))
        

(deftest find-sub-anagram-test1
  (testing "Finding sub-anagrams failed."
    (is      (= (find-sub-anagrams "loot" '("too" "dollar" "pool" "tool")) '("too" "tool")))))
      

(deftest find-sub-anagram-test2
  (testing "Finding sub-anagrams failed."
    (is    (= (find-sub-anagrams "at" '("a", "t", "aa", "tt", "at", "Ta", "aaa", "tat")) '("a" "t" "at" "Ta"))
      )))
(deftest generate-output-test1
  (testing "Generating output failed"
    (is (= (generate-output []) ""))))
      

(deftest generate-output-test2
  (testing "Generating output failed"
    (is (= (generate-output ["tea", "ok"]) "A At E T Ta a at ate e eat eta t tea\nK O OK k o"))))

(deftest generate-output-test3
  (testing "Generating output failed"
    (is (= (generate-output ["salami", "hotdog", "pepper"])
           "A Al Ala Ali Alisa Alma Am As Asia I Ila Islam L La Li Lima Lisa M Mai Mali Masai Mia Ms S Sal Sam Si Siam Sm a ail ails aim aims alas alias alms am as i is ism l la lam lama lamas lams ls m ma mail mails mas mi mil mils ms s sail salami slam slim\nD Dot G Gd God Godot Good Goth H Hg Ho Hood O T Th Tod Togo d do dog dot doth g go god goo good got h ho hod hog hood hoot hot o oh oho t tho to tog too\nE Er P R Re Rep e ere p pee peep peer pep pepper per prep r re rep"))))


      
      
      
