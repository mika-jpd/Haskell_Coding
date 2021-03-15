--ghc 8.0.2

-----------------------------------------------------------------------------------------------------------------------------------
-- ---------- Happy Tree Time ----------------
data Node a = Node {t :: String
                   ,name :: String
                   ,value :: a
                   } deriving (Show, Read, Eq)
                    
data Tree a = Empty | Tree (Node a) (Tree a) (Tree a) (Tree a) deriving (Show, Read, Eq)

singleton :: Node a -> Tree a
singleton x = Tree x Empty Empty Empty

treeInsert :: (Eq a) => Node a -> Tree a -> Tree a
treeInsert n Empty = singleton n
treeInsert n@(Node t _ _) (Tree node l m r)
    | t == "Entree" = Tree node (treeInsert n l) m r
    | t == "Plat" = Tree node  l (treeInsert n m) r
    | t == "Dessert" = Tree node l m (treeInsert n r)
    | t == "Supplement" = Tree node l (treeInsert n m) r
    
enrichTree :: (Num a, Eq a) => Tree a -> a -> Tree a -> Tree a
enrichTree Empty vat tree = Empty
enrichTree (Tree (Node node_type node_name node_val) l m r) vat tree = Tree new (enrichTree l vat tree) (enrichTree m vat tree) (enrichTree r vat tree)
    where new = Node{t = node_type, name = node_name, value = node_val*vat}
    
enrichTree_Tree :: (Num a, Eq a) => Tree a -> Tree a -> Tree a -> Tree a
enrichTree_Tree Empty _ new = Empty
enrichTree_Tree x Empty new = x
enrichTree_Tree (Tree (Node node_type node_name val1) l1 m1 r1) (Tree (Node _ _ val2) l2 m2 r2) tree = Tree new (enrichTree_Tree l1 l2 tree) (enrichTree_Tree m1 m2 tree) (enrichTree_Tree r1 r2 tree)
    where new = Node{t = node_type, name = node_name, value = val1*val2}


fold_price :: (Num a, Eq a) => Tree a -> a  
fold_price Empty = 0
fold_price (Tree (Node _ _ val) l m r) = val + (fold_price l) + (fold_price m) + (fold_price r)

stringTree :: (Read a, Show a) => Tree a -> String -> Int -> String
stringTree (Tree (Node t name value) Empty Empty Empty) s x = s ++ show x ++ name ++ show value
stringTree (Tree n l _ _) s x = s ++ stringTree l s (x+1)
stringTree (Tree n _ m _) s x = s ++ stringTree m s (x+1)
stringTree (Tree n _ _ r) s x = s ++ stringTree r s (x+1)

main = do
    let platter = Node{ t = "Platter"
                      ,name = "Cantine"
                      , value = 0
                      }
    let entree = Node { t = "Entree"
                      , value = 4
                      , name = "Oeuf"
                      }
    let plat = Node { t = "Plat"
                      , value = 9
                      , name = "Cheeseburger"
                      }                      
    let desert = Node { t = "Dessert"
                      , value = 4
                      , name = "Fondant"
                      }
    let supplement = Node { t = "Supplement"
                          , value = 1
                          , name = "Cheddar"
                          }

--------------VAT Tree--------------------
    let vat_platter = Node{ t = "Platter"
                      ,name = "Cantine"
                      , value = 0
                      }
    let vat_entree = Node { t = "Entree"
                      , value = 1.20
                      , name = "Oeuf"
                      }
    let vat_plat = Node { t = "Plat"
                      , value = 1.20
                      , name = "Cheeseburger"
                      }                      
    let vat_desert = Node { t = "Dessert"
                      , value = 1.20
                      , name = "Fondant"
                      }
    let vat_supplement = Node { t = "Supplement"
                          , value = 1.20
                          , name = "Cheddar"
                          }

    let tree_plat = singleton platter
    let tree_plat2 = treeInsert entree tree_plat
    let tree_plat3 = treeInsert plat tree_plat2
    let tree_plat4 = treeInsert desert tree_plat3
    let tree_plat5 = treeInsert supplement tree_plat4
    let enriched = enrichTree tree_plat5 1.20 (singleton ((\(Tree n _ _ _) -> n) tree_plat5))
    print(enriched)
    
    let vat_tree_plat = singleton vat_platter
    let vat_tree_plat2 = treeInsert vat_entree vat_tree_plat
    let vat_tree_plat3 = treeInsert vat_plat vat_tree_plat2
    let vat_tree_plat4 = treeInsert vat_desert vat_tree_plat3
    let vat_tree_plat5 = treeInsert vat_supplement vat_tree_plat4
    let enriched2 = enrichTree_Tree tree_plat5 vat_tree_plat5 (singleton ((\(Tree n _ _ _) -> n) tree_plat5))
    
    print(fold_price enriched)
    print(fold_price enriched2)
    print (tree_plat5)
    print(vat_tree_plat5)
    
