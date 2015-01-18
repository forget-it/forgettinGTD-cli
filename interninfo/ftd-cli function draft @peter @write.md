
# Funktionen

`ftd` ruft ein Shell-Script auf das die Arbeitsweise von *Forgetting Things Done* im Datei-System unterstützt.
`ftd` kann immer nur eine Aktion ausführen, die jeweils in folgendem Shema eingegeben werden.

    ftd [ACTION] [OPTIONS] [FILES]




## Datei als erledigt markieren.

Die Aktion kann auf jede Datei angewendet werden.


    ftd done [OPTIONS] [FILES] 			Markiert Datei als erledigt.

    Options: (default=-d)
      -d DATE, 		--date=date 		Setzt Erledigung Datum. (default=heute)
      				    --nodate 			  Setzt kein Erledigungsdatum.

Beispiele:

    text.md

    ftd done text.md

    x 2015-02-24 text.md





    Remember the Milk

    ftd done -d 2014-05-30 "Remember the Milk"

    x 2014-05-30 Remember the Milk





    table.xls
    picture.png

    ftd done --nodate table.xls picture.png

    x table.xls
    x picture.png



## Als erledigt markierte Dateien als unerledigt markieren





    ftd undone [FILES]                 Markiert Datei als nicht erledigt.


Beispiel:

    x picture.png
    x 2014-05-30 Remember the Milk
    todo.task

    ftd undone picture.png "x 2014-05-30 Remember the Milk" todo.task

    picture.png
    Remember the Milk
    todo.task







## Datei bis zu einem Bestimmten Event ausblenden




    ftd tickler [OPTIONS] [FILES]

    Options: (default=-W)
      -d DATE, 		--date=DATE 		Setzt Tickler auf bestimmtes Datum. (default=heute)
      -D NUMBER,	--days=NUMBER		Setzt Tickler auf Entfernung in Tagen. (default=1)
      -W NUMBER, 	--weeks=NUMBER		Setzt Tickler auf Entfernung in Wochen. (default=1)
      -M NUBER, 	--months=NUMBER		Setzt Tickler auf Entfernung in Monaten. (default=1)
      -n 			--none				Löscht Tickler wenn vorhanden.
      -p FILE       --predecessor=FILE 	Setzt Tickler auf bis File ist erledigt.

Beispiele:

    text.md

    ftd tickler text.md

    .2015-01-08 text.md



    picture.jpg

    ftd tickler -W 4 picture.jpg

    .2015-02-04 picture.jpg






    Schritt 1
    Schritt 2

    ftd tickler -p "Schritt 1" "Schritt 2"

    Schritt 1 @id(2455)
    .@pre(2455) Schritt 2



## Nächste Aktionen anzeigen



    ftd list [OPTIONS] [CONTEXTS]

    Options:

    (Alle Optionen von ls) 				(default = -1, -R)


Beispiele:

    text @Peter .md
    text2.md
    text3 @Peter.md

    ftd list Peter          (Dateien werden nicht verändert)

    text @Peter .md
    text3 @Peter.md







    text @Peter @web.md
    text1 @Peter.md

    ftd list Peter web          (Dateien werden nicht verändert)


    text @Peter @web.md




# Kontexte hinzufügen.


    ftd context [CONTEXT] [OPTIONS] [FILES]
    									Fügt Kontexte vor Endung ein wenn nicht vorhanden.

    Options:
      -c CONTEXT, 	--context=CONTEXTS 	Fügt einen weiteren Context hinzu.


Beispiele:
    


    text.md

    ftd context Peter text.md

    text @Peter .md




    text.md

    ftd context Peter -c web text.md

    text @Peter @web .md


# Kontext entfernen




    ftd uncont [CONTEXT] [FILES]		Löscht Kontext wenn vorhanden.



# System checken

Überprüft tickler und leere Ordner.



    ftd check 


Beispiel:

Es ist der 8. Jänner 2015.

    .2015-01-07 Aufgabe 2
    .2015-02-19 Aufgabe 3
    .pre(1234) Aufgabe 5
    Aufgabe 1
    x Aufgabe 4 id(1234)

    ftd check

    .2015-02-19 Aufgabe 3
    Aufgabe 1
    Aufgabe 2
    Aufgabe 5
    x Aufgabe 4   


# Neue Aufgabe anlegen

Datei wird in INBOX verschoben. Wenn die Datei nicht vorhanden ist, wird sie neu angelegt.



    ftd inbox [FILE]


Beispiele:

    ftd inbox Hallo Welt.txt

    INBOX/Hallo Welt.txt




    ~/text.md
    INBOX/

    ftd inbox ~/text.md

    ~/
    INBOX/text.md














      







































