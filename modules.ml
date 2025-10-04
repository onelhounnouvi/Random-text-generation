type ltable = (string * string list) list
module STable = Map.Make(String)
module PTable = Map.Make(struct
    type t = string list
    let compare = compare
  end)
type distribution =
  { total : int ;
    amounts : (string * int) list }
type stable = distribution STable.t
type ptable =
  { prefix_length : int ;
    table : distribution PTable.t }

let simple_0 =
  "I am a man and my dog is a good dog and a good dog makes a good man"

let simple_1 =
  "a good dad is proud of his son and a good son is proud of his dad"

let simple_2 =
  "a good woman is proud of her daughter and a good daughter is proud of her mom"

let simple_3 =
  "there is a beer in a fridge in a kitchen in a house in a land where \
   there is a man who has a house where there is no beer in the kitchen"

let multi_1 =
  "A good dad is proud of his son. \
   A good son is proud of his dad."

let multi_2 =
  "A good woman is proud of her daughter. \
   A good daughter is proud of her mom."

let multi_3 =
  "In a land of myths, and a time of magic, \
   the destiny of a great kingdom rests \
   on the shoulders of a young man."
