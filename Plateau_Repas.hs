
-- Petit programme qui permet de créer un plateau-repas et l'enrichir à l'aide d'informations complémentaires
-- sous forme de nombre unique ou organisé dans un deuxième arbre enraciné.


data Node a = Node {t :: String
                   ,name :: String
                   ,value :: a
                   } deriving (Show, Read, Eq)
                    
data Tree a = Empty | Tree (Node a) (Tree a) (Tree a) (Tree a) deriving (Show, Read, Eq)

-- créé la racine d'un arbre
singleton :: Node a -> Tree a
singleton x = Tree x Empty Empty Empty

-- insert des éléments de plateau en fonction de leur type. Les types ne son't
-- qu'utilisés afin de placer les éléments et leur information complémentaire au même
-- endroit dans leurs arbres réspectifs.
treeInsert :: (Eq a) => Node a -> Tree a -> Tree a
treeInsert n Empty = singleton n
treeInsert n@(Node t _ _) (Tree node l m r)
    | t == "Entree" = Tree node (treeInsert n l) m r
    | t == "Plat" = Tree node  l (treeInsert n m) r
    | t == "Dessert" = Tree node l m (treeInsert n r)
    | t == "Supplement" = Tree node l (treeInsert n m) r
    
-- enrichie les données d'un arbre avec une information complémentaire de type 'nombre'
enrichTree_Int :: (Num a, Eq a) => Tree a -> a -> Tree a -> Tree a
enrichTree_Int Empty vat tree = Empty
enrichTree_Int (Tree (Node node_type node_name node_val) l m r) vat tree = Tree new (enrichTree_Int l vat tree) (enrichTree_Int m vat tree) (enrichTree_Int r vat tree)
    where new = Node{t = node_type, name = node_name, value = node_val*vat}

-- enrichi les données d'un arbre avec des données présentes de manière symétrique dans un 
--autre arbre
enrichTree_Tree :: (Num a, Eq a) => Tree a -> Tree a -> Tree a -> Tree a
enrichTree_Tree Empty _ new = Empty
enrichTree_Tree x Empty new = x
enrichTree_Tree (Tree (Node node_type node_name val1) l1 m1 r1) (Tree (Node _ _ val2) l2 m2 r2) tree = Tree new (enrichTree_Tree l1 l2 tree) (enrichTree_Tree m1 m2 tree) (enrichTree_Tree r1 r2 tree)
    where new = Node{t = node_type, name = node_name, value = val1*val2}

-- catamorphisme sur un arbre vers un a de type nombre. Calcul le prix total d'un plateau-repas
fold_price :: (Num a, Eq a) => Tree a -> a  
fold_price Empty = 0
fold_price (Tree (Node _ _ val) l m r) = val + (fold_price l) + (fold_price m) + (fold_price r)

-- prend une liste de node avec pour premier élément le node "platter" (plateau) et a pour output
-- un arbre de plateau (avec ou sans suplément). L'ordre des node suivants n'est pas important.
platter_creation :: (Num a, Eq a) => [Node a] -> Tree a -> Tree a
platter_creation [] tree = tree
platter_creation (x:xs) tree = platter_creation xs (treeInsert x tree)

main = do
-----------------Nodes (élements) du PLateau----------------
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

--------------Nodes VAT--------------------
    let vat_platter = Node{ t = "Platter"
                      ,name = "Cantine"
                      , value = 0
                      }
    let vat_entree = Node { t = "Entree"
                      , value = 1.2
                      , name = "Oeuf"
                      }
    let vat_plat = Node { t = "Plat"
                      , value = 1.20
                      , name = "Cheeseburger"
                      } 
    let vat_desert = Node { t = "Dessert"
                      , value = 1.2
                      , name = "Fondant"
                      }
    let vat_supplement = Node { t = "Supplement"
                          , value = 1.2
                          , name = "Cheddar"
                          }
-----------------Arbre Plateau--------------------------
    let list_nodes_arbre1 = platter:plat:entree:supplement:desert:[]
    let arbre1 = platter_creation list_nodes_arbre1 Empty
    let enriched = enrichTree_Int arbre1 1.20 (singleton ((\(Tree n _ _ _) -> n) arbre1))
    
------------------Arbre VAT-------------------------------
    let list_nodes_arbre_vat = vat_platter:vat_entree:vat_plat:vat_desert:vat_supplement:[]
    let arbre_vat = platter_creation list_nodes_arbre_vat Empty
    let enriched2 = enrichTree_Tree arbre1 arbre_vat (singleton ((\(Tree n _ _ _) -> n) arbre1))

    --print arbre1 après enrichissement 
    -- 1) VAT fix
    print(enriched)
    -- 2)VAT différent par node
    print(enriched2)
    --print(fold_price enriched)
    print(fold_price enriched)
    print(fold_price enriched2)
