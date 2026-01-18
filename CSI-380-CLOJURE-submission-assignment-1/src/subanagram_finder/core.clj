(ns subanagram-finder.core
  "Clojure Sub-anagram Finder. Usage:
    lein run -- word [word ...]

   Champlain College
   CSI-380 Spring 2019"
  (:gen-class))

(require '[clojure.string :as str])

(defn letter-frequencies
  [word]
  (
    let [chars (seq (str/lower-case word))]
      (
        frequencies chars
        )
    )
  )

(defn load-dictionary
  "Load list of words from disk."
  ([] (load-dictionary "resources/words"))
  ([file-name]
   (
     with-open [rdr (clojure.java.io/reader file-name)]
     (
       let [lines (into [] (line-seq rdr))]
       (
         map str/trim lines
             )
       )
     )
   )
  )


(defn find-sub-anagrams
  "Find all the words in word-list that are sub-anagrams of word.

  A sub-anagram means it is an anagram of a substring of word."
  [word, word-list]
  (
    let [word-length (count word)
         letter-counts (letter-frequencies word)
         ]
    (
      filter
      (
        fn [other-word]
        (if (< word-length (count other-word))
          false
          (
            let [other-letter-counts (letter-frequencies other-word)]
            (
              every?
              (
                fn [letter]
                (
                  >= (get letter-counts letter 0)
                     (get other-letter-counts letter 0)
                     )
                )
              (
                keys other-letter-counts
                     )
              )
            )
          )
        )
      word-list
      )
    )
  )

(defn generate-output
  "Generate the output.

   For each word the output contains a line with all the sub-anagrams of that
   word (in sorted order) separated by spaces.
   Example: (generate-output [\"tea\", \"ok\"]) ->
            \"A At E T Ta a at ate e eat eta t tea\nK O OK k o\"
  "
  [words]
  (
    let [dictionary (load-dictionary)
         all-anagrams (map #(find-sub-anagrams % dictionary) words)
         ]
    (
      str/join "\n" (map #(str/join " " (sort %)) all-anagrams)
               )
    )
  )



(defn -main
  "Main function, generates the output and prints it to the console."
  [& args]
  (if (= 0 (count args))
    ;; then
    (println "Usage:\n\tlein run -- word [word ...]")
    ;; else
    (println (generate-output args)))
  )
