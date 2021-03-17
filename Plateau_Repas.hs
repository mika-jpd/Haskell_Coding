-- Petit programme qui permet de créer un plateau-repas et l'enrichir à l'aide d'informations complémentaires
-- sous forme de nombre unique ou organisé dans un deuxième arbre enraciné.

-- t = type de l'élément (plateau, plat, entree, dessert ou suplement)
data Node a = Node {t :: String
                   ,name :: String
                   ,value :: a
                   } deriving (Show, Read, Eq)
                    
data Tree a = Empty | Tree (Node a) (Tree a) (Tree a) (Tree a) deriving (Show, Read, Eq)

-- créé la racine d'un arbre
singleton :: Node a -> Tree a
singleton x = Tree x Empty Empty Empty

-- Insert des éléments de plateau en fonction de leur type. Les types ne son't
-- qu'utilisés afin de placer les éléments et leur information complémentaire au même
-- endroit dans leurs arbres réspectifs.
-- (L'ordre imposé par treeInsert n'est qu'important pour enrichTree_Tree qui suppose que l'arbre
-- à enrichir et l'arbre enrichisseur sont structurellement identique. La structure de l'arbre n'est
-- pas important pour enrichTree_Tree2 qui ne suppose aucune structure de l'arbre enrichisseur et à 
-- enrichir).
treeInsert :: (Eq a, Num a) => Node a -> Tree a -> Tree a
treeInsert n Empty = singleton n
treeInsert n@(Node t _ _) (Tree node l m r)
    | t == "Entree" = Tree node (treeInsert n l) m r
    | t == "Plat" = Tree node  l (treeInsert n m) r
    | t == "Dessert" = Tree node l m (treeInsert n r)
    | t == "Supplement" = Tree node l (treeInsert n m) r
--------------------------------------------------------------------------------------------------------------------------------------------
-- enrichie les données d'un arbre avec une information complémentaire de type 'nombre'
enrichTree_Int :: (Num a, Eq a) => Tree a -> a -> Tree a
enrichTree_Int Empty vat = Empty
enrichTree_Int (Tree (Node node_type node_name node_val) l m r) vat = Tree new (enrichTree_Int l vat) (enrichTree_Int m vat) (enrichTree_Int r vat)
    where new = Node{t = node_type, name = node_name, value = node_val*vat}

--------------------------------------------------------------------------------------------------------------------------------------------
-- enrichi les données d'un arbre avec des données présentes de manière symétrique dans un 
--autre arbre. Utilise la symétrie dans la composition de l'arbre pour enrichir l'arbre
-- cela n'est que possible car treeInsert impose une structure particulière à l'arbre.
enrichTree_Tree :: (Num a, Eq a) => Tree a -> Tree a -> Tree a
enrichTree_Tree Empty _ = Empty
enrichTree_Tree x Empty = x
enrichTree_Tree (Tree (Node node_type node_name val1) l1 m1 r1) (Tree (Node _ _ val2) l2 m2 r2) = Tree new (enrichTree_Tree l1 l2) (enrichTree_Tree m1 m2) (enrichTree_Tree r1 r2)
    where new = Node{t = node_type, name = node_name, value = val1*val2}

---------------------------------------------------------------------------------------------------------------------------------------------
-- Deuxième version pour enrichir l'arbre avec un autre arbre possédant des infos vat à l'aide de deux fonctions. L'avantage de la fonction
-- enrichTree_Tree2 est qu'elle ne suppose aucune structure particulière de l'arbre à enrichir ni de l'arbre enrichisseur.

-- trouve le node à enrichir dans un arbre
find_and_enrich_Node :: (Num a, Eq a) => Node a -> Tree a -> Tree a
find_and_enrich_Node n Empty = Empty
find_and_enrich_Node vat_node@(Node t1 n1 v1) (Tree plateau_node@(Node t2 n2 v2) l m r) =  
    if match then found else recur
    where
        match = ((n1 == n2) && (t1 == t2))
        found = Tree new l m r
            where new = Node {t = t1, name = n1, value = v1*v2}
        recur  = Tree plateau_node (find_and_enrich_Node vat_node l) (find_and_enrich_Node vat_node m) (find_and_enrich_Node vat_node r)
        
-- crée une liste à partir d'un arbre
tree_to_list :: (Num a, Eq a) => Tree a -> [Node a] -> [Node a]
tree_to_list Empty xs = xs
tree_to_list (Tree n l m r) xs = n:xs ++ (tree_to_list l xs) ++ (tree_to_list m xs) ++ (tree_to_list r xs)

-- enrichi les données d'un arbre à partir des infos de chaque node dans une liste
enrichTree_List :: (Num a, Eq a) => Tree a -> [Node a] -> Tree a
enrichTree_List tree [] = tree
enrichTree_List tree (node:xs) = enrichTree_List (find_and_enrich_Node node tree) xs

-- la fonction enrichTree_Tree2 n'est qu'une fonction qui appelle les deux dernières fonctions
enrichTree_Tree2 :: (Num a, Eq a) => Tree a -> Tree a -> Tree a
enrichTree_Tree2 tree1 tree2 = enrichTree_List tree1 (tree_to_list tree2 []) 

-----------------------------------------------------------------------------------------------------------------------------------------------
-- catamorphisme sur un arbre vers un a de type nombre. Calcul le prix total d'un plateau-repas
fold_price :: (Num a, Eq a) => Tree a -> a  
fold_price Empty = 0
fold_price (Tree (Node _ _ val) l m r) = val + (fold_price l) + (fold_price m) + (fold_price r)

-- prend une liste de node avec pour premier élément le node "platter" (plateau) et a pour output
-- un arbre de plateau (avec ou sans suplément). L'ordre des node suivants n'est pas important.
-- (Le but du node "platter" (plateau) est pour que la racine de l'arbre ai du sense dans le context
-- de création d'un plateau repas. On peut imaginé qu'avoir "plateau" (plateau) comme racine annonce en quelque sorte
-- le type de l'arbre)
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
                        , name = "Cantine"
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
------------------Arbre VAT -------------------------------
    let list_nodes_arbre_vat = vat_platter:vat_entree:vat_plat:vat_desert:vat_supplement:[]
    let arbre_vat = platter_creation list_nodes_arbre_vat Empty
    print (tree_to_list arbre_vat [])
    
-----------------Arbre Plateau 1 avec enrichTree_Int--------------------------
    let list_nodes_arbre1 = platter:entree:supplement:plat:desert:[]
    let arbre1 = platter_creation list_nodes_arbre1 Empty
    let enriched_arbre1 = enrichTree_Int arbre1 1.20 
    -- (singleton ((\(Tree n _ _ _) -> n) arbre1))
    
-----------------Arbre Plateau 2 avec enrichTree_Tree--------------------------
    let list_nodes_arbre2 = platter:entree:supplement:plat:desert:[]
    let arbre2 = platter_creation list_nodes_arbre2 Empty
    let enriched_arbre2 = enrichTree_Tree arbre2 arbre_vat 
    --(singleton ((\(Tree n _ _ _) -> n) arbre1))
    
-----------------Arbre Plateau 3 avec enrichTree_Tree2--------------------------
    let list_nodes_arbre3 = platter:entree:supplement:plat:desert:[]
    let arbre3 = platter_creation list_nodes_arbre3 Empty
    let enriched_arbre3 = enrichTree_Tree2 arbre3 arbre_vat 
    
    -- print arbre1 après enrichissement 
    -- 1) VAT fix
    print(enriched_arbre1)
    -- 2)avec enrichTree_Tree
    print(enriched_arbre2)
    -- 3) avec enrichTree_Tree2
    print(enriched_arbre3)
    
    print(fold_price enriched_arbre1)
    print(fold_price enriched_arbre2)
    print(fold_price enriched_arbre3)
