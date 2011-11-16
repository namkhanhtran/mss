# Pipeline


## Phase 1 - Initial distinct word list
  **Input**: distinct word list from text corpus and word list from cleared Flickr dataset 

  **Output**: intersection of two word lists (F)

## Phase 2 - Create word pairs
  **Input**: word list F

  **Output**: Cartesian product F x F

## Phase 3 - Filter out word pairs
  **Input**: Set of word pairs (F x F)

  **Output**: Filter out the pair that the frequencies of words are less than a threshold (5, 10??)

## Phase 4 - Get final word pairs
  **Input**: Thres\_word pairs and probably the distribution that we want to test

  **Output**: Using WordNet (e.g implemented in NLTK) to get the final set

## Phase 5 - Create gold standard
  **Input**: Final set of word pairs

  **Output**: Gold standard (e.g for WordSim)
