<?php /*

<?php /*

[General]

# Retecivica
AllowedTypes[]=Singolo
AllowedTypes[]=Lista
AllowedTypes[]=Lista3
AllowedTypes[]=Lista4
AllowedTypes[]=Eventi
AllowedTypes[]=Iosono
AllowedTypes[]=FeedRSS
AllowedTypes[]=VideoPlayer
AllowedTypes[]=ContentSearch
AllowedTypes[]=GMapItems
AllowedTypes[]=GMap
AllowedTypes[]=AreaRiservata

# Intranet
#AllowedTypes[]=DynamicItems
#AllowedTypes[]=Banner
#AllowedTypes[]=BannerFolder
#AllowedTypes[]=BloccoNews
#AllowedTypes[]=Manual3Items
#AllowedTypes[]=RicercaAvanzata
#AllowedTypes[]=ItemList
#AllowedTypes[]=Events

[AreaRiservata]
Name=Login Area Riservata
ManualAddingOfItems=disabled
CustomAttributes[]=parent_node_id
CustomAttributes[]=testo
CustomAttributeTypes[testo]=text
UseBrowseMode[parent_node_id]=true
ViewList[]=accesso_area_riservata
ViewName[accesso_area_riservata]=Accesso area riservata

[GMapItems]
Name=Google Map Items
ManualAddingOfItems=disabled
CustomAttributes[]=parent_node_id
CustomAttributes[]=class
CustomAttributes[]=attribute
CustomAttributes[]=limit
CustomAttributes[]=width
CustomAttributes[]=height
UseBrowseMode[parent_node_id]=true
ViewList[]=geo_located_content
ViewList[]=geo_located_content_osm
ViewName[geo_located_content]=Geo-Located Content (Google Map)
ViewName[geo_located_content_osm]=Geo-Located Content (Open Layers)

[GMap]
Name=Google Map
ManualAddingOfItems=disabled
CustomAttributes[]=location
CustomAttributes[]=key
ViewList[]=gmap
ViewName[gmap]=Google Map

[PushToBlock]
# List of content classes using Layout datatype
ContentClasses[]=frontpage
# The subtree node ID from which to fetch objects with Layout datatype
RootSubtree=1

[Singolo]
Name=Oggetto singolo
NumberOfValidItems=1
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=singolo_img
ViewList[]=singolo_imgtit
ViewList[]=singolo_img_interne
ViewList[]=singolo_imgtit_interne
ViewList[]=singolo_img_interne_piccolo
ViewList[]=singolo_imgtit_interne_piccolo
ViewList[]=singolo_box_piccolo
ViewList[]=singolo_box
ViewList[]=singolo_banner
ViewName[singolo_img]=Solo immagine (grande)
ViewName[singolo_imgtit]=Immagine e Titolo (grande)
ViewName[singolo_img_interne]=Solo immagine (media, con titolo blocco)
ViewName[singolo_imgtit_interne]=Immagine e Titolo (media)
ViewName[singolo_img_interne_piccolo]=Solo immagine (con blocco titolo)
ViewName[singolo_imgtit_interne_piccolo]=Immagine e Titolo (media, con titolo blocco)
ViewName[singolo_box_piccolo]=Titolo, immagine (piccola) e abstract (con blocco titolo)
ViewName[singolo_box]=Titolo, immagine e abstract (con blocco titolo)
ViewName[singolo_banner]=Titolo, immagine (piccola) e abstract (con blocco titolo, sfondo grigio)


[Lista]
Name=Lista di oggetti (assegnare un contenitore)
NumberOfValidItems=1
NumberOfArchivedItems=0
CustomAttributes[]=node_id
UseBrowseMode[node_id]=true
CustomAttributes[]=livello_profondita
CustomAttributes[]=limite
CustomAttributes[]=includi_classi
CustomAttributes[]=escludi_classi
CustomAttributes[]=ordinamento
ManualAddingOfItems=disabled
ViewList[]=lista_num
ViewList[]=lista_accordion
ViewList[]=lista_box
ViewList[]=lista_carousel
#ViewList[]=lista_carousel_rassegna
#ViewList[]=lista_carousel_rassegna_oggi
ViewName[lista_num]=Box con numerini
ViewName[lista_accordion]=Schede (accordion)
ViewName[lista_box]=Elenco 
ViewName[lista_carousel]=Schede (carousel)
#ViewName[lista_carousel_rassegna]=Schede (carousel rassegna)
#ViewName[lista_carousel_rassegna_oggi]=Schede (carousel rassegna oggi)
TTL=3600
# List of content classes using Layout datatype

[Lista3]
Name=Lista di oggetti (assegnati singolarmente) - MAX 5
NumberOfValidItems=5
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=lista_accordion_manual
ViewList[]=lista_box2
#ViewList[]=lista_box3
ViewList[]=lista_box4
#ViewList[]=lista_box5
ViewList[]=lista_tab
ViewName[lista_accordion_manual]=Schede (accordion)
ViewName[lista_box2]=Box a 3 colonne (3 oggetti)
#ViewName[lista_box3]=Box di news
ViewName[lista_box4]=Box ultimi figli (3 oggetti)
#ViewName[lista_box5]=Box ultimi figli (no folder/homepage)
ViewName[lista_tab]=Schede (tab)

[Lista4]
Name=Lista di oggetti (assegnati singolarmente) - MAX 15
NumberOfValidItems=15
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=lista_accordion_manual
ViewList[]=lista_box2
ViewList[]=lista_tab
ViewName[lista_accordion_manual]=Schede (accordion)
ViewName[lista_box2]=Box a 3 colonne (3 oggetti)
ViewName[lista_tab]=Schede (tab)

[Eventi]
Name=Eventi (oggi e prossimamente)
NumberOfValidItems=1
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=eventi
ViewName[eventi]=Eventi (tab)

[Iosono]
Name=Schede Homepage (Io sono, eventi della vita, ecc...)
NumberOfValidItems=5
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=iosono
ViewName[iosono]=Schede (tab)

[FeedRSS]
Name=Feed reader
ManualAddingOfItems=disabled
CustomAttributes[]=source
CustomAttributes[]=limit
CustomAttributes[]=offset
ViewList[]=feed_reader
ViewName[feed_reader]=Feed reader
ViewList[]=feed_meteo
ViewName[feed_meteo]=Feed meteo

[VideoPlayer]
Name=Video Player
NumberOfValidItems=3
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=video_ez
ViewName[video_ez]=eZ Player
ViewList[]=video_flow
ViewName[video_flow]=Flow Player
ViewList[]=video_flow_playlist
ViewName[video_flow_playlist]=Flow Player Playlist (piccola)
ViewList[]=video_flow_playlist_big
ViewName[video_flow_playlist_big]=Flow Player Playlist (grande)

[ContentSearch]
Name=Motori di ricerca
ManualAddingOfItems=disabled
CustomAttributes[]=node_id
UseBrowseMode[node_id]=true
CustomAttributes[]=class
CustomAttributes[]=attribute
ViewList[]
ViewName[]
ViewList[]=search_class_and_attributes
ViewName[search_class_and_attributes]=Cerca per classe e attributi
#ViewList[]=search_class
#ViewName[search_class]=Cerca in questa posizione
ViewList[]=search_free_ajax
ViewName[search_free_ajax]=Ricerca libera
#ViewList[]=class_filter
#ViewName[class_filter]=Filtra per classe

[DynamicItems]
Name=Filtra oggetti (Dinamico)
NumberOfValidItems=10
NumberOfArchivedItems=0
ManualAddingOfItems=disabled
UseBrowseMode=true
FetchClass=eZFlowFetchNodes
FetchParameters[]
FetchParameters[Source]=nodeID
FetchParametersSelectionType[Source]=single
FetchParameters[URL]=URL
FetchParametersSelectionType[URL]=single
FetchParameters[Classes]=Classes
FetchParametersSelectionType[Classes]=single
FetchParameters[Limit]=Limit
FetchParametersSelectionType[Limit]=single
FetchParameters[IncludeExclude]=IncludeExclude
FetchParametersSelectionType[IncludeExclude]=single
FetchParameters[Sort_by]=Sort_by
FetchParametersSelectionType[Sort_by]=single
ViewList[]=dynamic_items
ViewName[dynamic_items]=Filtro gli nodi
TTL=10

[Banner]
Name=Banner
NumberOfValidItems=1
NumberOfArchivedItems=0
ManualAddingOfItems=disabled
ViewList[]=banner1
ViewList[]=banner2
ViewName[banner1]=Banner (medium)
ViewName[banner2]=Banner (small)

[BannerFolder]
Name=Bottone
NumberOfValidItems=1
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=bannerfolder_big
ViewList[]=bannerfolder_medium
ViewList[]=bannerfolder_small
ViewList[]=bannerfolder_items
ViewList[]=bannerfolder_con_folderfigli
ViewList[]=bannerfolder_newsletter
ViewList[]=bannerfolder_circolare
ViewList[]=bannerfolder_link
ViewName[bannerfolder_big]=Esuberante (col dx folder)
ViewName[bannerfolder_medium]=Remissivo (col dx frontpage)
ViewName[bannerfolder_small]=Super-remissivo (col sx frontpage)
ViewName[bannerfolder_items]=Box con icona, nome folder e recenti items (no folder)
ViewName[bannerfolder_con_folderfigli]=Box con icona, nome folder e figli folder
ViewName[bannerfolder_newsletter]=Box con banner e newsletter
ViewName[bannerfolder_circolare]=Box con banner e circolare
ViewName[bannerfolder_link]=Box con banner e link

[BloccoNews]
Name=Blocco News generale
NumberOfValidItems=5
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=tutti
ViewList[]=bacheca_sindacale
ViewList[]=circolare
ViewList[]=comunicato_stampa
ViewList[]=documento
ViewList[]=graduatoria
ViewList[]=guida
ViewList[]=modulistica
ViewList[]=modulo
ViewList[]=news
ViewList[]=notiziario_circolo
ViewList[]=regolamento
ViewName[tutti]=Qualsiasi tipo di classe
ViewName[bacheca_sindacale]=Bacheche sindacali
ViewName[circolare]=Circolari
ViewName[comunicato_stampa]=Comunicati stampa
ViewName[documento]=Documenti
ViewName[graduatoria]=Graduatorie
ViewName[guida]=Guide
ViewName[modulistica]=Modulistica
ViewName[modulo]=Moduli
ViewName[news]=News
ViewName[notiziario_circolo]=Notiziari circolo
ViewName[regolamento]=Regolamenti

[Manual3Items]
Name=3 items (Manual)
NumberOfValidItems=3
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=3_items1
ViewList[]=3_items2
ViewList[]=3_items3
ViewName[3_items1]=3 items (1)
ViewName[3_items2]=3 items (2)
ViewName[3_items3]=3 items (3 cols)

[RicercaAvanzata]
Name=Motore di ricerca avanzata
NumberOfValidItems=20
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=advanced_search
ViewList[]=simple_search
ViewList[]=telefoni_search
ViewName[advanced_search]=Ricerca Avanzata
ViewName[simple_search]=Ricerca Semplice
ViewName[telefoni_search]=Ricerca Telefoni

[ItemList]
Name=Item list
NumberOfValidItems=12
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=itemlist1
ViewList[]=itemlist2
ViewList[]=itemlist3
ViewName[itemlist1]=List (1 col)
ViewName[itemlist2]=List (2 cols)
ViewName[itemlist3]=List (3 cols)

[Events]
Name=Calendario Eventi (intranet)
NumberOfValidItems=1
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
ViewList[]=events1
ViewList[]=events2
ViewList[]=events3
ViewName[events1]=events1
ViewName[events2]=events2
ViewName[events3]=events3

[Eventi]
ViewName[eventi]=Eventi (Box con numerini)
       
*/ ?>
