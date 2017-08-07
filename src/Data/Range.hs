{-# LANGUAGE DeriveAnyClass #-}
module Data.Range
( Range(..)
, rangeLength
, offsetRange
, intersectsRange
) where

import Control.DeepSeq
import Data.Semigroup
import GHC.Generics
import Test.LeanCheck

-- | A half-open interval of integers, defined by start & end indices.
data Range = Range { start :: {-# UNPACK #-} !Int, end :: {-# UNPACK #-} !Int }
  deriving (Eq, Show, Generic, NFData)

-- | Return the length of the range.
rangeLength :: Range -> Int
rangeLength range = end range - start range

-- | Offset a range by a constant delta.
offsetRange :: Range -> Int -> Range
offsetRange a b = Range (start a + b) (end a + b)

-- | Test two ranges for intersection.
intersectsRange :: Range -> Range -> Bool
intersectsRange range1 range2 = start range1 < end range2 && start range2 < end range1


-- Instances

instance Semigroup Range where
  Range start1 end1 <> Range start2 end2 = Range (min start1 start2) (max end1 end2)

instance Ord Range where
  a <= b = start a <= start b

instance Listable Range where
  tiers = cons2 Range